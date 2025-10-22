import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: ramTaskManager
    width: 600
    height: 400

    property color headerColor: "#2E7D32"
    property color rowEvenColor: "#1E1E1E"
    property color rowOddColor: "#252525"
    property color textColor: "white"
    property color highlightColor: "#4CAF50"
    property int updateInterval: 3000

    // Danh sách process
    property var processList: []
    // Biến hiển thị thời gian cập nhật
    property string lastUpdateTime: Qt.formatTime(new Date(), "hh:mm:ss")

    // Cập nhật dữ liệu định kỳ
    Timer {
        id: refreshTimer
        interval: updateInterval
        running: true
        repeat: true
        onTriggered: processFetcher.running = true
    }

    // Cập nhật thời gian hiển thị từng giây
    Timer {
        id: clockTimer
        interval: 3000
        running: true
        repeat: true
        onTriggered: {
            ramTaskManager.lastUpdateTime = Qt.formatTime(new Date(), "hh:mm:ss")
        }
    }

    Process {
        id: processFetcher
        running: false
        stdout: StdioCollector { id: processOutput }

        command: [Qt.resolvedUrl("../../scripts/task-manager-ram.py")]

        onExited: {
            try {
                var txt = processOutput.text ? processOutput.text.trim() : ""
                if (txt !== "") {
                    const data = JSON.parse(txt)
                    ramTaskManager.processList = data
                    ramTaskManager.lastUpdateTime = Qt.formatTime(new Date(), "hh:mm:ss")
                } else {
                    console.warn("Process script returned empty output")
                }
            } catch (e) {
                console.error("Process parse error:", e, "\nOutput was:", processOutput.text)
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#1A1A1A"
        radius: 8
        border.color: "#333"
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            // Header
            Rectangle {
                Layout.fillWidth: true
                height: 40
                color: headerColor
                radius: 6

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12

                    Text {
                        text: "🔍 Task Manager - Top Processes by RAM"
                        color: "white"
                        font.bold: true
                        font.pointSize: 14
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: "Cập nhật: " + lastUpdateTime
                        color: "#CCCCCC"
                        font.pointSize: 10
                    }
                }
            }

            // Column headers
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text { text: "PID"; color: "#CCCCCC"; font.bold: true; font.pointSize: 11; Layout.preferredWidth: 60 }
                Text { text: "Process Name"; color: "#CCCCCC"; font.bold: true; font.pointSize: 11; Layout.fillWidth: true }
                Text { text: "RAM %"; color: "#CCCCCC"; font.bold: true; font.pointSize: 11; Layout.preferredWidth: 70; horizontalAlignment: Text.AlignRight }
                Text { text: "Memory"; color: "#CCCCCC"; font.bold: true; font.pointSize: 11; Layout.preferredWidth: 100; horizontalAlignment: Text.AlignRight }
            }

            // List view cho processes
            ListView {
                id: processListView
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: ramTaskManager.processList
                clip: true
                spacing: 1

                delegate: Rectangle {
                    width: processListView.width
                    height: 36
                    color: index % 2 === 0 ? rowEvenColor : rowOddColor
                    radius: 4

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 8

                        Text { text: modelData.pid; color: "#4FC3F7"; font.family: "Monospace"; font.pointSize: 10; Layout.preferredWidth: 60 }
                        Text { text: modelData.name; color: textColor; font.pointSize: 10; elide: Text.ElideRight; Layout.fillWidth: true }
                        Text {
                            text: modelData.percent.toFixed(1) + "%"
                            color: modelData.percent > 10 ? "#FF6B6B" :
                                   modelData.percent > 5 ? "#FFA726" : "#4CAF50"
                            font.family: "Monospace"
                            font.pointSize: 10
                            font.bold: modelData.percent > 5
                            Layout.preferredWidth: 70
                            horizontalAlignment: Text.AlignRight
                        }
                        Text {
                            text: modelData.rss_mb.toFixed(1) + " MB"
                            color: textColor
                            font.family: "Monospace"
                            font.pointSize: 10
                            Layout.preferredWidth: 100
                            horizontalAlignment: Text.AlignRight
                        }
                    }

                    // Progress bar nhỏ bên dưới
                    Rectangle {
                        anchors { left: parent.left; right: parent.right; bottom: parent.bottom; margins: 4 }
                        height: 2
                        radius: 1
                        color: "#333"

                        Rectangle {
                            width: parent.width * Math.min(modelData.percent / 50, 1)
                            height: parent.height
                            radius: 1
                            color: modelData.percent > 10 ? "#FF6B6B" :
                                   modelData.percent > 5 ? "#FFA726" : "#4CAF50"
                        }
                    }
                }

                // Empty state
                Rectangle {
                    visible: processListView.count === 0
                    anchors.fill: parent
                    color: "transparent"

                    Column {
                        anchors.centerIn: parent
                        spacing: 8
                        Text { text: "⏳"; font.pointSize: 24; color: "#666" }
                        Text { text: "Đang tải danh sách process..."; color: "#666"; font.pointSize: 12 }
                    }
                }
            }

            // Footer
            Rectangle {
                Layout.fillWidth: true
                height: 30
                color: "transparent"
                border.color: "#333"
                border.width: 1
                radius: 4

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 8

                    Text { text: "Tổng số process: " + processListView.count; color: "#CCCCCC"; font.pointSize: 10 }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: "Tổng RAM: " + calculateTotalRAM().toFixed(1) + " MB"
                        color: "#CCCCCC"
                        font.pointSize: 10
                        font.bold: true
                    }
                }
            }
        }
    }

    // Hàm tính tổng RAM
    function calculateTotalRAM() {
        var total = 0
        for (var i = 0; i < processList.length; i++) {
            total += processList[i].rss_mb
        }
        return total
    }

    Component.onCompleted: processFetcher.running = true
}


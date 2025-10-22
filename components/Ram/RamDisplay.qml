import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell.Io
import Quickshell

Item {
    id: ramDisplay
    width: 320
    height: 140

    property color usedRamColor: "#4CAF50"       // xanh lá
    property color freeRamColor: "#444"          // xám
    property color usedSwapColor: "#2196F3"      // xanh dương
    property color freeSwapColor: "#444"         // xám
    property int ramPercent: 0
    property int swapPercent: 0
    property int updateInterval: 2000
    
    // Thêm các property mới để lưu thông tin chi tiết
    property int ramTotal: 0
    property int ramUsed: 0
    property int ramFree: 0
    property int ramAvailable: 0
    property int swapTotal: 0
    property int swapUsed: 0
    property int swapFree: 0

    Timer {
        interval: updateInterval
        running: true
        repeat: true
        onTriggered: ramFetcher.running = true
    }

    Process {
        id: ramFetcher
        running: false
        stdout: StdioCollector { id: outputCollector }

        command: [Qt.resolvedUrl("../../scripts/free-json")]

        onExited: {
            try {
                var txt = outputCollector.text ? outputCollector.text.trim() : ""
                if (txt !== "") {
                    const data = JSON.parse(txt)
                    ramDisplay.ramPercent = data.memory.used_percent
                    ramDisplay.swapPercent = data.swap.used_percent
                    
                    // Lấy thông tin chi tiết
                    ramDisplay.ramTotal = data.memory.total_mb
                    ramDisplay.ramUsed = data.memory.used_mb
                    ramDisplay.ramFree = data.memory.free_mb
                    ramDisplay.ramAvailable = data.memory.available_mb
                    ramDisplay.swapTotal = data.swap.total_mb
                    ramDisplay.swapUsed = data.swap.used_mb
                    ramDisplay.swapFree = data.swap.free_mb
                } else {
                    console.warn("RAM script returned empty output")
                }
            } catch (e) {
                console.error("RAM parse error:", e, "\nOutput was:", outputCollector.text)
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        // RAM Section
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4

            // Header với phần trăm
            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: "RAM"
                    color: "white"
                    font.bold: true
                    font.pointSize: 11
                }
                Item { Layout.fillWidth: true } // Spacer
                Text {
                    text: ramPercent + "%"
                    color: "white"
                    font.bold: true
                    font.pointSize: 11
                }
            }

            // Progress bar
            Rectangle {
                Layout.fillWidth: true
                height: 16
                radius: 8
                color: freeRamColor

                Rectangle {
                    width: parent.width * (ramPercent / 100)
                    height: parent.height
                    radius: 8
                    color: usedRamColor
                    Behavior on width { NumberAnimation { duration: 500 } }
                }
            }

            // Chi tiết RAM
            GridLayout {
                Layout.fillWidth: true
                columns: 2
                rowSpacing: 2
                columnSpacing: 10

                Text {
                    text: "Đã dùng:"
                    color: "#CCCCCC"
                    font.pointSize: 9
                }
                Text {
                    text: ramUsed + " MB / " + ramTotal + " MB"
                    color: "white"
                    font.pointSize: 9
                    font.bold: true
                }

                Text {
                    text: "Còn trống:"
                    color: "#CCCCCC"
                    font.pointSize: 9
                }
                Text {
                    text: ramFree + " MB"
                    color: "white"
                    font.pointSize: 9
                }

                Text {
                    text: "Khả dụng:"
                    color: "#CCCCCC"
                    font.pointSize: 9
                }
                Text {
                    text: ramAvailable + " MB"
                    color: "white"
                    font.pointSize: 9
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: "#555555"
        }

        // SWAP Section
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4

            // Header với phần trăm
            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: "SWAP"
                    color: "white"
                    font.bold: true
                    font.pointSize: 11
                }
                Item { Layout.fillWidth: true } // Spacer
                Text {
                    text: swapPercent + "%"
                    color: "white"
                    font.bold: true
                    font.pointSize: 11
                }
            }

            // Progress bar
            Rectangle {
                Layout.fillWidth: true
                height: 12
                radius: 6
                color: freeSwapColor

                Rectangle {
                    width: parent.width * (swapPercent / 100)
                    height: parent.height
                    radius: 6
                    color: usedSwapColor
                    Behavior on width { NumberAnimation { duration: 500 } }
                }
            }

            // Chi tiết SWAP
            GridLayout {
                Layout.fillWidth: true
                columns: 2
                rowSpacing: 2
                columnSpacing: 10

                Text {
                    text: "Đã dùng:"
                    color: "#CCCCCC"
                    font.pointSize: 9
                }
                Text {
                    text: swapUsed + " MB / " + swapTotal + " MB"
                    color: "white"
                    font.pointSize: 9
                    font.bold: true
                }

                Text {
                    text: "Còn trống:"
                    color: "#CCCCCC"
                    font.pointSize: 9
                }
                Text {
                    text: swapFree + " MB"
                    color: "white"
                    font.pointSize: 9
                }
            }
        }
    }

    Component.onCompleted: ramFetcher.running = true
}

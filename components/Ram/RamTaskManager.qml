import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: ramTaskManager
    width: 600
    height: 400

    // Catppuccin Mocha color scheme
    property color headerColor: theme.normal.blue        // "#8aadf4"
    property color rowEvenColor: theme.primary.background // "#24273a"
    property color rowOddColor: theme.primary.dim_background // "#1e2030"
    property color textColor: theme.primary.foreground   // "#cad3f5"
    property color dimTextColor: theme.primary.dim_foreground // "#8087a2"
    property color highlightColor: theme.normal.green    // "#a6da95"
    
    // Alert colors
    property color criticalColor: theme.normal.red       // "#ed8796" - >10%
    property color warningColor: theme.normal.yellow     // "#eed49f" - >5%
    property color normalColor: theme.normal.green       // "#a6da95" - <=5%
    property color lowColor: theme.normal.cyan           // "#8bd5ca" - <=2%
    
    property color borderColor: theme.normal.black       // "#494d64"
    property color progressBgColor: theme.bright.black   // "#5b6078"
    
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

    // Cập nhật thời gian hiển thị
    Timer {
        id: clockTimer
        interval: 1000
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
        color: theme.primary.background
        radius: 12
        border.color: borderColor
        border.width: 2

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            // Header với gradient
            Rectangle {
                Layout.fillWidth: true
                height: 50
                radius: 8
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.darker(headerColor, 1.2) }
                    GradientStop { position: 1.0; color: headerColor }
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12

                    Row {
                        spacing: 8
                        Text {
                            text: "📊"
                            font.pointSize: 16
                            color: theme.primary.foreground
                        }
                        Text {
                            text: "Process Monitor"
                            font.family: "ComicShannsMono Nerd Font"
                            color: theme.primary.foreground
                            font.bold: true
                            font.pointSize: 16
                        }
                    }

                    Item { Layout.fillWidth: true }

                    Column {
                        spacing: 2
                        Text {
                            text: "Last Update"
                            color: theme.primary.dim_foreground
                            font.pointSize: 9
                        }
                        Text {
                            text: lastUpdateTime
                            color: theme.primary.foreground
                            font.pointSize: 11
                            font.bold: true
                        }
                    }
                }
            }

            // Column headers với background
            Rectangle {
                Layout.fillWidth: true
                height: 32
                color: theme.bright.black
                radius: 6

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 8

                    Text { 
                        text: "PID"
                        color: theme.primary.dim_foreground
                        font.family: "ComicShannsMono Nerd Font"
                        font.bold: true 
                        font.pointSize: 11
                        Layout.preferredWidth: 70 
                    }
                    
                    Text { 
                        text: "Process Name"
                        font.family: "ComicShannsMono Nerd Font"
                        color: theme.primary.dim_foreground
                        font.bold: true 
                        font.pointSize: 11
                        Layout.fillWidth: true 
                    }
                    
                    Text { 
                        text: "RAM %"
                        color: theme.primary.dim_foreground
                        font.bold: true 
                        font.pointSize: 11
                        Layout.preferredWidth: 80 
                        horizontalAlignment: Text.AlignRight
                    }
                    
                    Text { 
                        text: "Memory"
                        color: theme.primary.dim_foreground
                        font.bold: true 
                        font.pointSize: 11
                        Layout.preferredWidth: 100 
                        horizontalAlignment: Text.AlignRight
                    }
                }
            }

            // List view cho processes
            ListView {
                id: processListView
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: ramTaskManager.processList
                clip: true
                spacing: 2

                delegate: Rectangle {
                    width: processListView.width
                    height: 40
                    color: index % 2 === 0 ? rowEvenColor : rowOddColor
                    radius: 6
                    border.color: Qt.lighter(color, 1.1)
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10

                        // PID
                        Text { 
                            text: modelData.pid
                            color: theme.normal.blue
                            font.family: "ComicShannsMono Nerd Font"
                            font.pointSize: 10
                            font.bold: true
                            Layout.preferredWidth: 70 
                        }
                        
                        // Process Name
                        Text { 
                            text: modelData.name
                            color: textColor
                            font.pointSize: 10
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                        
                        // RAM Percentage
                        Text {
                            text: modelData.percent.toFixed(1) + "%"
                            color: getPercentageColor(modelData.percent)
                            font.family: "Monospace"
                            font.pointSize: 10
                            font.bold: modelData.percent > 3
                            Layout.preferredWidth: 80
                            horizontalAlignment: Text.AlignRight
                        }
                        
                        // Memory Usage
                        Text {
                            text: modelData.rss_mb.toFixed(1) + " MB"
                            color: textColor
                            font.family: "Monospace"
                            font.pointSize: 10
                            Layout.preferredWidth: 100
                            horizontalAlignment: Text.AlignRight
                        }
                    }

                    // Progress bar
                    Rectangle {
                        anchors { 
                            left: parent.left
                            right: parent.right
                            bottom: parent.bottom
                            margins: 6
                        }
                        height: 3
                        radius: 1.5
                        color: progressBgColor

                        Rectangle {
                            width: parent.width * Math.min(modelData.percent / 30, 1)
                            height: parent.height
                            radius: 1.5
                            color: getPercentageColor(modelData.percent)
                            Behavior on width {
                                NumberAnimation { duration: 500; easing.type: Easing.OutCubic }
                            }
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
                        spacing: 12
                        Text { 
                            text: "⏳"
                            font.pointSize: 28
                            color: dimTextColor
                        }
                        Text { 
                            text: "Loading process list..."
                            color: dimTextColor
                            font.pointSize: 12
                        }
                    }
                }
            }

            // Footer với thông tin tổng hợp
            Rectangle {
                Layout.fillWidth: true
                height: 40
                color: theme.bright.black
                radius: 8
                border.color: borderColor
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10

                    // Tổng số process
                    Column {
                        spacing: 2
                        Text {
                            text: "Process Count"
                            color: dimTextColor
                            font.pointSize: 9
                        }
                        Text {
                            text: processListView.count
                            color: theme.normal.cyan
                            font.pointSize: 12
                            font.bold: true
                        }
                    }

                    Item { Layout.fillWidth: true }

                    // Tổng RAM usage
                    Column {
                        spacing: 2
                        Text {
                            text: "Total RAM Usage"
                            color: dimTextColor
                            font.pointSize: 9
                        }
                        Text {
                            text: calculateTotalRAM().toFixed(1) + " MB"
                            color: theme.normal.green
                            font.pointSize: 12
                            font.bold: true
                        }
                    }

                    Item { Layout.preferredWidth: 20 }

                    // Process memory distribution
                    Column {
                        spacing: 2
                        Text {
                            text: "Memory Distribution"
                            color: dimTextColor
                            font.pointSize: 9
                        }
                        Text {
                            text: getMemoryDistribution()
                            color: theme.normal.magenta
                            font.pointSize: 12
                            font.bold: true
                        }
                    }
                }
            }
        }
    }

    // Helper functions
    function calculateTotalRAM() {
        var total = 0
        for (var i = 0; i < processList.length; i++) {
            total += processList[i].rss_mb
        }
        return total
    }

    function getPercentageColor(percent) {
        if (percent > 10) return criticalColor    // Red
        if (percent > 5) return warningColor      // Yellow  
        if (percent > 2) return normalColor       // Green
        return lowColor                           // Cyan
    }

    function getMemoryDistribution() {
        if (processList.length === 0) return "N/A"
        
        var topProcess = processList[0]
        var topPercentage = ((topProcess.rss_mb / calculateTotalRAM()) * 100).toFixed(1)
        return topProcess.name.split('/').pop() + " (" + topPercentage + "%)"
    }

    Component.onCompleted: processFetcher.running = true
}

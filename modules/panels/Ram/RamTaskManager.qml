import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: ramTaskManager

    property color headerColor: theme.normal.blue
    property color rowEvenColor: theme.primary.background
    property color rowOddColor: theme.primary.dim_background
    property color textColor: theme.primary.foreground
    property color dimTextColor: theme.primary.dim_foreground
    property color highlightColor: theme.normal.green
    
    property color criticalColor: theme.normal.red
    property color warningColor: theme.normal.yellow
    property color normalColor: theme.normal.green
    property color lowColor: theme.normal.cyan
    
    property color borderColor: theme.normal.black
    property color progressBgColor: theme.bright.black
    
    property int updateInterval: 3000

    property var processList: []
    property string lastUpdateTime: Qt.formatTime(new Date(), "hh:mm:ss")

    Timer {
        id: refreshTimer
        interval: updateInterval
        running: true
        repeat: true
        onTriggered: processFetcher.running = true
    }

    Timer {
        id: clockTimer
        interval: 2000
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

        command: [Qt.resolvedUrl("../../../scripts/task-manager-ram.py")]

        onExited: {
            try {
                var txt = processOutput.text ? processOutput.text.trim() : ""
                if (txt !== "") {
                    const data = JSON.parse(txt)
                    ramTaskManager.processList = data
                }
            } catch (e) {
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: theme.primary.background
        radius: currentSizes.ramManagement?.ramTaskManager?.radius || 12
        border.color: borderColor
        border.width: currentSizes.ramManagement?.ramTaskManager?.borderWidth || 2

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: currentSizes.ramManagement?.ramTaskManager?.margins || 16
            spacing: currentSizes.ramManagement?.ramTaskManager?.spacing || 12

            Rectangle {
                Layout.fillWidth: true
                color: theme.primary.background
                height: currentSizes.ramManagement?.ramTaskManager?.headerHeight || 50
                radius: currentSizes.ramManagement?.ramTaskManager?.headerRadius || 8

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: currentSizes.ramManagement?.ramTaskManager?.headerSpacing || 12

                    Row {
                        spacing: 8
 
                        Text {
                            text: lang.ram.title
                            font.family: "ComicShannsMono Nerd Font"
                            color: textColor
                font.bold: true
                font.pixelSize: currentSizes.fontSize?.title || 30
                        }
                    }

                    Item { Layout.fillWidth: true }

                    Column {
                        spacing: 2
                        Text {
                            text: lang.ram.header_bar.last_update
                            color: theme.primary.foreground
                            font.family: "ComicShannsMono Nerd Font"
                            font.pixelSize: currentSizes.fontSize?.medium || 16
                        }
                        Text {
                            text: lastUpdateTime
                            color: theme.primary.foreground
                            font.family: "ComicShannsMono Nerd Font"
                            font.pixelSize: currentSizes.fontSize?.medium || 16
                            font.bold: true
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: currentSizes.ramManagement?.ramTaskManager?.columnHeaderHeight || 32
                color: theme.bright.black
                radius: currentSizes.ramManagement?.ramTaskManager?.columnHeaderRadius || 6

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 8

                    Text { 
                        text: lang.ram.headers.pid
                        color: theme.primary.dim_foreground
                        font.family: "ComicShannsMono Nerd Font"
                        font.bold: true 
                        font.pixelSize: currentSizes.fontSize?.medium || 14
                        Layout.preferredWidth: 70 
                    }
                    
                    Text { 
                        text: lang.ram.headers.name
                        font.family: "ComicShannsMono Nerd Font"
                        color: theme.primary.dim_foreground
                        font.bold: true 
                        font.pixelSize: currentSizes.fontSize?.medium || 14
                        Layout.fillWidth: true 
                    }
                    
                    Text { 
                        text: lang.ram.headers.ram_percent
                        color: theme.primary.dim_foreground
                        font.bold: true 
                        font.pixelSize: currentSizes.fontSize?.medium || 14
                        Layout.preferredWidth: 80 
                        horizontalAlignment: Text.AlignRight
                    }
                    
                    Text { 
                        text: lang.ram.headers.memory
                        color: theme.primary.dim_foreground
                        font.family: "ComicShannsMono Nerd Font"
                        font.bold: true 
                        font.pixelSize: currentSizes.fontSize?.medium || 14
                        Layout.preferredWidth: 100 
                        horizontalAlignment: Text.AlignRight
                    }
                }
            }

            ListView {
                id: processListView
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: ramTaskManager.processList
                clip: true
                spacing: 2

                delegate: Rectangle {
                    width: processListView.width
                    height: currentSizes.ramManagement?.ramTaskManager?.processItemHeight || 50
                    color: index % 2 === 0 ? rowEvenColor : rowOddColor
                    radius: currentSizes.ramManagement?.ramTaskManager?.processItemRadius || 6
                    border.color: Qt.lighter(color, 1.1)
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: currentSizes.ramManagement?.ramTaskManager?.processItemSpacing || 10

                        Text { 
                            text: modelData.pid
                            color: theme.normal.blue
                            font.family: "ComicShannsMono Nerd Font"
                            font.pixelSize: currentSizes.fontSize?.medium || 14
                            font.bold: true
                            Layout.preferredWidth: 70 
                        }
                        
                        Text { 
                            text: modelData.name
                            color: textColor
                            font.pixelSize: currentSizes.fontSize?.medium || 14
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                        
                        Text {
                            text: modelData.percent.toFixed(1) + "%"
                            color: getPercentageColor(modelData.percent)
                            font.family: "ComicShannsMono Nerd Font"
                            font.pixelSize: currentSizes.fontSize?.medium || 14
                            font.bold: modelData.percent > 3
                            Layout.preferredWidth: 80
                            horizontalAlignment: Text.AlignRight
                        }
                        
                        Text {
                            text: modelData.rss_mb.toFixed(1) + " MB"
                            color: textColor
                            font.family: "ComicShannsMono Nerd Font"
                            font.pixelSize: currentSizes.fontSize?.medium || 14
                            Layout.preferredWidth: 100
                            horizontalAlignment: Text.AlignRight
                        }
                    }

                    Rectangle {
                        anchors { 
                            left: parent.left
                            right: parent.right
                            bottom: parent.bottom
                            margins: 6
                        }
                        height: currentSizes.ramManagement?.ramTaskManager?.progressBarHeight || 3
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

                Rectangle {
                    visible: processListView.count === 0
                    anchors.fill: parent
                    color: "transparent"

                    Column {
                        anchors.centerIn: parent
                        spacing: 12
                        Text { 
                            text: "⏳"
                            font.pixelSize: currentSizes.fontSize?.title || 30
                            color: dimTextColor
                        }
                        Text { 
                            text: lang.ram.loading.message
                            font.family: "ComicShannsMono Nerd Font"
                            color: dimTextColor
                            font.pixelSize: currentSizes.fontSize?.medium || 14
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: currentSizes.ramManagement?.ramTaskManager?.footerHeight || 60
                color: theme.bright.black
                radius: currentSizes.ramManagement?.ramTaskManager?.footerRadius || 8
                border.color: borderColor
                border.width: currentSizes.ramManagement?.ramTaskManager?.footerBorderWidth || 1

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: currentSizes.ramManagement?.ramTaskManager?.footerSpacing || 10

                    Column {
                        spacing: 2
                        Text {
                            text: lang.ram.footer.process_count_label
                            font.family: "ComicShannsMono Nerd Font"
                            color: dimTextColor
                            font.pixelSize: currentSizes.fontSize?.medium || 14
                        }
                        Text {
                            text: processListView.count
                            font.family: "ComicShannsMono Nerd Font"
                            color: theme.normal.cyan
                            font.pixelSize: currentSizes.fontSize?.medium || 14
                            font.bold: true
                        }
                    }

                    Item { Layout.fillWidth: true }

                    Column {
                        spacing: 2
                        Text {
                            text: lang.ram.footer.total_ram_label
                            font.family: "ComicShannsMono Nerd Font"
                            color: dimTextColor
                            font.pixelSize: currentSizes.fontSize?.medium || 14
                        }
                        Text {
                            text: calculateTotalRAM().toFixed(1) + " MB"
                            font.family: "ComicShannsMono Nerd Font"
                            color: theme.normal.green
                            font.pixelSize: currentSizes.fontSize?.medium || 14
                            font.bold: true
                        }
                    }

                    Item { Layout.preferredWidth: 20 }

                    Column {
                        spacing: 2
                        Text {
                            text: lang.ram.footer.memory_distribution_label
                            font.family: "ComicShannsMono Nerd Font"
                            color: dimTextColor
                            font.pixelSize: currentSizes.fontSize?.medium || 14
                        }
                        Text {
                            text: getMemoryDistribution()
                            font.family: "ComicShannsMono Nerd Font"
                            color: theme.normal.magenta
                            font.pixelSize: currentSizes.fontSize?.medium || 14
                            font.bold: true
                        }
                    }
                }
            }
        }
    }

    function calculateTotalRAM() {
        var total = 0
        for (var i = 0; i < processList.length; i++) {
            total += processList[i].rss_mb
        }
        return total
    }

    function getPercentageColor(percent) {
        if (percent > 10) return criticalColor
        if (percent > 5) return warningColor  
        if (percent > 2) return normalColor
        return lowColor
    }

    function getMemoryDistribution() {
        if (processList.length === 0) return "N/A"
        
        var topProcess = processList[0]
        var topPercentage = ((topProcess.rss_mb / calculateTotalRAM()) * 100).toFixed(1)
        return topProcess.name.split('/').pop() + " (" + topPercentage + "%)"
    }

    Component.onCompleted: processFetcher.running = true
}
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell.Io
import Quickshell

Item {
    id: ramDisplay
    width: 320
    height: 180

    property var lang: currentLanguage
    property color usedRamColor: theme.normal.green
    property color freeRamColor: theme.normal.black
    property color usedSwapColor: theme.normal.blue
    property color freeSwapColor: theme.normal.black
    property color textColor: theme.primary.foreground
    property color dimTextColor: theme.primary.dim_foreground
    property color borderColor: theme.bright.black
    property color separatorColor: theme.normal.black
    
    property int ramPercent: 0
    property int swapPercent: 0
    property int updateInterval: 2000
    
    property int ramTotal: 0
    property int ramUsed: 0
    property int ramFree: 0
    property int ramAvailable: 0
    property int swapTotal: 0
    property int swapUsed: 0
    property int swapFree: 0

    property bool dataLoaded: false

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

        command: [Qt.resolvedUrl("../../../scripts/memory-info.py")]

        onExited: {
            try {
                var txt = outputCollector.text ? outputCollector.text.trim() : ""
                if (txt !== "") {
                    const data = JSON.parse(txt)
                    ramDisplay.ramPercent = data.memory.used_percent
                    ramDisplay.swapPercent = data.swap.used_percent
                    
                    ramDisplay.ramTotal = data.memory.total_mb
                    ramDisplay.ramUsed = data.memory.used_mb
                    ramDisplay.ramFree = data.memory.free_mb
                    ramDisplay.ramAvailable = data.memory.available_mb
                    ramDisplay.swapTotal = data.swap.total_mb
                    ramDisplay.swapUsed = data.swap.used_mb
                    ramDisplay.swapFree = data.swap.free_mb
                    
                    ramDisplay.dataLoaded = true
                }
            } catch (e) {
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: theme.primary.background
        radius: currentSizes.ramManagement?.ramDisplay?.radius || 12
        border.color: borderColor
        border.width: currentSizes.ramManagement?.ramDisplay?.borderWidth || 2
        
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            opacity: 0.1
            radius: currentSizes.ramManagement?.ramDisplay?.radius || 12
            
            Canvas {
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.strokeStyle = theme.primary.foreground
                    ctx.lineWidth = 0.5
                    
                    for (var x = 0; x < width; x += 15) {
                        ctx.beginPath()
                        ctx.moveTo(x, 0)
                        ctx.lineTo(x, height)
                        ctx.stroke()
                    }
                    for (var y = 0; y < height; y += 15) {
                        ctx.beginPath()
                        ctx.moveTo(0, y)
                        ctx.lineTo(width, y)
                        ctx.stroke()
                    }
                }
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: currentSizes.ramManagement?.ramDisplay?.margins || 16
        spacing: currentSizes.ramManagement?.ramDisplay?.spacing || 16

        RowLayout {
            Layout.fillWidth: true
            
            Text {
                text: lang?.ram?.memory_monitor || "Memory Monitor"
                font.family: "ComicShannsMono Nerd Font"
                color: textColor
                font.bold: true
                font.pixelSize: currentSizes.fontSize?.title || 30
            }
            
            Item { Layout.fillWidth: true }
            
            Rectangle {
                width: 8
                height: 8
                radius: 4
                color: ramPercent > 80 ? theme.normal.red : 
                       ramPercent > 60 ? theme.normal.yellow : theme.normal.green
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: currentSizes.ramManagement?.ramDisplay?.gridSpacing || 6

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                RowLayout {
                    Layout.fillWidth: true
                    
                    Text {
                        text: "RAM"
                        color: textColor
                        font.bold: true
                        font.family: "ComicShannsMono Nerd Font"
                        font.pixelSize: currentSizes.fontSize?.xlarge || 24
                    }
                    
                    Item { Layout.fillWidth: true }
                    
                    Text {
                        text: ramPercent + "%"
                        color: getUsageColor(ramPercent)
                        font.bold: true
                        font.family: "ComicShannsMono Nerd Font"
                        font.pixelSize: currentSizes.fontSize?.xlarge || 24
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: currentSizes.ramManagement?.ramDisplay?.progressBarHeight || 20
                    radius: 10
                    color: freeRamColor

                    Rectangle {
                        width: parent.width * (ramPercent / 100)
                        height: parent.height
                        radius: 10
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: Qt.lighter(usedRamColor, 1.2) }
                            GradientStop { position: 1.0; color: usedRamColor }
                        }
                        Behavior on width { 
                            NumberAnimation { 
                                duration: 800; 
                                easing.type: Easing.OutCubic 
                            } 
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: ramUsed + " / " + ramTotal + " MB"
                        color: theme.primary.background
                        font.bold: true
                        font.pixelSize: currentSizes.fontSize?.large || 20
                        font.family: "ComicShannsMono Nerd Font"
                    }
                }
            }

            GridLayout {
                Layout.fillWidth: true
                columns: 3
                rowSpacing: currentSizes.ramManagement?.ramDisplay?.gridSpacing || 4
                columnSpacing: 8

                Column {
                    Layout.alignment: Qt.AlignHCenter
                    Text {
                        text: lang?.ram?.used || "Used"
                        color: dimTextColor
                        font.pixelSize: currentSizes.fontSize?.large || 20
                        font.family: "ComicShannsMono Nerd Font"
                    }
                    Text {
                        text: ramUsed + " MB"
                        color: theme.normal.red
                        font.pixelSize: currentSizes.fontSize?.large || 20
                        font.family: "ComicShannsMono Nerd Font"
                        font.bold: true
                    }
                }

                Column {
                    Layout.alignment: Qt.AlignHCenter
                    Text {
                        text: lang?.ram?.free || "Free"
                        color: dimTextColor
                        font.pixelSize: currentSizes.fontSize?.large || 20
                        font.family: "ComicShannsMono Nerd Font"
                    }
                    Text {
                        text: ramFree + " MB"
                        color: theme.normal.green
                        font.pixelSize: currentSizes.fontSize?.large || 20
                        font.family: "ComicShannsMono Nerd Font"
                        font.bold: true
                    }
                }

                Column {
                    Layout.alignment: Qt.AlignHCenter
                    Text {
                        text: lang?.ram?.available || "Available"
                        color: dimTextColor
                        font.pixelSize: currentSizes.fontSize?.large || 20
                        font.family: "ComicShannsMono Nerd Font"
                    }
                    Text {
                        text: ramAvailable + " MB"
                        color: theme.normal.cyan
                        font.pixelSize: currentSizes.fontSize?.large || 20
                        font.family: "ComicShannsMono Nerd Font"
                        font.bold: true
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: currentSizes.ramManagement?.ramDisplay?.separatorHeight || 1
            color: "transparent"
            
            Rectangle {
                anchors.centerIn: parent
                width: parent.width * 0.8
                height: 1
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "transparent" }
                    GradientStop { position: 0.2; color: separatorColor }
                    GradientStop { position: 0.8; color: separatorColor }
                    GradientStop { position: 1.0; color: "transparent" }
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: currentSizes.ramManagement?.ramDisplay?.gridSpacing || 6

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                RowLayout {
                    Layout.fillWidth: true
                    
                    Text {
                        text: "SWAP"
                        color: textColor
                        font.bold: true
                        font.family: "ComicShannsMono Nerd Font"
                        font.pixelSize: currentSizes.fontSize?.xlarge || 24
                    }
                    
                    Item { Layout.fillWidth: true }
                    
                    Text {
                        text: swapPercent + "%"
                        color: getUsageColor(swapPercent)
                        font.bold: true
                        font.family: "ComicShannsMono Nerd Font"
                        font.pixelSize: currentSizes.fontSize?.xlarge || 24
                        opacity: swapTotal > 0 ? 1 : 0.3
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: currentSizes.ramManagement?.ramDisplay?.swapProgressBarHeight || 14
                    radius: 7
                    color: freeSwapColor
                    opacity: swapTotal > 0 ? 1 : 0.3

                    Rectangle {
                        width: parent.width * (swapPercent / 100)
                        height: parent.height
                        radius: 7
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: Qt.lighter(usedSwapColor, 1.2) }
                            GradientStop { position: 1.0; color: usedSwapColor }
                        }
                        Behavior on width { 
                            NumberAnimation { 
                                duration: 800; 
                                easing.type: Easing.OutCubic 
                            } 
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: swapTotal > 0 ? (swapUsed + " / " + swapTotal + " MB") : (lang?.ram?.no_swap || "No SWAP")
                        color: theme.primary.background
                        font.bold: true
                        font.pixelSize: currentSizes.fontSize?.large || 20
                        font.family: "ComicShannsMono Nerd Font"
                    }
                }
            }

            GridLayout {
                Layout.fillWidth: true
                columns: 2
                rowSpacing: 2
                columnSpacing: 8
                opacity: swapTotal > 0 ? 1 : 0.3
                Column {
                    Layout.alignment: Qt.AlignHCenter
                    Text {
                        text: (lang?.ram?.used || "Used") + ":"
                        color: dimTextColor
                        font.pixelSize: currentSizes.fontSize?.large || 20
                        font.family: "ComicShannsMono Nerd Font"
                    }
                    Text {
                        text: swapUsed + " MB"
                        color: theme.normal.blue
                        font.pixelSize: currentSizes.fontSize?.large || 20
                        font.family: "ComicShannsMono Nerd Font"
                        font.bold: true
                    }
                }

                Column {
                    Layout.alignment: Qt.AlignHCenter
                    Text {
                        text: (lang?.ram?.free || "Free") + ":"
                        color: dimTextColor
                        font.pixelSize: currentSizes.fontSize?.large || 20
                        font.family: "ComicShannsMono Nerd Font"
                    }
                    Text {
                        text: swapFree + " MB"
                        color: theme.normal.green
                        font.pixelSize: currentSizes.fontSize?.large || 20
                        font.family: "ComicShannsMono Nerd Font"
                        font.bold: true
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: theme.primary.background
        radius: currentSizes.ramManagement?.ramDisplay?.radius || 12
        opacity: dataLoaded ? 0 : 1
        visible: opacity > 0
        
        Behavior on opacity { NumberAnimation { duration: 300 } }
        
        Column {
            anchors.centerIn: parent
            spacing: 12
            
            Text {
                text: "⏳"
                font.pixelSize: 20
                color: dimTextColor
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            Text {
                text: lang?.ram?.loading_memory || "Loading memory data..."
                color: dimTextColor
                font.pixelSize: currentSizes.ramManagement?.ramDisplay?.smallFontSize || 10
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    function getUsageColor(percent) {
        if (percent > 90) return theme.normal.red
        if (percent > 70) return theme.normal.yellow
        if (percent > 50) return theme.normal.green
        return theme.normal.cyan
    }

    Component.onCompleted: ramFetcher.running = true
}
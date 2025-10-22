import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell.Io
import Quickshell

Item {
    id: ramDisplay
    width: 320
    height: 160  // Tăng chiều cao để chứa thêm thông tin

    // Catppuccin Mocha color scheme
    property color usedRamColor: theme.normal.green       // "#a6da95"
    property color freeRamColor: theme.normal.black       // "#494d64" 
    property color usedSwapColor: theme.normal.blue       // "#8aadf4"
    property color freeSwapColor: theme.normal.black      // "#494d64"
    property color textColor: theme.primary.foreground    // "#cad3f5"
    property color dimTextColor: theme.primary.dim_foreground // "#8087a2"
    property color borderColor: theme.bright.black        // "#5b6078"
    property color separatorColor: theme.normal.black     // "#494d64"
    
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

    // Biến cho animation
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

        command: [Qt.resolvedUrl("../../scripts/memory-info.py")]

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
                    
                    ramDisplay.dataLoaded = true
                } else {
                    console.warn("RAM script returned empty output")
                }
            } catch (e) {
                console.error("RAM parse error:", e, "\nOutput was:", outputCollector.text)
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: theme.primary.background
        radius: 12
        border.color: borderColor
        border.width: 2
        
        // Background pattern nhẹ
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            opacity: 0.1
            radius: 12
            
            Canvas {
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.strokeStyle = theme.primary.foreground
                    ctx.lineWidth = 0.5
                    
                    // Vẽ grid pattern nhẹ
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
        anchors.margins: 16
        spacing: 16

        // Header với icon
        RowLayout {
            Layout.fillWidth: true
            
            Text {
                text: "💾"
                font.pointSize: 16
                color: theme.normal.blue
            }
            
            Text {
                text: "Memory Monitor"
                color: textColor
                font.bold: true
                font.pointSize: 14
            }
            
            Item { Layout.fillWidth: true }
            
            // Usage indicator
            Rectangle {
                width: 8
                height: 8
                radius: 4
                color: ramPercent > 80 ? theme.normal.red : 
                       ramPercent > 60 ? theme.normal.yellow : theme.normal.green
            }
        }

        // RAM Section
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6

            // Header với phần trăm và thanh tiến trình
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                RowLayout {
                    Layout.fillWidth: true
                    
                    Text {
                        text: "RAM"
                        color: textColor
                        font.bold: true
                        font.pointSize: 11
                    }
                    
                    Item { Layout.fillWidth: true }
                    
                    Text {
                        text: ramPercent + "%"
                        color: getUsageColor(ramPercent)
                        font.bold: true
                        font.pointSize: 11
                    }
                }

                // Progress bar với gradient
                Rectangle {
                    Layout.fillWidth: true
                    height: 20
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

                    // Text overlay trên progress bar
                    Text {
                        anchors.centerIn: parent
                        text: ramUsed + " / " + ramTotal + " MB"
                        color: theme.primary.background
                        font.bold: true
                        font.pointSize: 9
                        opacity: 0.8
                    }
                }
            }

            // Chi tiết RAM dạng grid
            GridLayout {
                Layout.fillWidth: true
                columns: 3
                rowSpacing: 4
                columnSpacing: 8

                // Used
                Column {
                    Layout.alignment: Qt.AlignHCenter
                    Text {
                        text: "Used"
                        color: dimTextColor
                        font.pointSize: 8
                    }
                    Text {
                        text: ramUsed + " MB"
                        color: theme.normal.red
                        font.pointSize: 10
                        font.bold: true
                    }
                }

                // Free
                Column {
                    Layout.alignment: Qt.AlignHCenter
                    Text {
                        text: "Free"
                        color: dimTextColor
                        font.pointSize: 8
                    }
                    Text {
                        text: ramFree + " MB"
                        color: theme.normal.green
                        font.pointSize: 10
                        font.bold: true
                    }
                }

                // Available
                Column {
                    Layout.alignment: Qt.AlignHCenter
                    Text {
                        text: "Available"
                        color: dimTextColor
                        font.pointSize: 8
                    }
                    Text {
                        text: ramAvailable + " MB"
                        color: theme.normal.cyan
                        font.pointSize: 10
                        font.bold: true
                    }
                }
            }
        }

        // Separator với pattern
        Rectangle {
            Layout.fillWidth: true
            height: 1
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

        // SWAP Section
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6

            // Header với phần trăm
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                RowLayout {
                    Layout.fillWidth: true
                    
                    Text {
                        text: "SWAP"
                        color: textColor
                        font.bold: true
                        font.pointSize: 11
                    }
                    
                    Item { Layout.fillWidth: true }
                    
                    Text {
                        text: swapPercent + "%"
                        color: getUsageColor(swapPercent)
                        font.bold: true
                        font.pointSize: 11
                        opacity: swapTotal > 0 ? 1 : 0.3
                    }
                }

                // Progress bar
                Rectangle {
                    Layout.fillWidth: true
                    height: 14
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

                    // Text overlay cho SWAP
                    Text {
                        anchors.centerIn: parent
                        text: swapTotal > 0 ? (swapUsed + " / " + swapTotal + " MB") : "No SWAP"
                        color: theme.primary.background
                        font.bold: true
                        font.pointSize: 8
                        opacity: 0.8
                    }
                }
            }

            // Chi tiết SWAP
            GridLayout {
                Layout.fillWidth: true
                columns: 2
                rowSpacing: 2
                columnSpacing: 8
                opacity: swapTotal > 0 ? 1 : 0.3

                Text {
                    text: "Used:"
                    color: dimTextColor
                    font.pointSize: 8
                }
                Text {
                    text: swapUsed + " MB"
                    color: theme.normal.blue
                    font.pointSize: 9
                    font.bold: true
                }

                Text {
                    text: "Free:"
                    color: dimTextColor
                    font.pointSize: 8
                }
                Text {
                    text: swapFree + " MB"
                    color: theme.normal.green
                    font.pointSize: 9
                    font.bold: true
                }
            }
        }
    }

    // Loading animation
    Rectangle {
        anchors.fill: parent
        color: theme.primary.background
        radius: 12
        opacity: dataLoaded ? 0 : 1
        visible: opacity > 0
        
        Behavior on opacity { NumberAnimation { duration: 300 } }
        
        Column {
            anchors.centerIn: parent
            spacing: 12
            
            Text {
                text: "⏳"
                font.pointSize: 20
                color: dimTextColor
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            Text {
                text: "Loading memory data..."
                color: dimTextColor
                font.pointSize: 10
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    // Helper function để lấy màu theo phần trăm sử dụng
    function getUsageColor(percent) {
        if (percent > 90) return theme.normal.red
        if (percent > 70) return theme.normal.yellow
        if (percent > 50) return theme.normal.green
        return theme.normal.cyan
    }

    Component.onCompleted: ramFetcher.running = true
}

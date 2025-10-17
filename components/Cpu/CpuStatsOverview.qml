import QtQuick

Rectangle {
    color: theme.primary.dim_background
    border.color: "#4f4f5b"
    border.width: 2
    radius: 4

    property var calculateTotalUsage: function() { return "0.0" }
    property var getMaxUsage: function() { return "0.0" }
    property var getUsageColor: function(usageStr) { return "#3498db" }
    property var cpuHistory: []
    property var theme

    Row {
        anchors.centerIn: parent
        spacing: 40

        Row{
            Image {
                width: 40
                height: 40
                source: '../../assets/pie-chart.png'
            }
            Column {
                spacing: 2
                Text {
                    text: "Tổng Usage"
                    color: "#4f4f5b"
                    font.pixelSize: 16
                    font.family: "ComicShannsMono Nerd Font"
                }
                Text {
                    text: calculateTotalUsage() + "%"
                    color: getUsageColor(calculateTotalUsage())
                    font.pixelSize: 18
                    font.bold: true
                    font.family: "ComicShannsMono Nerd Font"
                }
            }
        }
        
        Row {
            Image{
                width: 40
                height: 40
                source: '../../assets/fire.png'
            }
            Column {
                spacing: 2
                Text {
                    text: "Core Cao Nhất"
                    color: "#4f4f5b"
                    font.pixelSize: 16
                    font.family: "ComicShannsMono Nerd Font"
                }
                Text {
                    text: getMaxUsage() + "%"
                    color: getUsageColor(getMaxUsage())
                    font.pixelSize: 18
                    font.bold: true
                    font.family: "ComicShannsMono Nerd Font"
                }
            }
        }

        Column {
            spacing: 2
            Text {
                text: "⏱️ Thời Gian"
                color: "#4f4f5b"
                font.pixelSize: 14
                font.family: "ComicShannsMono Nerd Font"
            }
            Text {
                text: cpuHistory.length + " điểm"
                color: "#4f4f5b"
                font.pixelSize: 18
                font.bold: true
                font.family: "ComicShannsMono Nerd Font"
            }
        }
    }
}

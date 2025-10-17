import QtQuick

Rectangle {
    color: theme.primary.dim_background
    border.color: theme.normal.black
    border.width: 2
    radius: 4

    property int cpuCores: 12
    property var cpuUsageList: []
    property var getUsageColor: function(usageStr) { return "#3498db" }
    property var theme

    Flickable {
        anchors.fill: parent
        anchors.margins: 8
        contentWidth: row.width
        contentHeight: row.height
        clip: true

        Row {
            id: row
            spacing: 12
            height: parent.height

            Repeater {
                model: cpuCores
                
                Column {
                    width: 70
                    spacing: 4
                    
                    Text {
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                        text: "Core " + (index + 1)
                        color: theme.primary.foreground
                        font.pixelSize: 14
                        font.bold: true
                        font.family: "ComicShannsMono Nerd Font"
                    }
                    
                    Rectangle {
                        width: 60
                        height: 60
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "transparent"
                        
                        Image {
                            anchors.fill: parent
                            source: `../../assets/cpu/cpu_${index + 1}.png`
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                    
                    Text {
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                        text: cpuUsageList[index] || "0%"
                        color: getUsageColor(cpuUsageList[index] || "0")
                        font.pixelSize: 16
                        font.bold: true
                        font.family: "ComicShannsMono Nerd Font"
                    }
                }
            }
        }
    }
}

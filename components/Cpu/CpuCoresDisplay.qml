import QtQuick

Rectangle {
    property int cpuCores: 12
    property var cpuUsageList: []
    property var getUsageColor: function(usageStr) { return "#3498db" }
    property var theme: currentTheme
    property var sizes: currentSizes.cpuDetailPanel

    color: theme.primary.dim_background
    border.color: theme.normal.black
    border.width: sizes.coresBorderWidth || 2
    radius: sizes.coresRadius || 8

    Flickable {
        anchors.fill: parent
        anchors.margins: sizes.coresMargins || 8
        contentWidth: row.width
        contentHeight: row.height
        clip: true

        Row {
            id: row
            spacing: sizes.coresSpacing || 12
            height: parent.height

            Repeater {
                model: cpuCores

                Column {
                    width: sizes.coreColumnWidth || 70
                    spacing: sizes.coreColumnSpacing || 4

                    Text {
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                        text: "Core " + (index + 1)
                        color: theme.primary.foreground
                        font.pixelSize: sizes.coreLabelFontSize || 14
                        font.bold: true
                        font.family: "ComicShannsMono Nerd Font"
                    }

                    Rectangle {
                        width: sizes.coreImageSize || 60
                        height: sizes.coreImageSize || 60
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
                        font.pixelSize: sizes.coreUsageFontSize || 16
                        font.bold: true
                        font.family: "ComicShannsMono Nerd Font"
                    }
                }
            }
        }
    }
}

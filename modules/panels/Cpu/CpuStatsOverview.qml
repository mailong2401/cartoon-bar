import QtQuick

Rectangle {
    property var calculateTotalUsage: function() { return "0.0" }
    property var getMaxUsage: function() { return "0.0" }
    property var getUsageColor: function(usageStr) { return "#3498db" }
    property var cpuHistory: []
    property var theme: currentTheme
    property var sizes: currentSizes.cpuDetailPanel
    property var lang: currentLanguage

    color: theme.primary.dim_background
    border.color: "#4f4f5b"
    border.width: sizes.statsBorderWidth || 2
    radius: sizes.statsRadius || 4

    Row {
        anchors.centerIn: parent
        spacing: sizes.statsRowSpacing || 40

        Row {
            Image {
                width: sizes.statsIconSize || 40
                height: sizes.statsIconSize || 40
                source: '../../../assets/pie-chart.png'
            }
            Column {
                spacing: sizes.statsColumnSpacing || 2
                Text {
                    text: lang.cpuStats.totalUsage
                    color: "#4f4f5b"
                    font.pixelSize: sizes.statsLabelFontSize || 16
                    font.family: "ComicShannsMono Nerd Font"
                }
                Text {
                    text: calculateTotalUsage() + "%"
                    color: getUsageColor(calculateTotalUsage())
                    font.pixelSize: sizes.statsValueFontSize || 18
                    font.bold: true
                    font.family: "ComicShannsMono Nerd Font"
                }
            }
        }

        Row {
            Image {
                width: sizes.statsIconSize || 40
                height: sizes.statsIconSize || 40
                source: '../../../assets/fire.png'
            }
            Column {
                spacing: sizes.statsColumnSpacing || 2
                Text {
                    text: lang.cpuStats.maxCore
                    color: "#4f4f5b"
                    font.pixelSize: sizes.statsLabelFontSize || 16
                    font.family: "ComicShannsMono Nerd Font"
                }
                Text {
                    text: getMaxUsage() + "%"
                    color: getUsageColor(getMaxUsage())
                    font.pixelSize: sizes.statsValueFontSize || 18
                    font.bold: true
                    font.family: "ComicShannsMono Nerd Font"
                }
            }
        }

        Column {
            spacing: sizes.statsColumnSpacing || 2
            Text {
                text: lang.cpuStats.timeLabel
                color: "#4f4f5b"
                font.pixelSize: sizes.statsTimeLabelFontSize || 14
                font.family: "ComicShannsMono Nerd Font"
            }
            Text {
                text: cpuHistory.length + " " + lang.cpuStats.dataPoints
                color: "#4f4f5b"
                font.pixelSize: sizes.statsValueFontSize || 18
                font.bold: true
                font.family: "ComicShannsMono Nerd Font"
            }
        }
    }
}

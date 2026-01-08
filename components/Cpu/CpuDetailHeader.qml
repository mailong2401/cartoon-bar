import QtQuick

Item {
    id: header
    signal closeClicked()

    property var theme: currentTheme
    property var sizes: currentSizes.cpuDetailPanel
    property var lang : currentLanguage


    Row {
        anchors.centerIn: parent
        spacing: sizes.headerSpacing || 20

        Text {
            text: lang.CpuPane.title
            color: theme.primary.foreground
            font.pixelSize: sizes.headerTitleFontSize || 40
            font.bold: true
            font.family: "ComicShannsMono Nerd Font"
        }
    }
}

import QtQuick

Item {
    id: header
    signal closeClicked()

    property var theme : currentTheme
    property var lang : currentLanguage

    Row {
        anchors.centerIn: parent
        spacing: currentSizes.wtDetailPanel?.header?.spacing || 20

        Text {
            text: lang?.calendar?.title || "Lịch"
            color: theme.primary.foreground
            font.pixelSize: currentSizes.wtDetailPanel?.header?.fontSize || 40
            font.bold: true
            font.family: "ComicShannsMono Nerd Font"
        }
    }
}

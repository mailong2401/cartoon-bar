import QtQuick

Item {
    id: header

    property var theme: currentTheme
    property var lang: currentLanguage
    property var sizes: ({})

    signal closeClicked()

    Row {
        anchors.centerIn: parent
        spacing: sizes.header?.spacing || 20

        Text {
            text: lang?.calendar?.title || "Lịch"
            color: theme.primary.foreground
            font.pixelSize: sizes.header?.fontSize || 40
            font.bold: true
            font.family: "ComicShannsMono Nerd Font"
        }
    }
}

import QtQuick

Item {
    id: header
    signal closeClicked()

    property var theme

    Row {
        anchors.centerIn: parent
        spacing: 20
        
        Text {
            text: "Lịch"
            color: theme.primary.foreground
            font.pixelSize: 40
            font.bold: true
            font.family: "ComicShannsMono Nerd Font"
        }
    }
}

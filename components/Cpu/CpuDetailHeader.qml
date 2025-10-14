import QtQuick

Item {
    id: header
    signal closeClicked()

    Row {
        anchors.centerIn: parent
        spacing: 20
        
        Text {
            text: "Thông tin CPU"
            color: "#4f4f5b"
            font.pixelSize: 40
            font.bold: true
            font.family: "ComicShannsMono Nerd Font"
        }
    }
}

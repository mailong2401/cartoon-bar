import QtQuick

Item {
    id: header
    signal closeClicked()

    Row {
        anchors.centerIn: parent
        spacing: 20
        
        Text {
            text: "Quản lí bộ nhớ (RAM)"
            color: "#4f4f5b"
            font.pixelSize: 40
            font.bold: true
            font.family: "ComicShannsMono Nerd Font"
        }
        
        // Nút đóng
        Rectangle {
            width: 40
            height: 40
            radius: 20
            color: closeMouseArea.containsMouse ? "#E8D8C9" : "transparent"
            border.color: "#4f4f5b"
            border.width: 2
            
            Text {
                anchors.centerIn: parent
                text: "✕"
                color: "#4f4f5b"
                font.pixelSize: 20
                font.bold: true
            }
            
            MouseArea {
                id: closeMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: header.closeClicked()
            }
        }
    }
}

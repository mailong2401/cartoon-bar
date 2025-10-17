import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    Layout.fillWidth: true
    Layout.preferredHeight: 45
    radius: 12
    color: theme.primary.background
    border.color: theme.normal.black
    border.width: 2

    signal searchChanged(string text) // phát ra khi cần tìm (sau debounce)
    signal accepted(string text)      // khi nhấn Enter


    property var theme

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        Image {
            source: "../../assets/search.png"
            Layout.preferredHeight: 24
            Layout.preferredWidth: 24
            fillMode: Image.PreserveAspectFit
            smooth: true
        }

        TextField {
            id: searchField
            Layout.fillWidth: true
            placeholderText: "Tìm kiếm ứng dụng..."
            palette.text: theme.primary.foreground       // màu chữ chính
            palette.placeholderText: "#888888"  // màu placeholder
            font.pixelSize: 14
            font.family: "ComicShannsMono Nerd Font"
            background: Rectangle { color: "transparent" }

            onTextChanged: {
                // restart debounce timer mỗi khi gõ
                debounce.running = false
                debounce.start()
            }

            Keys.onReturnPressed: {
                root.accepted(text)
                // gọi ngay (bỏ qua debounce) khi nhấn Enter
                debounce.running = false
                root.searchChanged(text)
            }
        }

        Timer {
            id: debounce
            interval: 100
            repeat: false
            running: false
            onTriggered: root.searchChanged(searchField.text)
        }
    }
}


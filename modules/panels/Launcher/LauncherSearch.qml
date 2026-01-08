import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    Layout.fillWidth: true
    Layout.preferredHeight: currentSizes.launcherPanel?.searchHeight || 45
    radius: currentSizes.radius?.normal || 12
    color: theme.primary.dim_background
    border.color: theme.normal.black
    border.width: 2

    signal searchChanged(string text) // phát ra khi cần tìm (sau debounce)
    signal accepted(string text)      // khi nhấn Enter

    property var theme : currentTheme
    property alias searchField: searchField  // Expose searchField để có thể focus từ bên ngoài

    RowLayout {
        anchors.fill: parent
        anchors.margins: currentSizes.spacing?.normal || 8
        spacing: 8

        Image {
            source: "../../../assets/search.png"
            Layout.preferredHeight: currentSizes.launcherPanel?.searchIconSize || 24
            Layout.preferredWidth: currentSizes.launcherPanel?.searchIconSize || 24
            fillMode: Image.PreserveAspectFit
            smooth: true
        }

        TextField {
            id: searchField
            Layout.fillWidth: true
            placeholderText: "Tìm kiếm ứng dụng..."
            palette.text: theme.primary.foreground       // màu chữ chính
            palette.placeholderText: theme.primary.dim_foreground  // sửa thành dim_foreground
            font.pixelSize: currentSizes.fontSize?.normal || 14
            font.family: "ComicShannsMono Nerd Font"
            background: Rectangle { 
                color: "transparent" 
            }
            selectByMouse: true

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

            Keys.onEscapePressed: {
                // Khi nhấn Escape trong search field, đóng panel
                if (typeof root.parent !== 'undefined' && root.parent.parent) {
                    // Tìm LauncherPanel để gọi closePanel
                    var panel = findLauncherPanel(root)
                    if (panel && typeof panel.closePanel === 'function') {
                        panel.closePanel()
                    }
                }
            }

            // Helper function để tìm LauncherPanel
            function findLauncherPanel(item) {
                while (item && item.objectName !== "launcherPanel") {
                    item = item.parent
                    if (!item) return null
                }
                return item
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

    // Function để clear search field
    function clear() {
        searchField.text = ""
        searchField.focus = true
    }
}

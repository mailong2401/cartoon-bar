import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQuick.Effects
import Quickshell.Io
import "./Launcher/"

Rectangle {
    id: appIconsRoot
    width: 200
    height: 50
    color: theme.primary.background
    radius: 10
    border.color: theme.normal.black
    border.width: 3

    property bool launcherPanelVisible: false
    property var theme : currentTheme

    Loader {
    id: launcherPanelLoader
    source: "./Launcher/LauncherPanel.qml"
    active: launcherPanelVisible
    onLoaded: {
        item.visible = Qt.binding(function() { return launcherPanelVisible })
        if (item && item.searchBox && item.searchBox.searchField) {
            Qt.callLater(() => {
                item.searchBox.searchField.forceActiveFocus()
                item.searchBox.searchField.selectAll()
            })
        }
    }
}

      IpcHandler {
      id: ipc
      target: "rect"
      function getToggle() {
        launcherPanelVisible = !launcherPanelVisible
        return 0
    }
    }

    Row {
        anchors.centerIn: parent
        spacing: 15
        Repeater {
            model: ["../assets/dashboard.png"]

            Image {
                source: modelData
                width: 40
                height: 40
                fillMode: Image.PreserveAspectFit
                smooth: true

                Behavior on scale {
                    NumberAnimation { duration: 120; easing.type: Easing.OutQuad }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: {
                        launcherPanelVisible = !launcherPanelVisible
                        
                        // Focus vào search box khi mở panel
                        if (launcherPanelVisible && launcherPanelLoader.item) {
                            launcherPanelLoader.item.forceActiveFocus()
                        }
                    }
                }
            }
        }
    }

    // Xử lý khi theme thay đổi
    onThemeChanged: {
        if (launcherPanelLoader.item) {
            launcherPanelLoader.item.theme = theme
        }
    }
}

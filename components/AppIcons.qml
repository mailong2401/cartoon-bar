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
            item.visible = launcherPanelVisible
            item.closeRequested.connect(function() {
                launcherPanelVisible = false
            })
        }
    }

    IpcHandler {
        id: ipc
        target: "rect"
        function getToggle() {
            if (launcherPanelLoader.status == Loader.Ready) {
                launcherPanelVisible = !launcherPanelVisible
                if (launcherPanelVisible && launcherPanelLoader.item) {
                    launcherPanelLoader.item.forceActiveFocus()
                    launcherPanelLoader.item.openLauncher()
                }
            } else {
                launcherPanelVisible = true
            }
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

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: {
                        launcherPanelVisible = !launcherPanelVisible
                        if (launcherPanelLoader.item && launcherPanelVisible) {
                            launcherPanelLoader.item.forceActiveFocus()
                            launcherPanelLoader.item.openLauncher()
                        }
                    }
                }
            }
        }
    }
}

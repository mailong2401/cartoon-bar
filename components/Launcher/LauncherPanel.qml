import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "../Settings/"

PanelWindow {
    id: launcherPanel
    width: launcherPanel.settingsPanelVisible ? 1000 : 600
    height: launcherPanel.settingsPanelVisible ? 700 : 640
    visible : true

    Behavior on width { NumberAnimation { duration: 10 } }
    Behavior on height { NumberAnimation { duration: 10 } }

    color: "transparent"
    focusable: true

    property var theme : currentTheme
    property bool settingsPanelVisible: false
    property bool launcherPanelVisible: true


    function openSettings() {
        launcherPanel.settingsPanelVisible = true
        launcherPanel.launcherPanelVisible = false
    }

    function openLauncher() {
        launcherPanel.settingsPanelVisible = false
        launcherPanel.launcherPanelVisible = true
      }
      function closePanel() {
        launcherPanel.visible = !launcherPanel.visible
      }

    anchors {
        top: true
        left: true
    }

    margins {
        top: 10
        left: 10
    }

    // Close khi click outside
    MouseArea {
        anchors.fill: parent
        propagateComposedEvents: true
        onPressed: (mouse) => {
            if (mouseY < 0 || mouseY > height || mouseX < 0 || mouseX > width) {
                launcherPanel.visible = false
            }
            mouse.accepted = false
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: 20
        color: theme.primary.background
        border.color: theme.normal.black
        border.width: 3

        RowLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            Sidebar{
                onAppLaunched: {
                    launcherPanel.openLauncher()
                }
                onAppSettings: {
                    launcherPanel.openSettings()
                }
            }

            SettingsPanel {
                id: settingsPanel
                Layout.fillWidth: true
                Layout.fillHeight: true
                visible: launcherPanel.settingsPanelVisible
                Behavior on Layout.preferredWidth {
                    NumberAnimation { duration: 250; easing.type: Easing.InOutQuad }
                }
            }

            ColumnLayout {
                visible: launcherPanel.launcherPanelVisible
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 10

                Text {
                    text: "Ứng dụng"
                    color: theme.primary.foreground
                    font.pixelSize: 40
                    font.bold: true
                    font.family: "ComicShannsMono Nerd Font"
                    Layout.alignment: Qt.AlignHCenter
                }
                
                LauncherSearch{
                    id: searchBox
                    onSearchChanged: (text) => {
                        launcherList.runSearch(text)
                    }
                    onAccepted: (text) => {
                        launcherList.runSearch(text)
                    }
                }
                
                LauncherList {
                    id: launcherList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    onAppLaunched: {
                        closePanel()
                    }
                }
            }
        }
    }

    Shortcut {
        sequence: "Escape"
        onActivated: closePanel()
    }

}

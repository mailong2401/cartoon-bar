import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

// Chỉ định nghĩa PanelWindow, không có ShellRoot
PanelWindow {
    id: launcherPanel
    width: 600
    height: 640
    color: "transparent"
    visible: false
    focusable: true

    property var theme


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
        onPressed: {
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
              theme : launcherPanel.theme
            }

            ColumnLayout {
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
                    theme : launcherPanel.theme
                    onSearchChanged: {
                        launcherList.runSearch(text)
                    }
                    onAccepted: {
                        launcherList.runSearch(text)
                    }
                }
                
                LauncherList {
                    id: launcherList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    onAppLaunched: {
                        launcherPanel.visible = false     // 🔥 Ẩn panel
                    }
                    theme : launcherPanel.theme
                }
            }
        }
    }

    Shortcut {
        sequence: "Escape"
        onActivated: launcherPanel.visible = false
    }

    onVisibleChanged: {
        if (visible) {
            forceActiveFocus()
            if (searchBox) {
                searchBox.forceActiveFocus()
            }
        }
    }
}

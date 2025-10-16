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
        color: "#F5EEE6"
        border.color: "#4f4f5b"
        border.width: 3

        RowLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            Sidebar{}

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 10

                Text {
                    text: "Ứng dụng"
                    color: "#4f4f5b"
                    font.pixelSize: 40
                    font.bold: true
                    font.family: "ComicShannsMono Nerd Font"
                    Layout.alignment: Qt.AlignHCenter
                }
                
                LauncherSearch{
                    id: searchBox
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

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

// Import các thành phần phụ trong cùng thư mục
import "../Settings" as Settings
import "./" as LauncherComponents

PanelWindow {
    id: launcherPanel
    implicitWidth: launcherPanel.settingsPanelVisible ? 1000 : 600
    implicitHeight: launcherPanel.settingsPanelVisible ? 700 : 640
    color: "transparent"
    focusable: true

    signal closeRequested()

    Behavior on width { NumberAnimation { duration: 10 } }
    Behavior on height { NumberAnimation { duration: 10 } }

    property var theme: currentTheme
    property bool settingsPanelVisible: false
    property bool launcherPanelVisible: true

    function openSettings() {
        launcherPanel.settingsPanelVisible = true
        launcherPanel.launcherPanelVisible = false
    }

    function openLauncher() {
        launcherPanel.settingsPanelVisible = false
        launcherPanel.launcherPanelVisible = true
        // Focus vào search field khi mở launcher
        Qt.callLater(function() {
            if (searchBox && searchBox.searchField) {
                searchBox.searchField.forceActiveFocus()
                searchBox.searchField.selectAll()
            }
        })
    }

    // Sửa hàm closePanel
function closePanel() {
    visible = false
    closeRequested()
}

    function togglePanel() {
        launcherPanel.visible = !launcherPanel.visible
        if (launcherPanel.visible) {
            openLauncher()
        }
    }

    anchors {
        bottom: currentSizes.mainPanelPos === "bottom"
        top: currentSizes.mainPanelPos === "top"
        left: true
    }

    margins {
        top: currentSizes.mainPanelPos === "top" ? 10 : 0
        bottom: currentSizes.mainPanelPos === "bottom" ? 10 : 0
        left: 10
    }

    // Focus scope để quản lý focus
    FocusScope {
        anchors.fill: parent
        focus: true

        // Click outside để đóng
        MouseArea {
            anchors.fill: parent
            propagateComposedEvents: true
            onPressed: (mouse) => {
                if (mouseY < 0 || mouseY > height || mouseX < 0 || mouseX > width) {
                    launcherPanel.closePanel()
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

                LauncherComponents.Sidebar {
                    onAppLaunched: launcherPanel.openLauncher()
                    onAppSettings: launcherPanel.openSettings()
                }

                Settings.SettingsPanel {
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

                    LauncherComponents.LauncherSearch {
                        id: searchBox
                        onSearchChanged: (text) => launcherList.runSearch(text)
                        onAccepted: (text) => launcherList.runSearch(text)
                    }

                    LauncherComponents.LauncherList {
                        id: launcherList
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        onAppLaunched: closePanel()
                    }
                }
            }
        }
    }

    // Khi panel trở nên visible, focus vào search field
    onVisibleChanged: {
        if (visible && launcherPanelVisible) {
            Qt.callLater(function() {
                if (searchBox && searchBox.searchField) {
                    searchBox.searchField.forceActiveFocus()
                    searchBox.searchField.selectAll()
                }
            })
        }
    }

    Shortcut {
        sequence: "Escape"
        onActivated: closePanel()
    }

    Component.onCompleted: {
        // Đảm bảo panel không visible khi khởi động
        visible = false
    }
}

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import QtQuick.Effects

import "./components" as Components

ShellRoot {
    id: root

    Components.ThemeLoader { id: themeLoader }
    Components.LanguageLoader { id: languageLoader }
    Components.SizeLoader { id: sizeLoader }
    Components.VolumeOsd { }
    Components.NotificationPopup{}

    property bool clockPanelVisible: true  // trạng thái bảng đồng hồ


    property bool anchorsTop: true
    property bool anchorsBottom: false
    property bool anchorsRight: false
    property bool anchorsLeft: false

    Components.ClockPanel {
        id: clockPanel
        visible: clockPanelVisible
        anchors {
        top: anchorsTop
        bottom: anchorsBottom 
        left: anchorsLeft
        right: anchorsRight
    }
    }

    function setClockPanelPosition(position) {
    // reset trước
    anchorsTop = false
    anchorsBottom = false
    anchorsLeft = false
    anchorsRight = false

    switch (position) {
    case "topLeft":
        anchorsTop = true
        anchorsLeft = true
        break

    case "top":
        anchorsTop = true
        break

    case "topRight":
        anchorsTop = true
        anchorsRight = true
        break

    case "left":
        anchorsLeft = true
        break

    case "center":
        anchorsTop = true
        anchorsBottom = true
        anchorsLeft = true
        anchorsRight = true
        break

    case "right":
        anchorsRight = true
        break

    case "bottomLeft":
        anchorsBottom = true
        anchorsLeft = true
        break

    case "bottom":
        anchorsBottom = true
        break

    case "bottomRight":
        anchorsBottom = true
        anchorsRight = true
        break
    }
}


    function toggleClockPanel() {
        clockPanelVisible = !clockPanelVisible
    }

    property var currentTheme: themeLoader.theme
    property var currentLanguage: languageLoader.translations
    property var currentSizes: sizeLoader.sizes
    property string currentSizeProfile: sizeLoader.currentSizeProfile

    // Property để điều khiển LauncherPanel
    property bool launcherPanelVisible: false
    property string hyprInstance: Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE") || ""

    Connections {
        target: languageLoader
        function onLanguageChanged() {
            currentLanguage = languageLoader.translations
        }
    }

    Connections {
        target: themeLoader
        function onThemeReloaded() {
            currentTheme = themeLoader.theme
        }
    }

    Connections {
        target: sizeLoader
        function onSizesReloaded() {
            currentSizes = sizeLoader.sizes
        }
    }

    Component.onCompleted: {
        setClockPanelPosition("bottom")
    }
    

    PanelWindow {
        id: panel
        implicitHeight: currentSizes.width_panel ?? 0
        color: "transparent"

        anchors {
            left: true
            right: true
            top: true
            bottom: false
        }

        margins {
            top: 10
            left: 10
            right: 10
            bottom: 0
        }

        RowLayout {
            anchors.fill: parent
            spacing: 10

            Components.AppIcons {
                id: appIcons
                Layout.preferredWidth: 60
                Layout.fillHeight: true
                onToggleClockPanel: root.toggleClockPanel()
                onPosClockPanel: root.setClockPanelPosition(pos)


            }

            Components.WorkspacePanel {
                Layout.preferredWidth: 380
                Layout.fillHeight: true
                hyprInstance: root.hyprInstance
            }

            Components.MusicPlayer {
                Layout.preferredWidth: 340
                Layout.fillHeight: true
            }

            Components.Timespace {
                Layout.preferredWidth: 400
                Layout.fillHeight: true
            }

            Components.CpuPanel {
                Layout.preferredWidth: 200
                Layout.fillHeight: true
            }
            
            Components.StatusArea {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }
}

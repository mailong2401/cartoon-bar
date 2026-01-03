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

    property bool clockPanelVisible: currentSizes.clockPanelVisible


    property bool anchorsTop: currentSizes.clockPanelPosition === "top" || currentSizes.clockPanelPosition === "topLeft" || currentSizes.clockPanelPosition === "topRight"
    property bool anchorsBottom: currentSizes.clockPanelPosition === "bottom" || currentSizes.clockPanelPosition === "bottomLeft" || currentSizes.clockPanelPosition === "bottomRight"
    property bool anchorsRight: currentSizes.clockPanelPosition === "right" || currentSizes.clockPanelPosition === "topRight" || currentSizes.clockPanelPosition === "bottomRight"
    property bool anchorsLeft: currentSizes.clockPanelPosition === "left" || currentSizes.clockPanelPosition === "topLeft" || currentSizes.clockPanelPosition === "bottomLeft"

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


    PanelWindow {
        id: panel
        implicitHeight: currentSizes.width_panel || 50
        color: "transparent"

        anchors {
            left: true
            right: true
            top: currentSizes.mainPanelPos === "top"
            bottom: currentSizes.mainPanelPos === "bottom"
        }

        margins {
            top: currentSizes.mainPanelPos === "top" ? 10 : 0
            left: 10
            right: 10
            bottom: currentSizes.mainPanelPos === "bottom" ? 10 : 0
        }

        RowLayout {
            anchors.fill: parent
            spacing: currentSizes.spacingPanel

            Components.AppIcons {
                id: appIcons
                Layout.preferredWidth: 60
                Layout.fillHeight: true
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

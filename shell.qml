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
    Components.ConfigLoader { id: configLoader }
    Components.SizesLoader { id: sizesLoader }
    Components.VolumeOsd { }
    Components.NotificationPopup{}

    property bool clockPanelVisible: currentConfig.clockPanelVisible


    property bool anchorsTop: currentConfig.clockPanelPosition === "top" || currentConfig.clockPanelPosition === "topLeft" || currentConfig.clockPanelPosition === "topRight"
    property bool anchorsBottom: currentConfig.clockPanelPosition === "bottom" || currentConfig.clockPanelPosition === "bottomLeft" || currentConfig.clockPanelPosition === "bottomRight"
    property bool anchorsRight: currentConfig.clockPanelPosition === "right" || currentConfig.clockPanelPosition === "topRight" || currentConfig.clockPanelPosition === "bottomRight"
    property bool anchorsLeft: currentConfig.clockPanelPosition === "left" || currentConfig.clockPanelPosition === "topLeft" || currentConfig.clockPanelPosition === "bottomLeft"

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
    property var currentConfig: configLoader.config
    property string currentConfigProfile: configLoader.currentConfigProfile
    property var currentSizes: sizesLoader.sizes
    property string currentSizeProfile: sizesLoader.currentSizeProfile

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
        target: configLoader
        function onConfigReloaded() {
            currentConfig = configLoader.config
        }
    }

    Connections {
        target: sizesLoader
        function onSizesReloaded() {
            currentSizes = sizesLoader.sizes
        }
    }


    PanelWindow {
        id: panel
        implicitHeight: currentSizes.panelHeight || 50
        color: "transparent"

        anchors {
            left: true
            right: true
            top: currentConfig.mainPanelPos === "top"
            bottom: currentConfig.mainPanelPos === "bottom"
        }

        margins {
            top: currentConfig.mainPanelPos === "top" ? 10 : 0
            left: 10
            right: 10
            bottom: currentConfig.mainPanelPos === "bottom" ? 10 : 0
        }

        RowLayout {
            anchors.fill: parent
            spacing: currentConfig.spacingPanel

            Components.AppIcons {
                id: appIcons
                Layout.preferredWidth: currentSizes.panelWidth?.appIcons || 60
                Layout.fillHeight: true
            }

            Components.WorkspacePanel {
                Layout.preferredWidth: currentSizes.panelWidth?.workspace || 380
                Layout.fillHeight: true
                hyprInstance: root.hyprInstance
            }

            Components.MusicPlayer {
                Layout.preferredWidth: currentSizes.panelWidth?.musicPlayer || 340
                Layout.fillHeight: true
            }

            Components.Timespace {
                Layout.preferredWidth: currentSizes.panelWidth?.timespace || 400
                Layout.fillHeight: true
            }

            Components.CpuPanel {
                Layout.preferredWidth: currentSizes.panelWidth?.cpuPanel || 200
                Layout.fillHeight: true
            }
            
            Components.StatusArea {
                Layout.preferredWidth: currentSizes.panelWidth?.statusArea || 280
                Layout.fillHeight: true
            }
        }
    }
}

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import QtQuick.Effects

import "./config" as Config
import "./modules/dialogs" as Dialogs
import "./modules/panels" as Panels

ShellRoot {
    id: root

    Config.ThemeLoader { id: themeLoader }
    Config.LanguageLoader { id: languageLoader }
    Config.ConfigLoader { id: configLoader }
    Config.SizesLoader { id: sizesLoader }
    Dialogs.VolumeOsd { }
    Dialogs.NotificationPopup{}
    Dialogs.ConfirmDialog { id: confirmDialog }

    // Function để hiển thị confirm dialog từ bất kỳ đâu
    function showConfirmDialog(action, actionLabel) {
        confirmDialog.show(action, actionLabel)
    }

    property bool clockPanelVisible: currentConfig.clockPanelVisible


    property bool anchorsTop: currentConfig.clockPanelPosition === "top" || currentConfig.clockPanelPosition === "topLeft" || currentConfig.clockPanelPosition === "topRight"
    property bool anchorsBottom: currentConfig.clockPanelPosition === "bottom" || currentConfig.clockPanelPosition === "bottomLeft" || currentConfig.clockPanelPosition === "bottomRight"
    property bool anchorsRight: currentConfig.clockPanelPosition === "right" || currentConfig.clockPanelPosition === "topRight" || currentConfig.clockPanelPosition === "bottomRight"
    property bool anchorsLeft: currentConfig.clockPanelPosition === "left" || currentConfig.clockPanelPosition === "topLeft" || currentConfig.clockPanelPosition === "bottomLeft"

    Panels.ClockPanel {
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

    // Global wallpaper setter - chạy độc lập với Settings panel
    Process {
        id: globalWallpaperProcess
        command: ["true"]  // dummy command
        running: false

        stdout: StdioCollector {
            onTextChanged: {
                if (text) {
                }
            }
        }

        stderr: StdioCollector {
            onTextChanged: {
                if (text) {
                }
            }
        }

        onRunningChanged: {
        }
    }

    // Function để set wallpaper từ bất kỳ đâu
    function setGlobalWallpaper(filePath) {

        var configPath = Quickshell.env("HOME") + "/.config/quickshell/cartoon-bar"
        var scriptPath = configPath + "/scripts/set-wallpaper.sh"


        // Stop old process if running
        if (globalWallpaperProcess.running) {
            globalWallpaperProcess.running = false
        }

        // Set new command
        globalWallpaperProcess.command = [
            "bash",
            scriptPath,
            filePath
        ]

        // Start process
        globalWallpaperProcess.running = true
    }

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
            // Update size profile when config changes or on first load
            if (currentConfig.displaySize && sizesLoader.currentSizeProfile !== currentConfig.displaySize) {
                sizesLoader.changeSizeProfile(currentConfig.displaySize)
            }
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

            Panels.AppIcons {
                id: appIcons
                Layout.preferredWidth: currentSizes.panelWidth?.appIcons || 60
                Layout.fillHeight: true
            }

            Panels.WorkspacePanel {
                Layout.preferredWidth: currentSizes.panelWidth?.workspace || 380
                Layout.fillHeight: true
                hyprInstance: root.hyprInstance
            }

            Panels.MusicPlayer {
                Layout.preferredWidth: currentSizes.panelWidth?.musicPlayer || 340
                Layout.fillHeight: true
            }

            Panels.Timespace {
                Layout.preferredWidth: currentSizes.panelWidth?.timespace || 400
                Layout.fillHeight: true
            }

            Panels.CpuPanel {
                Layout.preferredWidth: currentSizes.panelWidth?.cpuPanel || 200
                Layout.fillHeight: true
            }

            Panels.StatusArea {
                Layout.preferredWidth: currentSizes.panelWidth?.statusArea || 430
                Layout.fillHeight: true
            }
        }
    }
}

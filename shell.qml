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
    Components.VolumeOsd { }

    property var currentTheme: themeLoader.theme
    property var currentLanguage: languageLoader.translations

    // Property để điều khiển LauncherPanel
    property bool launcherPanelVisible: false
    property string hyprInstance: Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE") || ""

    Connections {
        target: languageLoader
        onLanguageChanged: currentLanguage = languageLoader.translations
    }

    Connections {
        target: themeLoader
        onThemeReloaded: currentTheme = themeLoader.theme
    }

    

    PanelWindow {
        id: panel
        implicitHeight: 50
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
                Layout.preferredWidth: 280
                Layout.fillHeight: true
            }
            
            Components.StatusArea {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }
}

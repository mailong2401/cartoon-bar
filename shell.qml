import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import "./components"
import "./components/Cpu/"
import "./components/Launcher/"
import "./components/Settings/"

ShellRoot {
    id: root
    property string hyprInstance: Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE") || ""

    ThemeLoader { id: themeLoader }

    property var currentTheme: themeLoader.theme

    Connections {
        target: themeLoader
        onThemeReloaded: currentTheme = themeLoader.theme
    }

    VolumeOsd {
        theme: currentTheme
    }

    PanelWindow {
        id: panel
        implicitHeight: 50
        color: "transparent"
        anchors {
            left: true
            right: true
            top: true
        }
        margins {
            top: 10
            left: 10
            right: 10
        }

        RowLayout {
            anchors.fill: parent
            spacing: 10

            // App Icons (Dashboard Button)
            AppIcons {
                id: appIcons
                Layout.preferredWidth: 60
                Layout.fillHeight: true
                theme: currentTheme
            }

            // Workspace
            WorkspacePanel {
                Layout.preferredWidth: 430
                Layout.fillHeight: true
                hyprInstance: root.hyprInstance
                theme: currentTheme
            }

            // Time & Date
            Timespace {
                Layout.preferredWidth: 360
                Layout.fillHeight: true
                theme: currentTheme
            }

            // CPU Monitor
            CpuPanel {
                Layout.preferredWidth: 280
                Layout.fillHeight: true
                theme: currentTheme
            }

            // Music Player
            MusicPlayer {
                Layout.preferredWidth: 340
                Layout.fillHeight: true
                theme: currentTheme
            }

            // System Status
            StatusArea {
                Layout.fillWidth: true
                Layout.fillHeight: true
                theme: currentTheme
            }
        }
    }
}


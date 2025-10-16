import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import "./components"
import "./cpu"
import "./modules/ram"
import "./modules/weather_time"
import "./components/Cpu/"
import "./components/Launcher/"

ShellRoot {
    id: root
    property string hyprInstance: Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE") || ""

              VolumeOsd{}

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

            // 🎯 App Icons (Dashboard Button)
            AppIcons {
                id: appIcons
                Layout.preferredWidth: 60
                Layout.fillHeight: true
              }

            // 🖥️ Workspace
            WorkspacePanel {
                Layout.preferredWidth: 430
                Layout.fillHeight: true
                hyprInstance: root.hyprInstance
            }

            // ⏰ Time & Date
            Timespace {
                Layout.preferredWidth: 380
                Layout.fillHeight: true
            }
            
            // 🔥 CPU Monitor
            CpuPanel {
                Layout.preferredWidth: 300
                Layout.fillHeight: true
            }

            // 🎵 Music Player
            MusicPlayer {
                Layout.preferredWidth: 340
                Layout.fillHeight: true
            }

            // 📊 System Status
            StatusArea {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }
}

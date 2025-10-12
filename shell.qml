import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import "."

ShellRoot {
    id: root
    property string hyprInstance: Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE") || ""
    
    PanelWindow {
        id: panel
        implicitHeight: 50
        color: "transparent"
        anchors {
            left: true
            right: true
            top: true
        }

        Row {
            anchors.fill: parent
            spacing: 10

            AppIcons {
                width: 110
                height: parent.height
            }

            WorkspacePanel {
                width: 430
                height: parent.height
                hyprInstance: root.hyprInstance
            }
            // ⏰ Đồng hồ
            Timespace {
                width: 320
                height: parent.height
            }
            
            CpuPanel {
                width: 240
                height: parent.height
            }

            // 🎵 Music Player
            MusicPlayer {
                width: 360
                height: parent.height
              }

            StatusArea { width: 390; height: parent.height }
        }
    }
}

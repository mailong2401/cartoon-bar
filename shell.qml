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
          margins {
            top: 10
            left: 10
          }

        RowLayout {
            anchors.fill: parent
            spacing: 10

            AppIcons {
                width: 60
                height: parent.height
            }

            WorkspacePanel {
                width: 350
                height: parent.height
                hyprInstance: root.hyprInstance
            }
            // ⏰ Đồng hồ
            Timespace {
                width: 350
                height: parent.height
            }
            
            CpuPanel {
                width: 300
                height: parent.height
            }

            // 🎵 Music Player
            MusicPlayer {
                width: 340
                height: parent.height
              }

            StatusArea {
                width:  410    // ví dụ trừ một phần khác
                height: parent.height
            }

        }
    }
}

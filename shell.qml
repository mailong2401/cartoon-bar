import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "."   // 👈 thêm dòng này để nhận diện Timespace.qml

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
                width: 200
                height: parent.height
            }

            WorkspacePanel {
                width: 430
                height: parent.height
                hyprInstance: root.hyprInstance
            }

            // ⏰ Đồng hồ
            Timespace {
                width: 400
                height: parent.height
            }

            Rectangle {
                width: parent.width
                height: parent.height
                color: "#8be9fd"
                radius: 6
                Text {
                    anchors.centerIn: parent
                    text: "Ô 4"
                    color: "black"
                    font.pixelSize: 14
                }
            }
        }
    }
}


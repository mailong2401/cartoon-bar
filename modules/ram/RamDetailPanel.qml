import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

PanelWindow {
    id: ramDetailPanel

    // Sử dụng WlrLayershell để căn giữa
    implicitWidth: 1030
    implicitHeight: 850
    margins {
        top: 10
        left: (Quickshell.screens.primary?.width ?? 1920) / 2 - implicitWidth / 2
    }
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: "#F5EEE6"
        radius: 8
        border.color: "#4f4f5b"
        border.width: 3

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 16
            RamDetailHeader{
                Layout.fillWidth: true
                Layout.preferredHeight: 70
            }
        }
    }
}

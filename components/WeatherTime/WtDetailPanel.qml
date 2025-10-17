import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

PanelWindow {
    id: wtDetailPanel

    // Sử dụng WlrLayershell để căn giữa
    implicitWidth: 400
    implicitHeight: 500

    property var theme

    margins {
        top: 10
        left: 430
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
            WtDetailHeader{
                Layout.fillWidth: true
                Layout.preferredHeight: 70
              }
            WtDetailCalendar{
              anchors.horizontalCenter: parent.horizontalCenter

            }
        }
    }
}

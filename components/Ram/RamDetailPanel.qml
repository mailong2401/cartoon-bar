import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

PanelWindow {
    id: root

    // Sử dụng WlrLayershell để căn giữa
    implicitWidth: 1030
    implicitHeight: 850
    margins {
        top: 10
        left: (Quickshell.screens.primary?.width ?? 1920) / 2 - implicitWidth / 2
    }
    color: "transparent"

    property var theme : currentTheme

    Rectangle {
        anchors.fill: parent
        color: theme.primary.background
        radius: 8
        border.color: theme.normal.black
        border.width: 3

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 16

            RamDisplay {

            }

        }
    }
}

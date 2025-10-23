import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "./" as Components

PanelWindow {
    id: root

    // Sử dụng WlrLayershell để căn giữa
    implicitWidth: 930
    implicitHeight: 930
    margins {
        top: 10
        left: (Quickshell.screens.primary?.width ?? 1920) / 2 - implicitWidth / 2
    }
    color: "transparent"

    property var theme : currentTheme
    property var lang : currentLanguage

    Rectangle {
        anchors.fill: parent
        color: theme.primary.background
        radius: 8
        border.color: theme.normal.black
        border.width: 3

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 30

            Components.RamDetailHeader {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
            }

            Components.RamDisplay {
                Layout.fillWidth: true
                Layout.preferredHeight: 300
            }

            Components.RamTaskManager {
                Layout.fillWidth: true
                Layout.preferredHeight: 500
            }

        }
    }
}

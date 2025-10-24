import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "./" as Components

PanelWindow {
    id: batteryDetailPanel

    width: 430
    height: 400
    anchors {
      top: true
      right: true
    }
    margins {
        top: 10
        right: 10
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

            // Header
            Text {
                text: "🔋 Battery Details"
                font.family: "ComicShannsMono Nerd Font"
                color: theme.primary.foreground
                font.bold: true
                font.pointSize: 16
                Layout.alignment: Qt.AlignHCenter
            }

            // Battery Panel Component
            Components.BatteryPanel {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }

    Timer {
        interval: 2000
        running: batteryDetailPanel.visible
        repeat: true
        onTriggered: {
            // Refresh data khi panel hiển thị
        }
    }

    Component.onCompleted: {
        // Khởi tạo dữ liệu
    }
}

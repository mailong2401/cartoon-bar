import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "./" as Components

PanelWindow {
    id: batteryDetailPanel

    property var sizes: currentSizes.batteryDetailPanel || {}
    property var theme: currentTheme

    width: sizes.width || 430
    height: sizes.height || 400
    anchors {
        top: currentConfig.mainPanelPos === "top"
        bottom: currentConfig.mainPanelPos === "bottom"
        right: true
    }
    margins {
        top: currentConfig.mainPanelPos === "top" ? (sizes.anchorMargin || 10) : 0
        right: sizes.anchorMargin || 10
        bottom: currentConfig.mainPanelPos === "bottom" ? (sizes.anchorMargin || 10) : 0
    }
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: theme.primary.background
        radius: sizes.radius || 8
        border.color: theme.normal.black
        border.width: sizes.borderWidth || 3

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: sizes.margins || 16
            spacing: sizes.spacing || 16

            // Header
            Text {
                text: "🔋 Battery Details"
                font.family: "ComicShannsMono Nerd Font"
                color: theme.primary.foreground
                font.bold: true
                font.pixelSize: sizes.headerFontSize || 16
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

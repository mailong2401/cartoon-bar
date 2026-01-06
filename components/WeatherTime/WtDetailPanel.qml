import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "./" as Components

PanelWindow {
    id: wtDetailPanel

    property var sizes: currentSizes.wtDetailPanel || {}
    property var theme: currentTheme

    implicitWidth: sizes.panelWidth || 500
    implicitHeight: sizes.panelHeight || 500

    anchors {
        top: currentConfig.mainPanelPos === "top"
        bottom: currentConfig.mainPanelPos === "bottom"
    }

    margins {
        top: currentConfig.mainPanelPos === "top" ? (sizes.marginTop || 10) : 0
        bottom: currentConfig.mainPanelPos === "bottom" ? (sizes.marginBottom || 10) : 0
        left: sizes.marginLeft || 800
    }
    exclusiveZone: 0
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: theme.primary.background
        radius: sizes.panelRadius || 8
        border.color: theme.normal.black
        border.width: sizes.panelBorderWidth || 3

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: sizes.panelMargins || 16
            spacing: sizes.spacing || 16

            Components.WtDetailHeader {
                Layout.fillWidth: true
                Layout.preferredHeight: sizes.header?.height || 70
                sizes: wtDetailPanel.sizes
            }

            Components.WtDetailCalendar {
                Layout.alignment: Qt.AlignHCenter
                sizes: wtDetailPanel.sizes
            }
        }
    }
}

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "./" as Components


PanelWindow {
    id: wtDetailPanel

    implicitWidth: currentSizes.wtDetailPanel?.panelWidth || 500
    implicitHeight: currentSizes.wtDetailPanel?.panelHeight || 500

    property var theme : currentTheme

    anchors {
      top: currentConfig.mainPanelPos === "top"
      bottom: currentConfig.mainPanelPos === "bottom"
    }

    margins {
        top: currentConfig.mainPanelPos === "top" ? 10 : 0
        bottom: currentConfig.mainPanelPos === "bottom" ? 10 : 0
        left: currentSizes.wtDetailPanel?.marginLeft || 800
    }
    exclusiveZone: 0
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: theme.primary.background
        radius: currentSizes.wtDetailPanel?.panelRadius || 8
        border.color: theme.normal.black
        border.width: currentSizes.wtDetailPanel?.panelBorderWidth || 3

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: currentSizes.wtDetailPanel?.panelMargins || 16
            spacing: currentSizes.wtDetailPanel?.spacing || 16
            Components.WtDetailHeader{
                Layout.fillWidth: true
                Layout.preferredHeight: currentSizes.wtDetailPanel?.header?.height || 70
              }
            Components.WtDetailCalendar{
              Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}

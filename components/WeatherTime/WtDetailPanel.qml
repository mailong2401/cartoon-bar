import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "./" as Components


PanelWindow {
    id: wtDetailPanel

    implicitWidth: 500
    implicitHeight: 500

    property var theme : currentTheme

    anchors {
      top: currentSizes.mainPanelPos === "top"
      bottom: currentSizes.mainPanelPos === "bottom"
    }

    margins {
        top: currentSizes.mainPanelPos === "top" ? 10 : 0
        bottom: currentSizes.mainPanelPos === "bottom" ? 10 : 0
        left: 800
    }
    exclusiveZone: 0
    color: "transparent"

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
            Components.WtDetailHeader{
                Layout.fillWidth: true
                Layout.preferredHeight: 70
              }
            Components.WtDetailCalendar{
              Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}

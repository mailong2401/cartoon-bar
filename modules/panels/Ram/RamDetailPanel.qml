import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "./" as Components

PanelWindow {
    id: root

    implicitWidth: currentSizes.ramManagement?.panelWidth || 930
    implicitHeight: currentSizes.ramManagement?.panelHeight || 960

    anchors {
        top: currentConfig.mainPanelPos === "top"
        bottom: currentConfig.mainPanelPos === "bottom"
        left: true
    }

    margins {
        top: currentConfig.mainPanelPos === "top" ? 10 : 0
        bottom: currentConfig.mainPanelPos === "bottom" ? 10 : 0
        left: Math.round((Quickshell.screens.primary?.width ?? currentSizes.name) / 2 - implicitWidth / 2)
    }

    exclusiveZone: 0
    color: "transparent"

    property var theme : currentTheme
    property var lang : currentLanguage
    
    Rectangle {
        anchors.fill: parent
        color: theme.primary.background
        radius: currentSizes.ramManagement?.panelRadius || 8
        border.color: theme.normal.black
        border.width: currentSizes.ramManagement?.panelBorderWidth || 3

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: currentSizes.ramManagement?.panelMargins || 16
            spacing: currentSizes.ramManagement?.spacing || 30

            Components.RamDetailHeader {
                Layout.fillWidth: true
                Layout.preferredHeight: currentSizes.ramManagement?.header?.height || 40
            }

            Components.RamDisplay {
                Layout.fillWidth: true
                Layout.preferredHeight: currentSizes.ramManagement?.ramDisplay?.height || 300
            }

            Components.RamTaskManager {
                Layout.fillWidth: true
                Layout.preferredHeight: currentSizes.ramManagement?.ramTaskManager?.height || 500
            }

        }
    }
}
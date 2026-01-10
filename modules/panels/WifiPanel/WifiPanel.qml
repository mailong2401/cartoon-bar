import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell

PanelWindow {
    id: wifiPanel
    property var sizes: currentSizes.wifiPanel || {}
    implicitWidth: sizes.width || 430
    implicitHeight: sizes.height || 800
    color: "transparent"
    focusable: true
    aboveWindows: true
    objectName: "WiFiPanel"

    required property var wifiManager
    property var theme: currentTheme
    property var lang: currentLanguage

    Rectangle {
        radius: sizes.radius || 10
        anchors.fill: parent
        color: theme.primary.background
        border.width: sizes.borderWidth || 2
        border.color: theme.normal.black

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: sizes.margins || 16
            spacing: sizes.spacing || 12

            WifiHeader {
                Layout.fillWidth: true
                sizes: wifiPanel.sizes
                theme: wifiPanel.theme
                lang: wifiPanel.lang
                wifiManager: wifiPanel.wifiManager
            }

            WifiStatus {
                Layout.fillWidth: true
                sizes: wifiPanel.sizes
                theme: wifiPanel.theme
                lang: wifiPanel.lang
                wifiManager: wifiPanel.wifiManager
            }

            WifiNetworkList {
                Layout.fillWidth: true
                Layout.fillHeight: true
                sizes: wifiPanel.sizes
                theme: wifiPanel.theme
                lang: wifiPanel.lang
                wifiManager: wifiPanel.wifiManager
                visible: wifiManager.wifiEnabled
            }

            WifiEmptyState {
                Layout.fillWidth: true
                Layout.fillHeight: true
                sizes: wifiPanel.sizes
                theme: wifiPanel.theme
                lang: wifiPanel.lang
                visible: !wifiManager.wifiEnabled
            }
        }
    }
}

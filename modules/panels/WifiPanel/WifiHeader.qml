import QtQuick
import QtQuick.Layouts

RowLayout {
    id: header
    property var sizes
    property var theme
    property var lang
    property var wifiManager
    
    spacing: sizes.headerSpacing || 20
    
    Rectangle {
        width: sizes.headerIconContainerSize || 70
        height: sizes.headerIconContainerSize || 70
        radius: sizes.headerIconContainerRadius || 12
        color: "transparent"
        Image {
            source: "../../../assets/system/wifi.png"
            fillMode: Image.PreserveAspectFit
            smooth: true
            width: sizes.headerIconSize || 50
            height: sizes.headerIconSize || 50
            anchors.centerIn: parent
        }
    }
    
    Text {
        text: "WiFi"
        font.pixelSize: sizes.headerTitleFontSize || 50
        font.family: "ComicShannsMono Nerd Font"
        font.bold: true
        color: theme.primary.foreground
    }
    
    Item { Layout.fillWidth: true }
    
    Rectangle {
        width: sizes.refreshButtonSize || 60
        height: sizes.refreshButtonSize || 60
        radius: sizes.refreshButtonRadius || 10
        color: refreshMouseArea.containsMouse ? theme.normal.yellow : theme.primary.dim_background
        Image {
            source: '../../../assets/wifi/refresh.png'
            fillMode: Image.PreserveAspectFit
            width: sizes.refreshIconSize || 44
            height: sizes.refreshIconSize || 44
            anchors.centerIn: parent
        }
        MouseArea {
            id: refreshMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if (wifiManager.wifiEnabled) {
                    wifiManager.scanWifiNetworks()
                }
            }
        }
    }
}
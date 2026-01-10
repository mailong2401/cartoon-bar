import QtQuick
import QtQuick.Layouts

Column {
    id: networkItem
    property var sizes
    property var theme
    property var lang
    property var wifiManager
    property var networkData
    
    width: parent.width
    spacing: 4

    Rectangle {
        id: wifiItem
        width: parent.width
        height: sizes.networkItemHeight || 70
        radius: sizes.networkItemRadius || 12
        color: mouseArea.containsMouse ?
               theme.button.background_select :
               (networkData.isConnected ? theme.normal.blue : theme.primary.dim_background)
        border.width: sizes.borderWidth || 2
        border.color: networkData.isConnected ? theme.normal.blue : theme.normal.black

        RowLayout {
            anchors.margins: sizes.networkItemMargins || 8
            anchors.fill: parent
            
            Column {
                Layout.fillWidth: true
                Text {
                    text: networkData.ssid
                    font.pixelSize: sizes.networkNameFontSize || 18
                    font.bold: true
                    color: networkData.isConnected ? theme.normal.black : theme.primary.foreground
                    font.family: "ComicShannsMono Nerd Font"
                }
                Text {
                    text: networkData.security + " • " + networkData.signal
                    font.pixelSize: sizes.networkInfoFontSize || 13
                    color: networkData.isConnected ? theme.normal.black : theme.primary.dim_foreground
                    font.family: "ComicShannsMono Nerd Font"
                }
            }
            
            Item {
                width: sizes.networkIconSize || 40
                height: sizes.networkIconSize || 40
                Image {
                    source: networkData.isConnected ?
                           "../../../assets/wifi/check-mark.png" :
                           "../../../assets/wifi/padlock.png"
                    width: parent.width - 12
                    height: parent.height - 12
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                }
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if (wifiManager.openSsid === networkData.ssid) {
                    wifiManager.openSsid = ""
                } else {
                    wifiManager.openSsid = networkData.ssid
                }
            }
        }
    }

    WifiPasswordBox {
        visible: networkItem.networkData.ssid === wifiManager.openSsid
        networkData: networkItem.networkData
        sizes: networkItem.sizes
        theme: networkItem.theme
        lang: networkItem.lang
        wifiManager: networkItem.wifiManager
        width: parent.width
    }
}

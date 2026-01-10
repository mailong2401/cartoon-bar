import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ColumnLayout {
    id: networkList
    property var sizes
    property var theme
    property var lang
    property var wifiManager
    
    Rectangle {
        height: 20
        Layout.fillWidth: true
        color: "transparent"

        Text {
            anchors {
                fill: parent
                leftMargin: sizes.sectionLabelMargin || 10
            }
            text: (lang?.wifi?.available_networks || "Mạng có sẵn") + 
                  " (" + wifiManager.wifiList.length + ")"
            font.pixelSize: sizes.sectionLabelFontSize || 17
            color: theme.primary.dim_foreground
            font.family: "ComicShannsMono Nerd Font"
        }
    }

    ScrollView {
        Layout.fillWidth: true
        Layout.fillHeight: true
        
        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
            background: Rectangle {
                color: theme.primary.dim_background
                radius: 3
            }
            contentItem: Rectangle {
                color: theme.normal.blue
                radius: 3
            }
        }

        ListView {
            id: wifiListView
            model: wifiManager.wifiList
            spacing: 6

            delegate: WifiNetworkItem {
                width: wifiListView.width
                networkData: modelData
                sizes: networkList.sizes
                theme: networkList.theme
                lang: networkList.lang
                wifiManager: networkList.wifiManager
            }
        }
    }
}

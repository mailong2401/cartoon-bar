import QtQuick
import QtQuick.Layouts

Rectangle {
    id: wifiStatus
    property var sizes
    property var theme
    property var lang
    property var wifiManager
    
    height: sizes.statusCardHeight || 80
    radius: sizes.statusCardRadius || 12
    color: theme.primary.dim_background
    border.width: sizes.borderWidth || 2
    border.color: theme.normal.black

    RowLayout {
        anchors.fill: parent
        anchors.margins: sizes.statusCardMargins || 12
        
        Column {
            Layout.fillWidth: true
            Text {
                text: wifiManager.wifiEnabled ? 
                      (lang?.wifi?.enabled || "WiFi đang bật") : 
                      (lang?.wifi?.disabled || "WiFi đang tắt")
                font.pixelSize: sizes.statusTitleFontSize || 20
                font.bold: true
                color: wifiManager.wifiEnabled ? theme.normal.blue : theme.normal.red
                font.family: "ComicShannsMono Nerd Font"
            }
            Text {
                text: wifiManager.connectedWifi || 
                      (lang?.wifi?.not_connected || "Chưa kết nối")
                font.pixelSize: sizes.statusSubtitleFontSize || 14
                color: theme.primary.dim_foreground
                elide: Text.ElideRight
                font.family: "ComicShannsMono Nerd Font"
            }
        }
        
        // Custom Toggle Switch - Updated design
        Rectangle {
            width: sizes.toggleWidth || 56
            height: sizes.toggleHeight || 32
            radius: sizes.toggleRadius || 16
            color: wifiManager.wifiEnabled ? theme.normal.blue : theme.button.background
            
            scale: toggleMouseArea.containsPress ? 0.95 : (toggleMouseArea.containsMouse ? 1.05 : 1.0)
            Behavior on scale { 
                NumberAnimation { 
                    duration: 150; 
                    easing.type: Easing.OutBack 
                } 
            }
            Behavior on color { 
                ColorAnimation { 
                    duration: 300 
                } 
            }

            Rectangle {
                id: toggleIndicator
                x: wifiManager.wifiEnabled ? parent.width - width - 4 : 4
                y: 4
                width: sizes.toggleIndicatorSize || 24
                height: sizes.toggleIndicatorSize || 24
                radius: (sizes.toggleIndicatorSize || 24) / 2
                color: theme.primary.dim_background
                border.width: 1
                border.color: theme.normal.black

                Behavior on x { 
                    NumberAnimation { 
                        duration: 200; 
                        easing.type: Easing.OutCubic 
                    } 
                }
            }

            MouseArea {
                id: toggleMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    wifiManager.toggleWifi()
                }
            }
        }
    }
}

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
    
    // Nút refresh với icon search và hiệu ứng giống hệt Bluetooth
    Rectangle {
        id: scanButton
        Layout.preferredWidth: sizes.scanButtonSize || 55
        Layout.preferredHeight: sizes.scanButtonSize || 55
        radius: sizes.scanButtonRadius || 28
        visible: wifiManager.wifiEnabled || false
        color: {
            if (wifiManager.isScanning) return theme.normal.red
            if (scanButtonMouse.containsMouse) return theme.normal.blue
            return theme.primary.dim_background
        }

        scale: scanButtonMouse.containsPress ? 0.95 : (scanButtonMouse.containsMouse ? 1.1 : 1.0)
        Behavior on scale { 
            NumberAnimation { 
                duration: 200; 
                easing.type: Easing.OutCubic 
            } 
        }
        Behavior on color { 
            ColorAnimation { 
                duration: 200 
            } 
        }

        // Sử dụng icon search giống Bluetooth
        Image {
            source: "../../../assets/search.png"
            width: sizes.scanIconSize || 40
            height: sizes.scanIconSize || 40
            sourceSize: Qt.size(sizes.scanIconSize || 40, sizes.scanIconSize || 40)
            anchors.centerIn: parent
        }

        // Animation khi đang quét mạng - giống hệt Bluetooth
        Rectangle {
            anchors.fill: parent
            radius: sizes.scanButtonRadius || 28
            color: "transparent"
            border.width: 2
            border.color: theme.normal.green
            visible: wifiManager.isScanning
            rotation: scanRotation

            RotationAnimator on rotation {
                id: scanRotation
                from: 0
                to: 360
                duration: 1000
                loops: Animation.Infinite
                running: wifiManager.isScanning
            }

            Rectangle {
                width: 4
                height: 4
                radius: 2
                color: theme.normal.green
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: -2
            }
        }

        MouseArea {
            id: scanButtonMouse
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

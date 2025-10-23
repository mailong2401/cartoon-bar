import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell

PanelWindow {
    id: wifiPanel
    width: 430
    height: 800
    color: "transparent"
    focusable: true
    aboveWindows: true
    objectName: "WiFiPanel"

    // Nhận wifiManager từ bên ngoài
    required property var wifiManager
    property var theme : currentTheme

    Rectangle {
        radius: 10
        anchors.fill: parent
        color: theme.primary.background
        border.width: 2
        border.color: theme.normal.black

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            // HEADER
            RowLayout {
                Layout.fillWidth: true
                spacing: 20
                Rectangle {
                    width: 70; height: 70; radius: 12
                    color: "transparent"
                    Image {
                        source: "../../assets/system/wifi.png"
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        width: parent.width - 20
                        height: parent.height - 20
                        anchors.centerIn: parent
                    }
                }
                Text {
                    text: "WiFi"
                    font.pixelSize: 50
                    font.family: "ComicShannsMono Nerd Font"
                    font.bold: true
                    color: theme.primary.foreground
                }
                Item { Layout.fillWidth: true }
                Rectangle {
                    width: 60; height: 60; radius: 10
                    color: refreshMouseArea.containsMouse ? theme.normal.yellow : theme.primary.dim_background
                    Image {
                        source: '../../assets/wifi/refresh.png'
                        fillMode: Image.PreserveAspectFit
                        width: parent.width - 16
                        height: parent.height - 16
                        anchors.centerIn: parent
                    }
                    MouseArea {
                        id: refreshMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: if (wifiManager.wifiEnabled) wifiManager.scanWifiNetworks()
                    }
                }
            }

            // WIFI STATUS
            Rectangle {
                Layout.fillWidth: true; height: 80; radius: 12; 
                color: theme.primary.dim_background
                border.width: 2
                border.color: theme.normal.black

                RowLayout {
                    anchors.fill: parent; anchors.margins: 12
                    Column {
                        Layout.fillWidth: true
                        Text {
                            text: wifiManager.wifiEnabled ? "WiFi đang bật" : "WiFi đang tắt"
                            font.pixelSize: 20; font.bold: true; 
                            color: wifiManager.wifiEnabled ? theme.normal.green : theme.normal.red
                            font.family: "ComicShannsMono Nerd Font"
                        }
                        Text { 
                            text: wifiManager.connectedWifi || "Chưa kết nối"; 
                            font.pixelSize: 14; 
                            color: theme.primary.dim_foreground; 
                            elide: Text.ElideRight 
                            font.family: "ComicShannsMono Nerd Font"
                        }
                    }
                    Switch {
                        checked: wifiManager.wifiEnabled
                        onCheckedChanged: if (checked !== wifiManager.wifiEnabled) wifiManager.toggleWifi()
                        
                        // Custom switch styling
                        indicator: Rectangle {
                            implicitWidth: 48
                            implicitHeight: 26
                            radius: 13
                            color: parent.checked ? theme.normal.green : theme.normal.black
                            border.color: parent.checked ? theme.normal.green : theme.primary.dim_foreground

                            Rectangle {
                                x: parent.checked ? parent.width - width : 0
                                width: 26
                                height: 26
                                radius: 13
                                color: parent.checked ? theme.primary.foreground : theme.primary.dim_foreground
                                border.color: theme.normal.black
                            }
                        }
                    }
                }
            }

            Rectangle {
                height: 20
                Layout.fillWidth: true
                color: "transparent"

                Text {
                    anchors {
                        fill: parent
                        leftMargin: 10
                    }
                    text: "Mạng có sẵn (" + wifiManager.wifiList.length + ")"
                    visible: wifiManager.wifiEnabled
                    font.pixelSize: 17; 
                    color: theme.primary.dim_foreground
                    font.family: "ComicShannsMono Nerd Font"
                }
            }

            // WIFI LIST
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                visible: wifiManager.wifiEnabled

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

                    delegate: Column {
                        width: wifiListView.width
                        spacing: 4

                        Rectangle {
                            id: wifiItem
                            width: parent.width
                            height: 70
                            radius: 12
                            color: mouseArea.containsMouse ? 
                                   theme.button.background_select : 
                                   (modelData.isConnected ? theme.normal.green : theme.primary.dim_background)
                            border.width: 2
                            border.color: modelData.isConnected ? theme.normal.green : theme.normal.black

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 8
                                RowLayout {
                                    anchors.fill: parent
                                    Column { 
                                        Layout.fillWidth: true
                                        Text { 
                                            text: modelData.ssid; 
                                            font.pixelSize: 18; 
                                            font.bold: true; 
                                            color: modelData.isConnected ? theme.normal.black : theme.primary.foreground
                                            font.family: "ComicShannsMono Nerd Font"
                                        }
                                        Text { 
                                            text: modelData.security + " • " + modelData.signal; 
                                            font.pixelSize: 13; 
                                            color: modelData.isConnected ? theme.normal.black : theme.primary.dim_foreground
                                            font.family: "ComicShannsMono Nerd Font"
                                        }
                                    }
                                    Rectangle {
                                        width: 40; height: 40; radius: 8
                                        color: modelData.isConnected ? theme.normal.black : theme.normal.magenta
                                        Image { 
                                            source: modelData.isConnected ? 
                                                   "../../assets/wifi/check-mark.png" : 
                                                   "../../assets/wifi/padlock.png";
                                            width: parent.width - 12
                                            height: parent.height - 12
                                            anchors.centerIn: parent
                                            fillMode: Image.PreserveAspectFit
                                        }
                                    }
                                }
                            }

                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (wifiManager.openSsid === modelData.ssid) {
                                        wifiManager.openSsid = ""
                                    } else {
                                        wifiManager.openSsid = modelData.ssid
                                    }
                                }
                            }
                        }

                        Rectangle {
                            id: passwordBox
                            visible: modelData.ssid === wifiManager.openSsid
                            color: theme.primary.dim_background
                            radius: 12
                            width: parent.width
                            height: visible ? 100 : 0
                            border.width: 2
                            border.color: theme.normal.blue
                            Behavior on height { 
                                NumberAnimation { duration: 200 } 
                            }

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 12
                                spacing: 8

                                Text { 
                                    text: "🔒 " + modelData.ssid; 
                                    font.pixelSize: 14; 
                                    color: theme.primary.foreground
                                    font.family: "ComicShannsMono Nerd Font"
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 8
                                    TextField {
                                        id: wifiPassword
                                        Layout.fillWidth: true
                                        placeholderText: modelData.security === "Open" ? "Không cần mật khẩu" : "Nhập mật khẩu"
                                        echoMode: TextInput.Password
                                        enabled: modelData.security !== "Open"
                                        font.family: "ComicShannsMono Nerd Font"
                                        background: Rectangle {
                                            color: theme.primary.background
                                            radius: 8
                                            border.color: theme.normal.blue
                                            border.width: 1
                                        }

                                        onActiveFocusChanged: {
                                            wifiManager.userTyping = activeFocus
                                        }
                                    }
                                    Button {
                                        text: "Kết nối"
                                        font.family: "ComicShannsMono Nerd Font"
                                        background: Rectangle {
                                            color: parent.down ? theme.normal.blue : 
                                                   parent.hovered ? theme.bright.blue : theme.normal.blue
                                            radius: 8
                                        }
                                        contentItem: Text {
                                            text: parent.text
                                            color: theme.primary.foreground
                                            font: parent.font
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                        }
                                        
                                        onClicked: {
                                            if (wifiPassword.text.trim().length === 0 && modelData.security !== "Open") {
                                                console.log("⚠️ Cần nhập mật khẩu")
                                                return
                                            }
                                            wifiManager.connectToWifi(modelData.ssid, wifiPassword.text)
                                            wifiManager.openSsid = ""
                                            wifiPassword.text = ""
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // EMPTY STATE
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                visible: !wifiManager.wifiEnabled
                color: "transparent"
                Column {
                    anchors.centerIn: parent
                    spacing: 16
                    Rectangle {
                        width: 80; height: 80; radius: 16
                        color: theme.normal.red
                        anchors.horizontalCenter: parent.horizontalCenter
                        Text { 
                            text: "📶"; 
                            font.pixelSize: 40
                            anchors.centerIn: parent
                        }
                    }
                    Text { 
                        text: "WiFi đang tắt"; 
                        font.pixelSize: 18; 
                        color: theme.primary.foreground
                        font.family: "ComicShannsMono Nerd Font"
                    }
                    Text { 
                        text: "Bật WiFi để xem mạng khả dụng"; 
                        font.pixelSize: 14; 
                        color: theme.primary.dim_foreground
                        font.family: "ComicShannsMono Nerd Font"
                    }
                }
            }
        }
    }
}

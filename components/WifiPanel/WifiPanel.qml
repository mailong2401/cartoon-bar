import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell

PanelWindow {
    id: wifiPanel
    width: 510
    height: 800
    color: "transparent"
    focusable: true
    aboveWindows: true
    objectName: "WiFiPanel"


    // Nhận wifiManager từ bên ngoài
    required property var wifiManager
    property var theme

    Rectangle {
        radius: 20
        anchors.fill: parent
        color: theme.primary.background
        border.width: 3
        border.color: theme.normal.black


        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            // HEADER
            RowLayout {
                Layout.fillWidth: true
                spacing: 20
                Image {
                  source: "../../assets/wifi/wifi_4.png"
                  fillMode: Image.PreserveAspectFit
                  smooth: true
                  Layout.preferredWidth: 70
                  Layout.preferredHeight: 70

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
                    width: 80; height: 80; radius: 8
                    color: refreshMouseArea.containsMouse ? "#E8D8C9" : "transparent"
                    Image {
                      source: '../../assets/wifi/refresh.png'
                      fillMode: Image.PreserveAspectFit
                      width: parent.width
                      height: parent.height
                      scale: 0.7 // thu nhỏ 80%
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
              Layout.fillWidth: true; height: 80; radius: 12; color: theme.primary.dim_background
              border.width: 3
              border.color: "#4f4f5b"

                RowLayout {
                    anchors.fill: parent; anchors.margins: 12
                    Column {
                        Layout.fillWidth: true
                        Text {
                            text: wifiManager.wifiEnabled ? "WiFi đang bật" : "WiFi đang tắt"
                            font.pixelSize: 20; font.bold: true; color: theme.primary.foreground
                            font.family: "ComicShannsMono Nerd Font"

                        }
                        Text { 
                            text: wifiManager.connectedWifi; 
                            font.pixelSize: 12; color: theme.primary.dim_foreground; elide: Text.ElideRight 
                            font.family: "ComicShannsMono Nerd Font"

                        }
                    }
                    Switch {
                        checked: wifiManager.wifiEnabled
                        onCheckedChanged: if (checked !== wifiManager.wifiEnabled) wifiManager.toggleWifi()
                    }
                }
            }

            Rectangle {
              height: 20
              Layout.fillWidth: true
              color: "transparent"

              Text {
                anchors {
                    fill: parent     // 🔥 gọn hơn, thay vì top/bottom/left riêng lẻ
                    leftMargin: 10   // (tùy chọn) cách mép trái một chút cho đẹp
                }
                  text: "Mạng có sẵn (" + wifiManager.wifiList.length + ")"
                  visible: wifiManager.wifiEnabled
                  font.pixelSize: 17; color: theme.primary.dim_foreground
                  font.family: "ComicShannsMono Nerd Font"

              }
            }

            // WIFI LIST
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                visible: wifiManager.wifiEnabled

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
                            color: mouseArea.containsMouse ? theme.button.background_select : (modelData.isConnected ? theme.normal.green : theme.primary.dim_background)
                            border.width: 3
                            border.color: "#4f4f5b"

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 8
                                RowLayout {
                                anchors.fill: parent
                                Column { 
                                    Layout.fillWidth: true
                                    Text { 
                                        text: modelData.ssid; 
                                        font.pixelSize: 20; font.bold: true; color: modelData.isConnected ? theme.normal.black : theme.primary.foreground
                                        font.family: "ComicShannsMono Nerd Font"

                                    }
                                    Text { 
                                        text: modelData.security + " • " + modelData.signal; 
                                        font.pixelSize: 15; color: theme.primary.dim_foreground
                                        font.family: "ComicShannsMono Nerd Font"
                                    }
                                }
                                Image { 
                                  source: modelData.isConnected ? "../../assets/wifi/check-mark.png" : "../../assets/wifi/padlock.png";
                                  Layout.preferredWidth: 40
                                  Layout.preferredHeight: 40
                                  fillMode: Image.PreserveAspectFit
                                  visible: true
                                }
                            }
                            }

                            

                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    // Toggle openSsid: click lại sẽ đóng
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
                            color: "#F7EDE2"
                            radius: 8
                            width: parent.width
                            height: visible ? 80 : 0
                            Behavior on height { 
                                NumberAnimation { duration: 150 } 
                            }

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 8
                                spacing: 6

                                Text { 
                                    text: "🔒 " + modelData.ssid; 
                                    font.pixelSize: 13; color: "#444" 
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    TextField {
                                        id: wifiPassword
                                        Layout.fillWidth: true
                                        placeholderText: modelData.security === "Open" ? "No password needed" : "Enter password"
                                        echoMode: TextInput.Password
                                        enabled: modelData.security !== "Open"

                                        onActiveFocusChanged: {
                                            wifiManager.userTyping = activeFocus
                                        }
                                    }
                                    Button {
                                        text: "Connect"
                                        onClicked: {
                                            if (wifiPassword.text.trim().length === 0 && modelData.security !== "Open") {
                                                console.log("⚠️ Password required")
                                                return
                                            }
                                            wifiManager.connectToWifi(modelData.ssid, wifiPassword.text)
                                            // đóng hộp sau khi bấm Connect
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
                    spacing: 12
                    Text { text: "📶"; font.pixelSize: 48 }
                    Text { text: "WiFi is disabled"; font.pixelSize: 16; color: "#666" }
                    Text { text: "Turn on WiFi to see available networks"; font.pixelSize: 12; color: "#999" }
                }
            }
        }
    }
}

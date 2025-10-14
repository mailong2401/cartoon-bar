import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell

PanelWindow {
    id: wifiPanel
    width: 410
    height: 600
    color: "transparent"
    focusable: true
    aboveWindows: true
    objectName: "WiFiPanel"

    // Nhận wifiManager từ bên ngoài
    required property var wifiManager

    Rectangle {
        radius: 20
        anchors.fill: parent
        color: "#F5EEE6"
        border.color: "#D4C4B7"
        border.width: 2

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            // HEADER
            RowLayout {
                Layout.fillWidth: true
                Text { text: "📶 WiFi"; font.pixelSize: 24; font.bold: true; color: "#333" }
                Item { Layout.fillWidth: true }
                Rectangle {
                    width: 40; height: 40; radius: 8
                    color: refreshMouseArea.containsMouse ? "#E8D8C9" : "transparent"
                    Text { text: "🔄"; anchors.centerIn: parent; font.pixelSize: 20 }
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
                Layout.fillWidth: true; height: 60; radius: 12; color: "#E8D8C9"
                RowLayout {
                    anchors.fill: parent; anchors.margins: 12
                    Column {
                        Layout.fillWidth: true
                        Text {
                            text: wifiManager.wifiEnabled ? "WiFi Enabled" : "WiFi Disabled"
                            font.pixelSize: 16; font.bold: true; color: "#333"
                        }
                        Text { 
                            text: wifiManager.connectedWifi; 
                            font.pixelSize: 12; color: "#666"; elide: Text.ElideRight 
                        }
                    }
                    Switch {
                        checked: wifiManager.wifiEnabled
                        onCheckedChanged: if (checked !== wifiManager.wifiEnabled) wifiManager.toggleWifi()
                    }
                }
            }

            // SCANNING
            Rectangle {
                Layout.fillWidth: true; height: 40; visible: wifiManager.isScanning
                Row { 
                    anchors.centerIn: parent; spacing: 8
                    Text { text: "🔍 Scanning..."; font.pixelSize: 14; color: "#666" }
                }
            }

            // WIFI LIST
            Text {
                text: "Available Networks (" + wifiManager.wifiList.length + ")"
                visible: wifiManager.wifiEnabled && !wifiManager.isScanning
                font.pixelSize: 14; color: "#666"
            }

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                visible: wifiManager.wifiEnabled && !wifiManager.isScanning

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
                            height: 60
                            radius: 8
                            color: mouseArea.containsMouse ? "#E8D8C9" : (modelData.isConnected ? "#D4EDDA" : "transparent")
                            border.color: modelData.isConnected ? "#C3E6CB" : "transparent"
                            border.width: 2

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 8
                                Column { 
                                    Layout.fillWidth: true
                                    Text { 
                                        text: modelData.ssid; 
                                        font.pixelSize: 14; font.bold: true; color: "#333" 
                                    }
                                    Text { 
                                        text: modelData.security + " • " + modelData.signal; 
                                        font.pixelSize: 11; color: "#666" 
                                    }
                                }
                                Text { 
                                    text: modelData.isConnected ? "✅" : "🔗"; 
                                    visible: !modelData.isConnected || mouseArea.containsMouse 
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

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: itemRoot
    property string ssid: ""
    property int signal: 0
    property string security: ""
    property bool active: false
    property var wifiManager

    radius: 10
    height: expanded ? 120 : 60
    Layout.fillWidth: true
    color: active ? "#D0E6A5" : (hovered ? "#EDE0D4" : "#FAF3EC")
    border.width: 2
    border.color: active ? "#7B9E4C" : "#CBBBA0"

    property bool hovered: false
    property bool expanded: false
    property string password: ""

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 4

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Image {
                source: {
                    if (signal > 80) return "../../assets/wifi/wifi_4.png"
                    else if (signal > 60) return "../../assets/wifi/wifi_3.png"
                    else if (signal > 40) return "../../assets/wifi/wifi_2.png"
                    else if (signal > 20) return "../../assets/wifi/wifi_1.png"
                    else return "../../assets/wifi/wifi_0.png"
                }
                width: 30; height: 30
                fillMode: Image.PreserveAspectFit
            }

            Column {
                Text {
                    text: ssid
                    font.pixelSize: 18
                    font.bold: true
                    color: "#333"
                }
                Text {
                    text: active ? "Đang kết nối" : (security || "Open")
                    font.pixelSize: 13
                    color: active ? "#2E7D32" : "#666"
                }
            }

            Item { Layout.fillWidth: true }

            Button {
                text: active ? "Đã kết nối" : (expanded ? "Hủy" : "Kết nối")
                enabled: !active
                onClicked: {
                    if (expanded) expanded = false
                    else expanded = true
                }
            }
        }

        // PASSWORD INPUT (nếu mạng cần bảo mật)
        RowLayout {
            visible: expanded && !active && security !== "Open"
            Layout.fillWidth: true
            spacing: 10

            TextField {
                Layout.fillWidth: true
                placeholderText: "Nhập mật khẩu..."
                echoMode: TextInput.Password
                text: password
                onTextChanged: password = text
            }
            Button {
                text: "OK"
                onClicked: {
                    if (wifiManager)
                        wifiManager.connectToWifi(ssid, password)
                    expanded = false
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: hovered = true
        onExited: hovered = false
    }
}


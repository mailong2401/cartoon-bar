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

    // Nhận wifiManager từ bên ngoài
    required property var wifiManager
    property var theme : currentTheme
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

            // HEADER
            RowLayout {
                Layout.fillWidth: true
                spacing: sizes.headerSpacing || 20
                Rectangle {
                    width: sizes.headerIconContainerSize || 70
                    height: sizes.headerIconContainerSize || 70
                    radius: sizes.headerIconContainerRadius || 12
                    color: "transparent"
                    Image {
                        source: "../../assets/system/wifi.png"
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
                        source: '../../assets/wifi/refresh.png'
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
                        onClicked: if (wifiManager.wifiEnabled) wifiManager.scanWifiNetworks()
                    }
                }
            }

            // WIFI STATUS
            Rectangle {
                Layout.fillWidth: true
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
                            text: wifiManager.wifiEnabled ? (lang?.wifi?.enabled || "WiFi đang bật") : (lang?.wifi?.disabled || "WiFi đang tắt")
                            font.pixelSize: sizes.statusTitleFontSize || 20
                            font.bold: true
                            color: wifiManager.wifiEnabled ? theme.normal.blue : theme.normal.red
                            font.family: "ComicShannsMono Nerd Font"
                        }
                        Text {
                            text: wifiManager.connectedWifi || (lang?.wifi?.not_connected || "Chưa kết nối")
                            font.pixelSize: sizes.statusSubtitleFontSize || 14
                            color: theme.primary.dim_foreground
                            elide: Text.ElideRight
                            font.family: "ComicShannsMono Nerd Font"
                        }
                    }
                    Switch {
                        checked: wifiManager.wifiEnabled
                        onCheckedChanged: if (checked !== wifiManager.wifiEnabled) wifiManager.toggleWifi()

                        // Custom switch styling
                        indicator: Rectangle {
                            implicitWidth: sizes.switchWidth || 48
                            implicitHeight: sizes.switchHeight || 26
                            radius: sizes.switchRadius || 13
                            color: parent.checked ? theme.normal.blue : theme.normal.black
                            border.color: parent.checked ? theme.normal.blue : theme.primary.dim_foreground

                            Rectangle {
                                x: parent.checked ? parent.width - width : 0
                                width: sizes.switchIndicatorSize || 26
                                height: sizes.switchIndicatorSize || 26
                                radius: sizes.switchRadius || 13
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
                        leftMargin: sizes.sectionLabelMargin || 10
                    }
                    text: (lang?.wifi?.available_networks || "Mạng có sẵn") + " (" + wifiManager.wifiList.length + ")"
                    visible: wifiManager.wifiEnabled
                    font.pixelSize: sizes.sectionLabelFontSize || 17
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
                            height: sizes.networkItemHeight || 70
                            radius: sizes.networkItemRadius || 12
                            color: mouseArea.containsMouse ?
                                   theme.button.background_select :
                                   (modelData.isConnected ? theme.normal.blue : theme.primary.dim_background)
                            border.width: sizes.borderWidth || 2
                            border.color: modelData.isConnected ? theme.normal.blue : theme.normal.black


                                RowLayout {
                                    anchors.margins: sizes.networkItemMargins || 8
                                    anchors.fill: parent
                                    Column {
                                        Layout.fillWidth: true
                                        Text {
                                            text: modelData.ssid
                                            font.pixelSize: sizes.networkNameFontSize || 18
                                            font.bold: true
                                            color: modelData.isConnected ? theme.normal.black : theme.primary.foreground
                                            font.family: "ComicShannsMono Nerd Font"
                                        }
                                        Text {
                                            text: modelData.security + " • " + modelData.signal
                                            font.pixelSize: sizes.networkInfoFontSize || 13
                                            color: modelData.isConnected ? theme.normal.black : theme.primary.dim_foreground
                                            font.family: "ComicShannsMono Nerd Font"
                                        }
                                    }
                                    Rectangle {
                                        width: sizes.networkIconSize || 40
                                        height: sizes.networkIconSize || 40
                                        radius: sizes.networkIconRadius || 8
                                        color: modelData.isConnected ? theme.normal.black : theme.normal.magenta
                                        Image {
                                            source: modelData.isConnected ?
                                                   "../../assets/wifi/check-mark.png" :
                                                   "../../assets/wifi/padlock.png"
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
                            radius: sizes.passwordBoxRadius || 12
                            width: parent.width
                            height: visible ? (hasError ? 150 : 100) : 0
                            border.width: sizes.borderWidth || 2
                            border.color: theme.normal.blue
                            Behavior on height {
                                NumberAnimation { duration: 200 }
                            }

                            property bool showPassword: false
                            property bool hasError: false
                            property string errorMessage: ""

                            // Kiểm tra xem có mật khẩu đã lưu không - dựa vào isConnected
                            property bool hasSavedPassword: modelData.isConnected

                            Component.onCompleted: {
                                // Lấy mật khẩu từ NetworkManager khi mở passwordBox
                                if (visible && modelData.isConnected) {
                                    wifiManager.getSavedPassword(modelData.ssid)
                                }
                            }

                            onVisibleChanged: {
                                if (visible && modelData.isConnected) {
                                    wifiManager.getSavedPassword(modelData.ssid)
                                }
                            }

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: sizes.passwordBoxMargins || 12
                                spacing: sizes.passwordBoxSpacing || 8

                                Text {
                                    text: "🔒 " + modelData.ssid
                                    font.pixelSize: sizes.passwordLabelFontSize || 14
                                    color: theme.primary.foreground
                                    font.family: "ComicShannsMono Nerd Font"
                                }

                                // Thông báo lỗi
                                Rectangle {
                                    Layout.fillWidth: true
                                    height: 30
                                    visible: passwordBox.hasError
                                    color: theme.normal.red
                                    radius: 6
                                    Text {
                                        anchors.centerIn: parent
                                        text: "❌ " + passwordBox.errorMessage
                                        color: theme.primary.foreground
                                        font.pixelSize: 12
                                        font.family: "ComicShannsMono Nerd Font"
                                    }
                                }

                                // Hiển thị mật khẩu đã lưu (khi đã kết nối)
                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 8
                                    visible: passwordBox.hasSavedPassword

                                    Rectangle {
                                        Layout.fillWidth: true
                                        height: 40
                                        color: theme.primary.background
                                        radius: sizes.passwordInputRadius || 8
                                        border.color: theme.normal.blue
                                        border.width: 1

                                        Text {
                                            anchors.centerIn: parent
                                            text: passwordBox.showPassword ? wifiManager.currentPassword : "••••••••"
                                            font.family: "ComicShannsMono Nerd Font"
                                            color: theme.primary.foreground
                                            font.pixelSize: 14
                                        }
                                    }

                                    // Nút toggle hiện/ẩn mật khẩu
                                    Button {
                                        width: 40
                                        height: 40
                                        font.family: "ComicShannsMono Nerd Font"
                                        background: Rectangle {
                                            color: parent.down ? theme.button.background_select :
                                                   parent.hovered ? theme.button.background_select : theme.button.background
                                            radius: sizes.passwordButtonRadius || 8
                                        }
                                        contentItem: Text {
                                            text: passwordBox.showPassword ? "👁️" : "🙈"
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            font.pixelSize: 18
                                        }

                                        onClicked: {
                                            passwordBox.showPassword = !passwordBox.showPassword
                                        }
                                    }

                                    // Nút quên/xóa mật khẩu
                                    Button {
                                        text: lang?.wifi?.forget || "Quên"
                                        font.family: "ComicShannsMono Nerd Font"
                                        background: Rectangle {
                                            color: parent.down ? theme.normal.red :
                                                   parent.hovered ? Qt.lighter(theme.normal.red, 1.2) : theme.normal.red
                                            radius: sizes.passwordButtonRadius || 8
                                        }
                                        contentItem: Text {
                                            text: parent.text
                                            color: theme.primary.foreground
                                            font: parent.font
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                        }

                                        onClicked: {
                                            wifiManager.forgetPassword(modelData.ssid)
                                            passwordBox.hasSavedPassword = false
                                            wifiManager.openSsid = ""
                                        }
                                    }
                                }

                                // Form nhập mật khẩu (khi chưa có mật khẩu đã lưu)
                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 8
                                    visible: !passwordBox.hasSavedPassword

                                    TextField {
                                        id: wifiPassword
                                        Layout.fillWidth: true
                                        placeholderText: modelData.security === "Open" ? (lang?.wifi?.no_password || "Không cần mật khẩu") : (lang?.wifi?.enter_password || "Nhập mật khẩu")
                                        echoMode: passwordBox.showPassword ? TextInput.Normal : TextInput.Password
                                        enabled: modelData.security !== "Open"
                                        font.family: "ComicShannsMono Nerd Font"
                                        color: theme.primary.foreground
                                        background: Rectangle {
                                            color: theme.primary.background
                                            radius: sizes.passwordInputRadius || 8
                                            border.color: theme.normal.blue
                                            border.width: 1
                                        }

                                        onActiveFocusChanged: {
                                            wifiManager.userTyping = activeFocus
                                        }
                                    }

                                    // Nút toggle hiện/ẩn mật khẩu
                                    Button {
                                        width: 40
                                        height: 40
                                        visible: modelData.security !== "Open"
                                        font.family: "ComicShannsMono Nerd Font"
                                        background: Rectangle {
                                            color: parent.down ? theme.button.background_select :
                                                   parent.hovered ? theme.button.background_select : theme.button.background
                                            radius: sizes.passwordButtonRadius || 8
                                        }
                                        contentItem: Text {
                                            text: passwordBox.showPassword ? "👁️" : "🙈"
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            font.pixelSize: 18
                                        }

                                        onClicked: {
                                            passwordBox.showPassword = !passwordBox.showPassword
                                        }
                                    }

                                    Button {
                                        text: lang?.wifi?.connect || "Kết nối"
                                        font.family: "ComicShannsMono Nerd Font"
                                        background: Rectangle {
                                            color: parent.down ? theme.normal.blue :
                                                   parent.hovered ? theme.bright.blue : theme.normal.blue
                                            radius: sizes.passwordButtonRadius || 8
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
                                                passwordBox.hasError = true
                                                passwordBox.errorMessage = lang?.wifi?.password_required || "Vui lòng nhập mật khẩu"
                                                return
                                            }

                                            // Reset lỗi trước khi kết nối
                                            passwordBox.hasError = false
                                            passwordBox.errorMessage = ""

                                            wifiManager.connectToWifi(modelData.ssid, wifiPassword.text)

                                            // Kiểm tra lỗi kết nối
                                            Qt.callLater(function() {
                                                if (wifiManager.connectionError) {
                                                    passwordBox.hasError = true
                                                    passwordBox.errorMessage = lang?.wifi?.wrong_password || "Mật khẩu không đúng"
                                                } else {
                                                    passwordBox.hasSavedPassword = true
                                                    wifiManager.openSsid = ""
                                                }
                                            })

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
                        width: sizes.emptyStateIconSize || 80
                        height: sizes.emptyStateIconSize || 80
                        radius: sizes.emptyStateIconRadius || 16
                        color: theme.normal.red
                        anchors.horizontalCenter: parent.horizontalCenter
                        Text {
                            text: "📶"
                            font.pixelSize: 40
                            anchors.centerIn: parent
                        }
                    }
                    Text {
                        text: lang?.wifi?.disabled || "WiFi đang tắt"
                        font.pixelSize: sizes.emptyStateTitleFontSize || 18
                        color: theme.primary.foreground
                        font.family: "ComicShannsMono Nerd Font"
                    }
                    Text {
                        text: lang?.wifi?.turn_on || "Bật WiFi để xem mạng khả dụng"
                        font.pixelSize: sizes.emptyStateSubtitleFontSize || 14
                        color: theme.primary.dim_foreground
                        font.family: "ComicShannsMono Nerd Font"
                    }
                }
            }
        }
    }
}

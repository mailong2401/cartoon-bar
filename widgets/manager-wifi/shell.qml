import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

ShellRoot {
    id: root
    property string hyprInstance: Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE") || ""
    property var wifiList: []
    property bool wifiEnabled: false
    property string connectedWifi: "Not connected"
    property bool isScanning: false

    // =============================
    //   WIFI PROCESS HANDLERS
    // =============================
    Process {
        id: wifiToggleProcess
        onRunningChanged: if (!running) {
            checkWifiStatus()
            if (wifiEnabled) scanWifiNetworks()
        }
    }

    Process {
        id: wifiStatusProcess
        command: ["nmcli", "radio", "wifi"]
        stdout: StdioCollector {
            onStreamFinished: {
                if (this.text) {
                    root.wifiEnabled = (this.text.trim() === "enabled")
                    console.log("📶 WiFi status:", this.text.trim())
                }
            }
        }
    }

    Process {
        id: wifiScanProcess
        command: ["nmcli", "-f", "SSID,SIGNAL,SECURITY", "device", "wifi", "list"]
        stdout: StdioCollector {
            onStreamFinished: {
                if (this.text) {
                    parseWifiList(this.text)
                    root.isScanning = false
                }
            }
        }
    }

    Process {
        id: wifiConnectProcess
        onRunningChanged: if (!running) {
            console.log("✅ WiFi connect process finished")
            checkConnectedWifi()
        }
    }

    Process {
        id: connectedWifiProcess
        command: ["nmcli", "-t", "-f", "NAME", "connection", "show", "--active"]
        stdout: StdioCollector {
            onStreamFinished: {
                if (this.text) {
                    const lines = this.text.trim().split('\n')
                    for (var i = 0; i < lines.length; i++) {
                        var conn = lines[i]
                        if (conn && conn !== "lo" && !conn.startsWith("Wired")) {
                            root.connectedWifi = conn
                            return
                        }
                    }
                    root.connectedWifi = "Not connected"
                }
            }
        }
    }

    // =============================
    //   WIFI FUNCTIONS
    // =============================
    function checkWifiStatus() {
        if (!wifiStatusProcess.running) wifiStatusProcess.running = true
    }

    function scanWifiNetworks() {
        if (root.wifiEnabled && !wifiScanProcess.running) {
            root.isScanning = true
            wifiScanProcess.running = true
        }
    }

    function toggleWifi() {
        var cmd = root.wifiEnabled ? "off" : "on"
        wifiToggleProcess.command = ["nmcli", "radio", "wifi", cmd]
        wifiToggleProcess.running = true
    }

    function connectToWifi(ssid, password) {
        console.log("🔗 Connecting to:", ssid)
        if (password)
            wifiConnectProcess.command = ["nmcli", "device", "wifi", "connect", ssid, "password", password]
        else
            wifiConnectProcess.command = ["nmcli", "device", "wifi", "connect", ssid]
        wifiConnectProcess.running = true
    }

    function disconnectWifi() {
        wifiConnectProcess.command = ["nmcli", "device", "disconnect"]
        wifiConnectProcess.running = true
        root.connectedWifi = "Not connected"
    }

    function checkConnectedWifi() {
        if (!connectedWifiProcess.running) connectedWifiProcess.running = true
    }

    function parseWifiList(text) {
        var lines = text.trim().split('\n')
        var networksMap = {}

        for (var i = 1; i < lines.length; i++) {
            var line = lines[i].trim()
            if (line && line !== "--") {
                var parts = line.split(/\s{2,}/)
                if (parts.length >= 2) {
                    var ssid = parts[0].trim()
                    var signal = parseInt(parts[1].trim()) || 0
                    var security = parts.length >= 3 ? parts[2].trim() : "Open"
                    if (ssid && ssid !== "--" && ssid !== "SSID") {
                        if (!networksMap[ssid] || signal > networksMap[ssid].signal) {
                            networksMap[ssid] = {
                                ssid: ssid,
                                signal: signal,
                                security: security,
                                isConnected: ssid === root.connectedWifi
                            }
                        }
                    }
                }
            }
        }

        var networks = Object.values(networksMap).sort((a, b) => b.signal - a.signal)
        root.wifiList = networks
        console.log("📡 Found", networks.length, "WiFi networks")
    }

    // =============================
    //   AUTO REFRESH
    // =============================
    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: {
            checkWifiStatus()
            checkConnectedWifi()
            if (root.wifiEnabled) scanWifiNetworks()
        }
    }

    // =============================
    //   PANEL WINDOW
    // =============================
    ApplicationWindow {
        id: appWin
        visible: true
        width: 410
        height: 600
        title: "WiFi Manager"
        color: "transparent"
        flags: Qt.Window | Qt.WindowStaysOnTopHint | Qt.WindowCloseButtonHint

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
                            onClicked: if (root.wifiEnabled) scanWifiNetworks()
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
                                text: root.wifiEnabled ? "WiFi Enabled" : "WiFi Disabled"
                                font.pixelSize: 16; font.bold: true; color: "#333"
                            }
                            Text { text: root.connectedWifi; font.pixelSize: 12; color: "#666"; elide: Text.ElideRight }
                        }
                        Switch {
                            checked: root.wifiEnabled
                            onCheckedChanged: if (checked !== root.wifiEnabled) toggleWifi()
                        }
                    }
                }

                // SCANNING
                Rectangle {
                    Layout.fillWidth: true; height: 40; visible: root.isScanning
                    Row { anchors.centerIn: parent; spacing: 8
                        Text { text: "🔍 Scanning..."; font.pixelSize: 14; color: "#666" }
                    }
                }

                // WIFI LIST
                Text {
                    text: "Available Networks (" + root.wifiList.length + ")"
                    visible: root.wifiEnabled && !root.isScanning
                    font.pixelSize: 14; color: "#666"
                }

                ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: root.wifiEnabled && !root.isScanning

                    ListView {
                        id: wifiListView
                        model: root.wifiList
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
                                    Column { Layout.fillWidth: true
                                        Text { text: modelData.ssid; font.pixelSize: 14; font.bold: true; color: "#333" }
                                        Text { text: modelData.security + " • " + modelData.signal; font.pixelSize: 11; color: "#666" }
                                    }
                                    Text { text: modelData.isConnected ? "✅" : "🔗"; visible: !modelData.isConnected || mouseArea.containsMouse }
                                }

                                MouseArea {
                                    id: mouseArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        // Ẩn ô nhập của các item khác
                                        for (let i = 0; i < wifiListView.count; i++) {
                                            let item = wifiListView.itemAtIndex(i)
                                            if (item && item.passwordBox && item.passwordBox !== passwordBox)
                                                item.passwordBox.visible = false
                                        }

                                        // Toggle hiển thị hộp mật khẩu
                                        passwordBox.visible = !passwordBox.visible
                                        passwordBox.currentSsid = modelData.ssid
                                        passwordBox.currentSecurity = modelData.security
                                    }
                                }
                            }

                            Rectangle {
                                id: passwordBox
                                property string currentSsid: ""
                                property string currentSecurity: ""
                                visible: false
                                color: "#F7EDE2"
                                radius: 8
                                width: parent.width
                                height: visible ? 80 : 0
                                Behavior on height { NumberAnimation { duration: 150 } }

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 8
                                    spacing: 6

                                    Text { text: "🔒 " + currentSsid; font.pixelSize: 13; color: "#444" }

                                    RowLayout {
                                        Layout.fillWidth: true
                                        TextField {
                                            id: wifiPassword
                                            Layout.fillWidth: true
                                            placeholderText: "Enter password"
                                            echoMode: TextInput.Password
                                        }
                                        Button {
                                            text: "Connect"
                                            onClicked: {
                                                if (wifiPassword.text.trim().length === 0 && currentSecurity !== "Open") {
                                                    console.log("⚠️ Password required")
                                                    return
                                                }
                                                root.connectToWifi(currentSsid, wifiPassword.text)
                                                passwordBox.visible = false
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
                    visible: !root.wifiEnabled
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

    Component.onCompleted: {
        console.log("📶 WiFi Widget Started")
        checkWifiStatus()
        checkConnectedWifi()
        if (root.wifiEnabled) scanWifiNetworks()
    }
}


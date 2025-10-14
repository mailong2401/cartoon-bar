import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: wifiManager
    
    property string hyprInstance: Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE") || ""
    property var wifiList: []
    property bool wifiEnabled: false
    property string connectedWifi: "Not connected"
    property bool isScanning: false
    property string openSsid: ""     // SSID đang mở hộp mật khẩu
    property bool userTyping: false  // true khi đang nhập password
    property bool enabled: false

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
                    wifiManager.wifiEnabled = (this.text.trim() === "enabled")
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
                    wifiManager.isScanning = false
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
                            wifiManager.connectedWifi = conn
                            return
                        }
                    }
                    wifiManager.connectedWifi = "Not connected"
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
        if (wifiManager.wifiEnabled && !wifiScanProcess.running) {
            wifiManager.isScanning = true
            wifiScanProcess.running = true
        }
    }

    function toggleWifi() {
        var cmd = wifiManager.wifiEnabled ? "off" : "on"
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
        wifiManager.connectedWifi = "Not connected"
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
                                isConnected: ssid === wifiManager.connectedWifi
                            }
                        }
                    }
                }
            }
        }

        var networks = Object.values(networksMap).sort((a, b) => b.signal - a.signal)
        wifiManager.wifiList = networks
        console.log("📡 Found", networks.length, "WiFi networks")
    }

    // =============================
    //   AUTO REFRESH
    // =============================
    Timer {
        interval: 10000
        running: wifiManager.enabled
        repeat: true
        onTriggered: {
            // Nếu user đang nhập password thì tạm hoãn scan
            if (wifiManager.userTyping) {
                console.log("🔕 Skipping scan because user is typing for", wifiManager.openSsid)
                return
            }
            checkWifiStatus()
            checkConnectedWifi()
            if (wifiManager.wifiEnabled) scanWifiNetworks()
        }
    }

      // Hàm khởi động manager
    function start() {
        console.log("🚀 Starting WiFi Manager")
        enabled = true
        checkWifiStatus()
        checkConnectedWifi()
        if (wifiManager.wifiEnabled) scanWifiNetworks()
    }

    // Hàm dừng manager
    function stop() {
        console.log("🛑 Stopping WiFi Manager")
        enabled = false
        
        // Dừng tất cả processes đang chạy
        wifiStatusProcess.running = false
        wifiScanProcess.running = false
        wifiConnectProcess.running = false
        connectedWifiProcess.running = false
        wifiToggleProcess.running = false
        
        // Reset scanning state
        isScanning = false
        userTyping = false
        openSsid = ""
    }
}

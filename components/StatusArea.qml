import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "./WifiPanel/" as ComponentWifi

Rectangle {
    id: root
    border.color: "#4f4f5b"
    border.width: 3
    radius: 10
    color: "#F5EEE6"

    property string net_stat: "Checking..."
    property string wifi_icon: "../assets/wifi/wifi_4.png"
    property string status_battery: "Unknown"
    property string capacity_battery: "..."
    property int signal_current: 0
    property string volumeCurrent: "..."
    
    // Global state để toggle panel
    property bool wifiPanelVisible: false
    
    // WifiManager component - chứa tất cả logic WiFi
    ComponentWifi.WifiManager {
        id: wifiManager
    }
    
    // WiFi Panel - chỉ hiện khi được toggle
    ComponentWifi.WifiPanel {
        id: wifiPanel
        wifiManager: wifiManager
        visible: root.wifiPanelVisible
        
        anchors {
            top: true
            right: true
        }
        margins {
            top: 10
            right: 10
        }
    }

    // =============================
    //   PROCESSES
    // =============================
    
    Process {
        id: wifiProcess
        command: ["scripts/check-network", "--stat"]
        running: false
        stdout: StdioCollector { }
        onRunningChanged: {
            if (!running && stdout.text) {
                var result = stdout.text.trim()
                root.net_stat = result
                updateWifiIcon()
            }
        }
    }

    Process {
        id: wifiSignalProcess
        command: ["bash", "-c", "nmcli -t -f ACTIVE,SIGNAL dev wifi | grep '^yes' | cut -d: -f2"]
        stdout: StdioCollector { }
        running: false
        onRunningChanged: {
            if (!running && stdout.text) {
                var resultText = stdout.text.trim()
                if (resultText) {
                    var result = parseInt(resultText)
                    if (!isNaN(result)) {
                        root.signal_current = result
                        updateWifiIcon()
                    } else {
                        console.log("⚠️ Invalid signal value:", resultText)
                        root.signal_current = 0
                    }
                } else {
                    root.signal_current = 0
                    updateWifiIcon()
                }
            }
        }
    }

    Process {
        id: batteryCapacityProcess
        command: ["cat", "/sys/class/power_supply/BAT0/capacity"]
        running: false
        stdout: StdioCollector { }
        onRunningChanged: {
            if (!running && stdout.text) {
                var result = stdout.text.trim()
                root.capacity_battery = result
                updateBatteryIcon()
            }
        }
    }

    Process {
        id: batteryStatusProcess
        command: ["cat", "/sys/class/power_supply/BAT0/status"]
        running: false
        stdout: StdioCollector { }
        onRunningChanged: {
            if (!running && stdout.text) {
                var result = stdout.text.trim()
                root.status_battery = result
                updateBatteryIcon()
            }
        }
    }

    Process {
        id: volumeCurrentProcess
        command: ["bash", "-c", "pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\\d+%' | head -1"]
        running: false
        stdout: StdioCollector { }
        onRunningChanged: {
            if (!running && stdout.text) {
                var result = stdout.text.trim()
                root.volumeCurrent = result
                updateVolumeIcon()
            }
        }
    }

    // =============================
    //   FUNCTIONS
    // =============================
    
    function updateBatteryCappacityProcess() {
        if (!batteryCapacityProcess.running) {
            batteryCapacityProcess.running = true
        }
    }

    function updateSignalWifiProcess() {
        if (!wifiSignalProcess.running) {
            wifiSignalProcess.running = true
        }
    }

    function updateVolumeCurrentProcess() {
        if (!volumeCurrentProcess.running) {
            volumeCurrentProcess.running = true
        }
    }

    function updateWifi() {
        if (!wifiProcess.running) {
            wifiProcess.running = true
        }
    }

    function updateWifiIcon() {
        if (root.net_stat === "Offline") {
            wifi_icon = "../assets/wifi/no_wifi.png"
        } else if (root.net_stat === "Online") {
            wifi_icon = "../assets/wifi/wifi_4.png"
        } else {
            var signal = root.signal_current || 0
            if (signal <= 25) {
                wifi_icon = "../assets/wifi/wifi_1.png"
            } else if (signal <= 50) {
                wifi_icon = "../assets/wifi/wifi_2.png"
            } else if (signal <= 75) {
                wifi_icon = "../assets/wifi/wifi_3.png"
            } else {
                wifi_icon = "../assets/wifi/wifi_4.png"
            }
        }
    }

    function updateBatteryIcon() {
        var capacity = parseInt(root.capacity_battery) || 0
        var status = root.status_battery
        
        if (status === "Charging") {
            batteryIcon.source = '../assets/battery/battery-1.png'
        } else if (capacity <= 20) {
            batteryIcon.source = '../assets/battery/battery-2.png'
        } else if (capacity <= 50) {
            batteryIcon.source = '../assets/battery/battery-2.png'
        } else if (capacity <= 80) {
            batteryIcon.source = '../assets/battery/battery-3.png'
        } else {
            batteryIcon.source = '../assets/battery/full.png'
        }
    }

    function updateVolumeIcon() {
        var volume = parseInt(root.volumeCurrent) || 0
        if (volume === 0) {
            volumeIcon.source = '../assets/volume/mute.png'
            console.log("tat mic")
        } else if (volume <= 30) {
            volumeIcon.source = '../assets/volume/volume.png'
        } else if (volume <= 70) {
            volumeIcon.source = '../assets/volume/volume.png'
        } else {
            volumeIcon.source = '../assets/volume/volume.png'
        }
    }

    // Xử lý khi panel được mở/đóng
    onWifiPanelVisibleChanged: {
        if (wifiPanelVisible) {
            console.log("📱 WiFi Panel opened - Starting manager")
            wifiManager.start()
        } else {
            console.log("📱 WiFi Panel closed - Stopping manager") 
            wifiManager.stop()
        }
    }

    // =============================
    //   UI LAYOUT
    // =============================
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: 0

        // Network Status
        Rectangle {
            id: networkContainer
            Layout.preferredWidth: networkContent.width + 20
            Layout.preferredHeight: networkContent.height + 10
            color: "transparent"
            radius: 6

            RowLayout {
                id: networkContent
                anchors.centerIn: parent
                spacing: 8

                Image {
                    id: wifiImage
                    source: root.wifi_icon
                    width: 42
                    height: 42
                    sourceSize: Qt.size(42, 42)
                }
                
                Text {
                    text: root.net_stat
                    color: "#000"
                    font { 
                        pixelSize: 16
                        bold: true 
                    }
                    verticalAlignment: Text.AlignVCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                
                onEntered: networkContainer.scale = 1.1
                onExited: networkContainer.scale = 1.0
                onPressed: networkContainer.scale = 0.95
                onReleased: networkContainer.scale = 1.1
                
                onClicked: root.wifiPanelVisible = !root.wifiPanelVisible
            }
            
            Behavior on scale { NumberAnimation { duration: 100 } }
        }

        Item { Layout.fillWidth: true }

        // Volume
        Rectangle {
            id: volumeContainer
            Layout.preferredWidth: volumeContent.width + 20
            Layout.preferredHeight: volumeContent.height + 10
            color: "transparent"
            radius: 6

            RowLayout {
                id: volumeContent
                anchors.centerIn: parent
                spacing: 8

                Image {
                    id: volumeIcon
                    source: '../assets/volume/volume-medium.png'
                    width: 40
                    height: 40
                    sourceSize: Qt.size(40, 40)
                }
                Text {
                    text: root.volumeCurrent
                    color: "#000"
                    font { 
                        pixelSize: 16
                        bold: true 
                    }
                    verticalAlignment: Text.AlignVCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                
                onEntered: volumeContainer.scale = 1.1
                onExited: volumeContainer.scale = 1.0
                onPressed: volumeContainer.scale = 0.95
                onReleased: volumeContainer.scale = 1.1
                
                onClicked: {
                    Qt.createQmlObject('import Quickshell; Process { command: ["pavucontrol"]; running: true }', root)
                }
                
                onWheel: {
                    var delta = wheel.angleDelta.y / 120
                    if (delta > 0) {
                        Qt.createQmlObject('import Quickshell; Process { command: ["pactl", "set-sink-volume", "@DEFAULT_SINK@", "+5%"]; running: true }', root)
                    } else {
                        Qt.createQmlObject('import Quickshell; Process { command: ["pactl", "set-sink-volume", "@DEFAULT_SINK@", "-5%"]; running: true }', root)
                    }
                    updateVolumeCurrentProcess()
                }
            }
            
            Behavior on scale { NumberAnimation { duration: 100 } }
        }

        Item { Layout.fillWidth: true }

        // Battery
        Rectangle {
            id: batteryContainer
            Layout.preferredWidth: batteryContent.width + 20
            Layout.preferredHeight: batteryContent.height + 10
            color: "transparent"
            radius: 6

            RowLayout {
                id: batteryContent
                anchors.centerIn: parent
                spacing: 8

                Image {
                    id: batteryIcon
                    source: '../assets/battery/full.png'
                    width: 30
                    height: 30
                    sourceSize: Qt.size(30, 30)
                }
                Text {
                    text: root.capacity_battery + "%"
                    color: "#000"
                    font { 
                        pixelSize: 16
                        bold: true 
                    }
                    verticalAlignment: Text.AlignVCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                
                onEntered: batteryContainer.scale = 1.1
                onExited: batteryContainer.scale = 1.0
                onPressed: batteryContainer.scale = 0.95
                onReleased: batteryContainer.scale = 1.1
                
                onClicked: {
                    Qt.createQmlObject('import Quickshell; Process { command: ["gnome-power-statistics"]; running: true }', root)
                }
            }
            
            Behavior on scale { NumberAnimation { duration: 100 } }
        }

        Item { Layout.fillWidth: true }

        // Power Off
        Rectangle {
            id: powerContainer
            Layout.preferredWidth: 40
            Layout.preferredHeight: 40
            color: "transparent"
            radius: 6

            Image {
                id: powerIcon
                source: '../assets/system/poweroff.png'
                width: 30
                height: 30
                sourceSize: Qt.size(30, 30)
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                
                onEntered: powerContainer.scale = 1.2
                onExited: powerContainer.scale = 1.0
                onPressed: powerContainer.scale = 0.9
                onReleased: powerContainer.scale = 1.2
                
                onClicked: {
                    Qt.createQmlObject('import Quickshell; Process { command: ["gnome-session-quit", "--power-off"]; running: true }', root)
                }
            }
            
            Behavior on scale { NumberAnimation { duration: 100 } }
        }
    }

    // =============================
    //   INITIALIZATION & TIMERS
    // =============================
    
    Component.onCompleted: {
        console.log("🚀 Panel initialized")
        
        // Khởi chạy ban đầu
        updateWifi()
        updateSignalWifiProcess()
        updateBatteryCappacityProcess()
        updateVolumeCurrentProcess()
        
        // Chạy battery status ngay lập tức
        if (!batteryStatusProcess.running) {
            batteryStatusProcess.running = true
        }
    }

    // Timers
    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: updateWifi()
    }
    
    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: updateSignalWifiProcess()
    }

    Timer {
        interval: 30000
        running: true
        repeat: true
        onTriggered: updateBatteryCappacityProcess()
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: {
            if (!batteryStatusProcess.running) {
                batteryStatusProcess.running = true
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: updateVolumeCurrentProcess()
    }
}

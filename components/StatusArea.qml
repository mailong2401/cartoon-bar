import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Rectangle {
    id: root
    border.color: "#4f4f5b"
    border.width: 3
    radius: 10
    color: "#F5EEE6"

    property string net_stat: "Checking..."
    property string wifi_icon: "../assets/wifi/wifi-0.png"
    property string status_battery: "1"
    property string capacity_battery: "check..."
    property string volumeCurrent: ""

    Process {
        id: wifiProcess
        command: ["/home/long/quickshell-examples/focus_following_panel/scripts/check-network", "--stat"]
        running: false
        stdout: StdioCollector { }
        onRunningChanged: {
            if (!running && stdout.text) {
                var result = stdout.text.trim()
                root.net_stat = result
                updateWifiIcon(result)
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
                updateWifiIcon(result)
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
            }
        }
    }

    Process {
        id: volumeMonitorProcess
        command: ["bash", "-c", "pactl subscribe | grep --line-buffered 'sink'"]
        running: false
        stdout: StdioCollector {}
        onRunningChanged: {
            if (!running) {
                console.log(stdout.text)
                running = true
            }
        }
    }

    function updateBatteryCappacityProcess() {
        if (!batteryCapacityProcess.running) {
            batteryCapacityProcess.running = true
        }
    }

    function updateVolumeCurrentProcess() {
        if (!volumeCurrentProcess.running) {
            volumeCurrentProcess.running = true
        }
    }

    function updateWifiIcon(status) {
        if (status === "Offline") {
            wifi_icon = "../assets/no-wifi.png"
        } else if (status === "Online") {
            wifi_icon = "../assets/wifi.png"
        } else {
            wifi_icon = "../assets/wifi.png"
        }
    }

    function updateWifi() {
        console.log("Updating wifi status...")
        if (!wifiProcess.running) {
            wifiProcess.running = true
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 5

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
                    width: 30
                    height: 30
                    sourceSize: Qt.size(24, 24)
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
                
                // Hiệu ứng hover
                onEntered: {
                    networkContainer.scale = 1.1
                }
                onExited: {
                    networkContainer.scale = 1.0
                    updateWifiIcon(root.net_stat) // Trở về icon ban đầu
                }
                
                // Hiệu ứng click
                onPressed: networkContainer.scale = 0.95
                onReleased: networkContainer.scale = 1.1
                
                onClicked: {
                    console.log("📡 Network clicked - Opening network manager")
                }
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
                    source: '../assets/volume/volume.png'
                    width: 30
                    height: 30
                    sourceSize: Qt.size(30, 30)
                }
                Text {
                    text: volumeCurrent 
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
                
                // Hiệu ứng hover
                onEntered: {
                    volumeContainer.scale = 1.1
                }
                onExited: {
                    volumeContainer.scale = 1.0
                }
                
                // Hiệu ứng click
                onPressed: volumeContainer.scale = 0.95
                onReleased: volumeContainer.scale = 1.1
                
                onClicked: {
                    console.log("🔊 Volume clicked - Opening volume control")
                    // Có thể mở pavucontrol hoặc volume control
                    Qt.createQmlObject('import Quickshell; Process { command: ["pavucontrol"]; running: true }', root)
                }
                
                // Scroll để điều chỉnh volume
                onWheel: {
                    var delta = wheel.angleDelta.y / 120
                    if (delta > 0) {
                        // Tăng volume
                        Qt.createQmlObject('import Quickshell; Process { command: ["pactl", "set-sink-volume", "@DEFAULT_SINK@", "+5%"]; running: true }', root)
                    } else {
                        // Giảm volume
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
                    source: '../assets/battery/battery-1.png'
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
                
                // Hiệu ứng hover
                onEntered: {
                    batteryContainer.scale = 1.1
                }
                onExited: {
                    batteryContainer.scale = 1.0
                }
                
                // Hiệu ứng click
                onPressed: batteryContainer.scale = 0.95
                onReleased: batteryContainer.scale = 1.1
                
                onClicked: {
                    console.log("🔋 Battery clicked - Opening power statistics")
                    // Mở công cụ xem thông tin pin
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
                
                // Hiệu ứng hover
                onEntered: {
                    powerContainer.scale = 1.2
                }
                onExited: {
                    powerContainer.scale = 1.0
                    powerIcon.source = './assets/system/poweroff.png'
                }
                
                // Hiệu ứng click
                onPressed: powerContainer.scale = 0.9
                onReleased: powerContainer.scale = 1.2
                
                onClicked: {
                    // Mở menu tắt máy
                    Qt.createQmlObject('import Quickshell; Process { command: ["gnome-session-quit", "--power-off"]; running: true }', root)
                }
            }
            
            Behavior on scale { NumberAnimation { duration: 100 } }
        }
    }

    Component.onCompleted: {
        updateWifi()
        updateBatteryCappacityProcess()
        updateVolumeCurrentProcess()
        if (!volumeCurrentProcess.running) {
            volumeCurrentProcess.running = true
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: updateWifi()
    }

    Timer {
        interval: 20000
        running: true
        repeat: true
        onTriggered: updateBatteryCappacityProcess()
    }

    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: updateVolumeCurrentProcess()
    }
}

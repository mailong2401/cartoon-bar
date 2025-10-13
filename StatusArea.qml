import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Rectangle {
    id: root
    radius: 8
    color: "#F5EEE6"

    property string net_stat: "Checking..."
    property string wifi_icon: "./assets/wifi/wifi-0.png"
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
            console.log("Network status result:", result)
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
            console.log("Network status result:", result)
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
            // khi kết thúc, đọc stdout
            console.log(stdout.text)
            running = true  // chạy lại để tiếp tục theo dõi
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
            wifi_icon = "./assets/no-wifi.png"
        } else if (status === "Online") {
            wifi_icon = "./assets/wifi.png"
        } else {
            wifi_icon = "./assets/wifi.png"
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
        anchors.margins: 8
        spacing: 12

        // Network Status
        Row {
            spacing: 8
            Layout.alignment: Qt.AlignVCenter
            
            Image {
                id: wifiImage
                source: root.wifi_icon
                width: 24
                height: 24
                sourceSize: Qt.size(24, 24)
            }
            
            Text {
                text: root.net_stat
                color: "#000"
                font { 
                    pixelSize: 14
                    bold: true 
                }
                verticalAlignment: Text.AlignVCenter
            }
        }



        // Volume
        Row {
            spacing: 8
            Layout.alignment: Qt.AlignVCenter
            Image {
                id: volumeIcon
                source: './assets/volume/volume.png'
                width: 24
                height: 24
                sourceSize: Qt.size(24, 24)
            }
            Text {
                text:volumeCurrent 
                color: "#000"
                font { 
                    pixelSize: 14
                    bold: true 
                }
                verticalAlignment: Text.AlignVCenter
            }
        }

        Row {
            spacing: 8
            Layout.alignment: Qt.AlignVCenter
            Image {
                id: batteryIcon
                source: './assets/battery/battery-1.png'
                width: 24
                height: 24
                sourceSize: Qt.size(24, 24)
            }
            Text {
                text: root.capacity_battery
                color: "#000"
                font { 
                    pixelSize: 14
                    bold: true 
                }
                verticalAlignment: Text.AlignVCenter
            }
        }



        // Spacer
        Item { Layout.fillWidth: true }
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
        interval: 5000 // Cập nhật mỗi 5 giây (giảm tần suất)
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

    // Xử lý lỗi
    onNet_statChanged: {
        console.log("Network status changed to:", net_stat)
    }
}

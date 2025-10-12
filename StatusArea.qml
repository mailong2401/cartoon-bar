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
        Image {
            source: "./assets/volume/volume.png"
            width: 24
            height: 24
            sourceSize: Qt.size(24, 24)
            Layout.alignment: Qt.AlignVCenter
        }

        // Battery
        Image {
            source: "./assets/battery/battery-1.png"
            width: 24
            height: 24
            sourceSize: Qt.size(24, 24)
            Layout.alignment: Qt.AlignVCenter
        }



        // Spacer
        Item { Layout.fillWidth: true }
    }

    Component.onCompleted: {
        console.log("Component completed, initializing network check...")
        updateWifi()
    }

    Timer {
        interval: 5000 // Cập nhật mỗi 5 giây (giảm tần suất)
        running: true
        repeat: true
        onTriggered: updateWifi
    }

    // Xử lý lỗi
    onNet_statChanged: {
        console.log("Network status changed to:", net_stat)
    }
}

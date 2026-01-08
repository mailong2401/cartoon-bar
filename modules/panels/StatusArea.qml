import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import "./WifiPanel/" as ComponentWifi
import "./Bluetooth/" as ComponentBluetooth

Rectangle {
    id: root
    border.color: theme.normal.black
    border.width: 3
    radius: 10
    color: theme.primary.background

    property string net_stat: "Checking..."
    property string wifi_icon: "../../assets/system/wifi.png"
    property string bluetooth_icon: "../../assets/settings/bluetooth.png"
    property string status_battery: "Unknown"
    property string capacity_battery: "..."
    property int signal_current: 0
    property bool shouldShowOsd: false
    property bool visibleMixerPanel: false
    property bool visibleBatteryPanel: false
    property bool wifiPanelVisible: false
    property bool bluetoothPanelVisible: false
    property bool bluetoothVisible: true
    property real currentVolume: Pipewire.defaultAudioSink?.audio.volume ?? 0
    property bool isMuted: Pipewire.defaultAudioSink?.audio.mute ?? false
    property var theme : currentTheme


    states: [
    State {
        name: "wifiPanel"
        PropertyChanges { target: root; wifiPanelVisible: true }
        PropertyChanges { target: root; visibleMixerPanel: false }
        PropertyChanges { target: root; visibleBatteryPanel: false }
        PropertyChanges { target: root; bluetoothPanelVisible: false }
    },
    State {
        name: "bluetoothPanel"
        PropertyChanges { target: root; bluetoothPanelVisible: true }
        PropertyChanges { target: root; wifiPanelVisible: false }
        PropertyChanges { target: root; visibleMixerPanel: false }
        PropertyChanges { target: root; visibleBatteryPanel: false }
    },
    State {
        name: "mixerPanel"
        PropertyChanges { target: root; wifiPanelVisible: false }
        PropertyChanges { target: root; visibleMixerPanel: true }
        PropertyChanges { target: root; visibleBatteryPanel: false }
        PropertyChanges { target: root; bluetoothPanelVisible: false }
      },
      State {
        name: "batteryPanel"
        PropertyChanges { target: root; wifiPanelVisible: false }
        PropertyChanges { target: root; visibleMixerPanel: false }
        PropertyChanges { target: root; visibleBatteryPanel: true }
        PropertyChanges { target: root; bluetoothPanelVisible: false }
    },
    State {
        name: "noPanel"
        PropertyChanges { target: root; wifiPanelVisible: false }
        PropertyChanges { target: root; visibleMixerPanel: false }
        PropertyChanges { target: root; visibleBatteryPanel: false }
        PropertyChanges { target: root; bluetoothPanelVisible: false }
    }
  ]

  function togglePanel(panelName) {
    switch (panelName) {
        case "wifi":
            state = state === "wifiPanel" ? "noPanel" : "wifiPanel"
            break
        case "bluetooth":
            state = state === "bluetoothPanel" ? "noPanel" : "bluetoothPanel"
            break
        case "mixer":
            state = state === "mixerPanel" ? "noPanel" : "mixerPanel"
            break
        case "battery":
            state = state === "batteryPanel" ? "noPanel" : "batteryPanel"
            break
        default:
            state = "noPanel"
    }
  }




    PwObjectTracker {
        objects: [ Pipewire.defaultAudioSink ]
    }

    Connections {
        target: Pipewire.defaultAudioSink?.audio ?? null

        function onVolumeChanged() {
            root.shouldShowOsd = true;
            hideTimer.restart();
        }
      }
          Timer {
        id: hideTimer
        interval: 1000
        onTriggered: root.shouldShowOsd = false
    }
    
    
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
            top: currentConfig.mainPanelPos === "top"
            bottom: currentConfig.mainPanelPos === "bottom"
            right: true
        }
        margins {
            top: currentConfig.mainPanelPos === "top" ? 10 : 0
            right: 10
            bottom: currentConfig.mainPanelPos === "bottom" ? 10 : 0
        }
      }

      ComponentBluetooth.BluetoothPanel {
        id: bluetoothPanel
        visible: root.bluetoothPanelVisible

        anchors {
            top: currentConfig.mainPanelPos === "top"
            bottom: currentConfig.mainPanelPos === "bottom"
            right: true
        }
        margins {
            top: currentConfig.mainPanelPos === "top" ? 10 : 0
            right: 10
            bottom: currentConfig.mainPanelPos === "bottom" ? 10 : 0
        }
      }

      Loader {
        id: cpuPanelLoader
        source: "./Mixer/MixerPanel.qml"
        active: visibleMixerPanel
        onLoaded: {
            item.visible = Qt.binding(function() { return visibleMixerPanel })
        }
      }
      Loader {
        id: batteryPanelLoader
        source: "./Battery/BatteryDetailPanel.qml"
        active: visibleBatteryPanel
        onLoaded: {
            item.visible = Qt.binding(function() { return visibleBatteryPanel })
        }
      }



    // =============================
    //   PROCESSES
    // =============================
    
    Process {
        id: wifiProcess
        command: [Qt.resolvedUrl("../../scripts/check-network"), "--stat"]
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
        command: ["cat", "/sys/class/power_supply/BAT1/capacity"]
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
        command: ["cat", "/sys/class/power_supply/BAT1/status"]
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



    function updateWifi() {
        if (!wifiProcess.running) {
            wifiProcess.running = true
        }
    }

    function updateWifiIcon() {
        if (root.net_stat === "Offline") {
            wifi_icon = "../../assets/system/no-wifi.png"
        } else if (root.net_stat === "Online") {
            wifi_icon = "../../assets/system/wifi.png"
        } else {
            var signal = root.signal_current || 0
            if (signal <= 40) {
                wifi_icon = "../../assets/system/wifi_1.png"
            } else if (signal <= 70) {
                wifi_icon = "../../assets/system/wifi_2.png"
            } else {
                wifi_icon = "../../assets/system/wifi.png"
            }
        }
    }

    function updateBatteryIcon() {
        var capacity = parseInt(root.capacity_battery) || 0
        var status = root.status_battery
        
        if (status === "Charging") {
            batteryIcon.source = '../../assets/battery/battery-1.png'
        } else if (capacity <= 20) {
            batteryIcon.source = '../../assets/battery/battery-2.png'
        } else if (capacity <= 50) {
            batteryIcon.source = '../../assets/battery/battery-2.png'
        } else if (capacity <= 80) {
            batteryIcon.source = '../../assets/battery/battery-3.png'
        } else {
            batteryIcon.source = '../../assets/battery/full.png'
        }
    }


    // Xử lý khi panel được mở/đóng
    onWifiPanelVisibleChanged: {
        if (wifiPanelVisible) {
            wifiManager.start()
        } else {
            wifiManager.stop()
        }
    }

    // =============================
    //   UI LAYOUT
    // =============================
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: 0
        spacing: currentSizes.spacing?.small || 5
        Rectangle {
            id: bluetoothContainer
            Layout.preferredWidth: bluetoothCContent.width + currentSizes.statusAreaLayout?.containerPadding
            Layout.preferredHeight: bluetoothCContent.height + currentSizes.statusAreaLayout?.containerVerticalPadding
            color: "transparent"
            radius: 6
            transformOrigin: Item.Center

            RowLayout {
                id: bluetoothCContent
                anchors.centerIn: parent
                spacing: 8

                Image {
                    id: bluetoothImage
                    source: root.bluetooth_icon
                    width: currentSizes.iconSize?.medium || 35
                    height: currentSizes.iconSize?.medium || 35
                    sourceSize: Qt.size(currentSizes.iconSize?.medium || 35, currentSizes.iconSize?.medium || 35)
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                preventStealing: true

                onEntered: bluetoothContainer.scale = 1.1
                onExited: bluetoothContainer.scale = 1.0
                onPressed: bluetoothContainer.scale = 0.95
                onReleased: bluetoothContainer.scale = containsMouse ? 1.1 : 1.0

                onClicked: togglePanel("bluetooth")
            }

            Behavior on scale {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.OutCubic
                }
            }
        }
        Item { Layout.fillWidth: true }

        // Network Status
        Rectangle {
            id: networkContainer
            Layout.preferredWidth: networkContent.width + currentSizes.statusAreaLayout?.containerPadding
            Layout.preferredHeight: networkContent.height + currentSizes.statusAreaLayout?.containerVerticalPadding
            color: "transparent"
            radius: 6
            transformOrigin: Item.Center

            RowLayout {
                id: networkContent
                anchors.centerIn: parent
                spacing: 8

                Image {
                    id: wifiImage
                    source: root.wifi_icon
                    width: currentSizes.iconSize?.medium || 35
                    height: currentSizes.iconSize?.medium || 35
                    sourceSize: Qt.size(currentSizes.iconSize?.medium || 35, currentSizes.iconSize?.medium || 35)
                }
                
                Text {
                    text: root.net_stat
                    color: theme.primary.foreground
                    font {
                        pixelSize: currentSizes.fontSize?.small
                        bold: true
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                preventStealing: true

                onEntered: networkContainer.scale = 1.1
                onExited: networkContainer.scale = 1.0
                onPressed: networkContainer.scale = 0.95
                onReleased: networkContainer.scale = containsMouse ? 1.1 : 1.0

                onClicked: togglePanel("wifi")
            }

            Behavior on scale {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.OutCubic
                }
            }
        }

        Item { Layout.fillWidth: true }

        // Volume
        Rectangle {
            id: volumeContainer
            Layout.preferredWidth: volumeContent.width + currentSizes.statusAreaLayout?.containerPadding
            Layout.preferredHeight: volumeContent.height + currentSizes.statusAreaLayout?.containerVerticalPadding
            color: "transparent"
            radius: 6
            transformOrigin: Item.Center

            RowLayout {
                id: volumeContent
                anchors.centerIn: parent

                Image {
                    id: volumeIcon
                    source: isMuted || currentVolume === 0 ? "../../assets/volume/mute.png" : "../../assets/volume/volume.png"
                    width: currentSizes.iconSize?.medium || 34
                    height: currentSizes.iconSize?.medium || 34
                    sourceSize: Qt.size(currentSizes.iconSize?.medium || 34, currentSizes.iconSize?.medium || 34)
                }
                Text {
                    text: isMuted ? "Muted" : Math.round(currentVolume * 100) + "%"

                    color: theme.primary.foreground
                    font { 
                        pixelSize: currentSizes.fontSize?.normal
                        bold: true 
                    }
                    verticalAlignment: Text.AlignVCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                preventStealing: true

                onEntered: volumeContainer.scale = 1.1
                onExited: volumeContainer.scale = 1.0
                onPressed: volumeContainer.scale = 0.95
                onReleased: volumeContainer.scale = containsMouse ? 1.1 : 1.0
                onClicked: {
                  togglePanel("mixer")

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

            Behavior on scale {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.OutCubic
                }
            }
        }

        Item { Layout.fillWidth: true }

        // Battery
        Rectangle {
            id: batteryContainer
            Layout.preferredWidth: batteryContent.width + currentSizes.statusAreaLayout?.containerPadding
            Layout.preferredHeight: batteryContent.height + currentSizes.statusAreaLayout?.containerVerticalPadding
            color: "transparent"
            radius: 6
            transformOrigin: Item.Center

            RowLayout {
                id: batteryContent
                anchors.centerIn: parent
                spacing: 8

                Image {
                    id: batteryIcon
                    source: '../../assets/battery/full.png'
                    width: currentSizes.iconSize?.normal || 30
                    height: currentSizes.iconSize?.normal || 30
                    sourceSize: Qt.size(currentSizes.iconSize?.normal || 30, currentSizes.iconSize?.normal || 30)
                }
                Text {
                    text: root.capacity_battery + "%"
                    color: theme.primary.foreground
                    font { 
                        pixelSize: currentSizes.fontSize?.medium
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
                  togglePanel("battery")
                }
            }
            Behavior on scale { NumberAnimation { duration: 100 } }
        }

        Item { Layout.fillWidth: true }

        // Power Off
        Rectangle {
            id: powerContainer
            Layout.preferredWidth: currentSizes.statusAreaLayout?.powerContainerSize || 40
            Layout.preferredHeight: currentSizes.statusAreaLayout?.powerContainerSize || 40
            color: "transparent"
            radius: 6
            transformOrigin: Item.Center

            Image {
                id: powerIcon
                source: '../../assets/system/poweroff.png'
                width: currentSizes.iconSize?.normal || 30
                height: currentSizes.iconSize?.normal || 30
                sourceSize: Qt.size(currentSizes.iconSize?.normal || 30, currentSizes.iconSize?.normal || 30)
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
        updateWifi()
        updateSignalWifiProcess()
        updateBatteryCappacityProcess()
        
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


}

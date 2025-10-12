import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Rectangle {
    id: root
    color: "#F5EEE6"
    radius: 8

    property string cpuUsage: "0%"
    property string memoryUsage: "0%"
    property string temperature: "0°C"

    // Process lấy CPU usage
    Process {
        id: cpuProcess
        command: ["bash", "-c", "top -bn1 | grep 'Cpu(s)' | awk '{print $2}' | cut -d'u' -f1"]
        running: false
        stdout: StdioCollector { }
        onRunningChanged: {
            if (!running && stdout.text) {
                const usage = parseFloat(stdout.text)
                if (!isNaN(usage)) {
                    root.cpuUsage = Math.round(usage) + "%"
                }
            }
        }
    }

    // Process lấy Memory usage
    Process {
        id: memoryProcess
        command: ["bash", "-c", "free | grep Mem | awk '{printf \"%.1f\", $3/$2 * 100.0}'"]
        running: false
        stdout: StdioCollector { }
        onRunningChanged: {
            if (!running && stdout.text) {
                const usage = parseFloat(stdout.text)
                if (!isNaN(usage)) {
                    root.memoryUsage = Math.round(usage) + "%"
                }
            }
        }
    }

    // Process lấy CPU temperature (nếu có)
    Process {
        id: tempProcess
        command: ["bash", "-c", "cat /sys/class/thermal/thermal_zone*/temp 2>/dev/null | head -1 | awk '{print $1/1000}' || echo '0'"]
        running: false
        stdout: StdioCollector { }
        onRunningChanged: {
            if (!running && stdout.text) {
                const temp = parseFloat(stdout.text)
                if (!isNaN(temp) && temp > 0) {
                    root.temperature = Math.round(temp) + "°C"
                } else {
                    root.temperature = "N/A"
                }
            }
        }
    }

    function updateCpu() {
        if (!cpuProcess.running) cpuProcess.running = true
    }

    function updateMemory() {
        if (!memoryProcess.running) memoryProcess.running = true
    }

    function updateTemperature() {
        if (!tempProcess.running) tempProcess.running = true
    }

    function updateAll() {
        updateCpu()
        updateMemory()
        updateTemperature()
    }

    Row {
        anchors.centerIn: parent
        spacing: 15

        // CPU
        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 0
            Column {
              anchors.verticalCenter: parent.verticalCenter
              spacing: 0
              Text {
                text: root.cpuUsage
                color: "#000"
                font { 
                    pixelSize: 15
                    bold: true 
                }
                anchors.horizontalCenter: parent.horizontalCenter
              }
              Text {
                text: "Cpu"
                color: "#666"
                font.pixelSize: 10
                anchors.horizontalCenter: parent.horizontalCenter
              }
            }
            Image {
                source: "./assets/cpu.png"   // đường dẫn tới ảnh icon CPU
                width: 36
                height: 36
                fillMode: Image.PreserveAspectFit
                smooth: true
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 0
            Column {
              anchors.verticalCenter: parent.verticalCenter
              spacing: 0
              Text {
                text: root.memoryUsage
                color: "#000"
                font { 
                    pixelSize: 15
                    bold: true 
                }
                anchors.horizontalCenter: parent.horizontalCenter
              }
              Text {
                text: "Bộ nhớ"
                color: "#666"
                font.pixelSize: 10
                anchors.horizontalCenter: parent.horizontalCenter
              }
            }
            
            Image {
                source: "./assets/memory.png"   // đường dẫn tới ảnh icon CPU
                width: 30
                height: 30
                fillMode: Image.PreserveAspectFit
                smooth: true
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 0
            Column {
              anchors.verticalCenter: parent.verticalCenter
              spacing: 0
              Text {
                text: root.temperature
                color: "#000"
                font { 
                    pixelSize: 15
                    bold: true 
                }
                anchors.horizontalCenter: parent.horizontalCenter
              }
              Text {
                text: "Nhiệt độ"
                color: "#666"
                font.pixelSize: 10
                anchors.horizontalCenter: parent.horizontalCenter
              }
            }
            Image {
                source: "./assets/temperature.png"   // đường dẫn tới ảnh icon CPU
                width: 36
                height: 36
                fillMode: Image.PreserveAspectFit
                smooth: true
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    // MouseArea để refresh manual
    MouseArea {
        anchors.fill: parent
        onClicked: updateAll()
        
        onPressed: {
            parent.scale = 0.95
        }
        onReleased: {
            parent.scale = 1.0
        }
    }

    Behavior on scale {
        NumberAnimation { duration: 100 }
    }

    Component.onCompleted: {
        console.log("🖥️ CPU Panel Started")
        updateAll()
    }

    // Timers
    Timer {
        interval: 2000 // Cập nhật CPU mỗi 2 giây
        running: true
        repeat: true
        onTriggered: updateCpu()
    }

    Timer {
        interval: 5000 // Cập nhật Memory mỗi 5 giây
        running: true
        repeat: true
        onTriggered: updateMemory()
    }

    Timer {
        interval: 10000 // Cập nhật Temperature mỗi 10 giây
        running: true
        repeat: true
        onTriggered: updateTemperature()
    }
}

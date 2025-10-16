import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import './widgets/'
import '../modules/ram/'
import './Cpu/'

Rectangle {
    id: root
    color: "#F5EEE6"
    border.color: "#4f4f5b"
    border.width: 3
    radius: 10
    width: 300  // Chiều rộng phù hợp với panel hệ thống
    height: 50  // Chiều cao phù hợp với panel hệ thống

    property string cpuUsage: "0%"
    property string memoryUsage: "0%"
    property string temperature: "0°C"
    property bool panelVisible: false
    property bool ramPanelVisible: false

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

        // CPU Container - Click để mở panel chi tiết
        Rectangle {
            id: cpuContainer
            width: cpuContent.width + 20
            height: cpuContent.height + 10
            color: "transparent"
            radius: 6

            Row {
                id: cpuContent
                anchors.centerIn: parent
                spacing: 0
                anchors.verticalCenter: parent.verticalCenter
                
                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 0
                    Text {
                        id: cpuText
                        text: root.cpuUsage
                        color: "#000"
                        font { 
                            pixelSize: 15
                            bold: true 
                        }
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Text {
                        id: cpuLabel
                        text: "Cpu"
                        color: "#666"
                        font.pixelSize: 10
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
                Image {
                    id: cpuIcon
                    source: "../assets/cpu.png"
                    width: 36
                    height: 36
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                
                onClicked: {
                    root.panelVisible = !root.panelVisible
                }
                
                // Hiệu ứng hover
                onEntered: {
                    cpuContainer.scale = 1.1
                }
                onExited: {
                    cpuContainer.scale = 1.0
                }
            }
            
            Behavior on scale { NumberAnimation { duration: 100 } }
        }

        // Memory (giữ nguyên)
        Rectangle {
            id: memoryContainer
            width: memoryContent.width + 20
            height: memoryContent.height + 10
            color: "transparent"
            radius: 6

            Row {
                id: memoryContent
                anchors.centerIn: parent
                spacing: 0
                anchors.verticalCenter: parent.verticalCenter
                
                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 0
                    Text {
                        id: memoryText
                        text: root.memoryUsage
                        color: "#000"
                        font { 
                            pixelSize: 15
                            bold: true 
                        }
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Text {
                        id: memoryLabel
                        text: "Ram"
                        color: "#666"
                        font.pixelSize: 10
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
                
                Image {
                    id: memoryIcon
                    source: "../assets/memory.png"
                    width: 30
                    height: 30
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    root.ramPanelVisible = !root.ramPanelVisible
                }
                
                // Hiệu ứng hover
                onEntered: {
                    memoryContainer.scale = 1.1
                }
                onExited: {
                    memoryContainer.scale = 1.0
                }
            }
            
            Behavior on scale { NumberAnimation { duration: 100 } }
        }

        // Temperature (giữ nguyên)
        Rectangle {
            id: tempContainer
            width: tempContent.width + 20
            height: tempContent.height + 10
            color: "transparent"
            radius: 6

            Row {
                id: tempContent
                anchors.centerIn: parent
                spacing: 0
                anchors.verticalCenter: parent.verticalCenter
                
                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 0
                    Text {
                        id: tempText
                        text: root.temperature
                        color: "#000"
                        font { 
                            pixelSize: 15
                            bold: true 
                        }
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Text {
                        id: tempLabel
                        text: "Nhiệt độ"
                        color: "#666"
                        font.pixelSize: 10
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
                Image {
                    id: tempIcon
                    source: "../assets/temperature.png"
                    width: 36
                    height: 36
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                
                // Hiệu ứng hover
                onEntered: {
                    tempContainer.scale = 1.1
                }
                onExited: {
                    tempContainer.scale = 1.0
                }
            }
            
            Behavior on scale { NumberAnimation { duration: 100 } }
        }
    }

    // Panel chi tiết CPU - Hiển thị khi click vào cpuContainer
    CpuDetailPanel {
        id: detailPanel
        visible: root.panelVisible
        anchors {
            top: parent.bottom
            left: parent.left
        }
        margins {
            top: 10
        }
        
        onCloseRequested: {
            root.panelVisible = false
        }
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

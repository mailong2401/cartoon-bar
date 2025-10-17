import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import './widgets/'
import '../modules/ram/'

Rectangle {
    id: root
    color: theme.primary.background
    border.color: theme.normal.black
    border.width: 3
    radius: 10
    width: 300  // Chiều rộng phù hợp với panel hệ thống
    height: 50  // Chiều cao phù hợp với panel hệ thống

    property string cpuUsage: "0%"
    property string memoryUsage: "0%"
    property string temperature: "0°C"
    property bool cpuPanelVisible: false
    property bool ramPanelVisible: false
    property var theme : currentTheme

    Loader {
        id: cpuPanelLoader
        source: "./Cpu/CpuDetailPanel.qml"
        active: cpuPanelVisible
        onLoaded: {
            item.anchors.top = parent.bottom
            item.anchors.left = parent.left
            item.visible = Qt.binding(function() { return launcherPanelVisible })
        }
    }


    // Process lấy CPU usage
    Process {
        id: cpuProcess
        command: ["scripts/cpu"]
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
        command: ["scripts/ram-usage"]
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
        command: ["scripts/cpu-temp"]
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

    RowLayout {
        anchors.centerIn: parent
        spacing: 5

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
                        color: theme.primary.foreground
                        font { 
                            pixelSize: 15
                            bold: true 
                        }
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Text {
                        id: cpuLabel
                        text: "Cpu"
                        color: theme.primary.dim_foreground
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
                    root.cpuPanelVisible = !root.cpuPanelVisible
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
                        color: theme.primary.foreground
                        font { 
                            pixelSize: 15
                            bold: true 
                        }
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Text {
                        id: memoryLabel
                        text: "Ram"
                        color: theme.primary.dim_foreground
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
                        color: theme.primary.foreground
                        font { 
                            pixelSize: 15
                            bold: true 
                        }
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Text {
                        id: tempLabel
                        text: "Nhiệt độ"
                        color: theme.primary.dim_foreground
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


    Component.onCompleted: {
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

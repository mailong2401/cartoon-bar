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
    radius: currentSizes.radius?.normal || 10
    clip: true

    property string cpuUsage: "0%"
    property string memoryUsage: "0%"
    property bool cpuPanelVisible: false
    property bool ramPanelVisible: false
    property var theme : currentTheme

    states: [
    State {
        name: "cpuPanel"
        PropertyChanges { target: root; cpuPanelVisible: true }
        PropertyChanges { target: root; ramPanelVisible: false }
    },
    State {
        name: "ramPanel" 
        PropertyChanges { target: root; cpuPanelVisible: false }
        PropertyChanges { target: root; ramPanelVisible: true }
    },
    State {
        name: "noPanel"
        PropertyChanges { target: root; cpuPanelVisible: false }
        PropertyChanges { target: root; ramPanelVisible: false }
    }
  ]

  // Sửa hàm togglePanel
function togglePanel(panelName) {
    switch(panelName) {
        case "cpu":
            state = state === "cpuPanel" ? "noPanel" : "cpuPanel"
            break
        case "ram":
            state = state === "ramPanel" ? "noPanel" : "ramPanel"
            break
        default:
            state = "noPanel"
    }
}

    Loader {
        id: cpuPanelLoader
        source: "./Cpu/CpuDetailPanel.qml"
        active: cpuPanelVisible
        onLoaded: {
            item.exclusiveZone = 0
            item.visible = Qt.binding(function() { return cpuPanelVisible })
        }
      }
      Loader {
        id: ramPanelLoader
        source: "./Ram/RamDetailPanel.qml"
        active: ramPanelVisible
        onLoaded: {
            item.visible = Qt.binding(function() { return ramPanelVisible })
        }
      }


    // Process lấy CPU usage
    Process {
        id: cpuProcess
        command: [Qt.resolvedUrl("../../scripts/cpu")]
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
        command: [Qt.resolvedUrl("../../scripts/ram-usage")]
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


    function updateCpu() {
        if (!cpuProcess.running) cpuProcess.running = true
    }

    function updateMemory() {
        if (!memoryProcess.running) memoryProcess.running = true
    }
    function updateAll() {
        updateCpu()
        updateMemory()
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: currentSizes.cpuPanelLayout?.containerMargin || 4
        spacing: currentSizes.cpuPanelLayout?.containerSpacing || 4

        // CPU Container - Click để mở panel chi tiết
        Rectangle {
            id: cpuContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
            radius: currentSizes.cpuPanelLayout?.containerRadius || 6

            RowLayout {
                id: cpuContent
                anchors.centerIn: parent
                spacing: currentSizes.cpuPanelLayout?.itemSpacing || 2

                ColumnLayout {
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 0
                    Text {
                        id: cpuText
                        text: root.cpuUsage
                        color: theme.primary.foreground
                        font {
                            family: "ComicShannsMono Nerd Font"
                            pixelSize: currentSizes.cpuPanelLayout?.usageTextSize || 15
                            bold: true
                        }
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text {
                        id: cpuLabel
                        text: "Cpu"
                        color: theme.primary.dim_foreground
                        font {
                            family: "ComicShannsMono Nerd Font"
                            pixelSize: currentSizes.cpuPanelLayout?.labelTextSize || 10
                        }
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
                Image {
                    id: cpuIcon
                    source: "../../assets/cpu.png"
                    Layout.preferredWidth: currentSizes.cpuPanelLayout?.cpuIconSize || 36
                    Layout.preferredHeight: currentSizes.cpuPanelLayout?.cpuIconSize || 36
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    Layout.alignment: Qt.AlignVCenter
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                  root.togglePanel("cpu")
                }

                // Hiệu ứng hover - dùng opacity thay vì scale để tránh tràn
                onEntered: {
                    cpuContainer.opacity = 0.8
                }
                onExited: {
                    cpuContainer.opacity = 1.0
                }
            }

            Behavior on opacity { NumberAnimation { duration: 100 } }
        }

        // Memory Container
        Rectangle {
            id: memoryContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
            radius: currentSizes.cpuPanelLayout?.containerRadius || 6

            RowLayout {
                id: memoryContent
                anchors.centerIn: parent
                spacing: currentSizes.cpuPanelLayout?.itemSpacing || 2

                ColumnLayout {
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 0
                    Text {
                        id: memoryText
                        text: root.memoryUsage
                        color: theme.primary.foreground
                        font {
                            family: "ComicShannsMono Nerd Font"
                            pixelSize: currentSizes.cpuPanelLayout?.usageTextSize || 15
                            bold: true
                        }
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text {
                        id: memoryLabel
                        text: "Ram"
                        color: theme.primary.dim_foreground
                        font {
                            family: "ComicShannsMono Nerd Font"
                            pixelSize: currentSizes.cpuPanelLayout?.labelTextSize || 10
                        }
                        Layout.alignment: Qt.AlignHCenter
                    }
                }

                Image {
                    id: memoryIcon
                    source: "../../assets/memory.png"
                    Layout.preferredWidth: currentSizes.cpuPanelLayout?.ramIconSize || 30
                    Layout.preferredHeight: currentSizes.cpuPanelLayout?.ramIconSize || 30
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    Layout.alignment: Qt.AlignVCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                  root.togglePanel("ram")
                }

                // Hiệu ứng hover - dùng opacity thay vì scale để tránh tràn
                onEntered: {
                    memoryContainer.opacity = 0.8
                }
                onExited: {
                    memoryContainer.opacity = 1.0
                }
            }

            Behavior on opacity { NumberAnimation { duration: 100 } }
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
        interval: 2000 // Cập nhật Memory mỗi 5 giây
        running: true
        repeat: true
        onTriggered: updateMemory()
    }
}

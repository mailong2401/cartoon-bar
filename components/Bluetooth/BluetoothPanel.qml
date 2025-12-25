import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell
import Quickshell.Bluetooth

PanelWindow {
    id: root
    implicitWidth: 430
    implicitHeight: 600
    anchors {
      top: true
      right: true
    }
    margins {
        top: 10
        right: 10
    }
    color: "transparent"

    // Theme
    property var theme: currentTheme

    // Properties
    property var adapter: Bluetooth.defaultAdapter
    property int connectedCount: {
        let count = 0
        for (let i = 0; i < Bluetooth.devices.length; i++) {
            if (Bluetooth.devices[i].connected) count++
        }
        return count
    }

    // Device delegate component
    Component {
        id: deviceDelegate

        Rectangle {
            id: delegateRoot
            required property var modelData
            required property int index

            width: ListView.view.width
            height: 70
            radius: 10
            color: deviceMouseArea.containsMouse ? theme.primary.dim_background : theme.primary.background
            border.width: modelData?.connected ? 2 : 0
            border.color: modelData?.connected ? theme.normal.green : "transparent"

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 12

                // Device icon
                Rectangle {
                    width: 46
                    height: 46
                    radius: 23
                    color: modelData?.connected ? theme.normal.green : theme.button.background

                    Text {
                        anchors.centerIn: parent
                        text: getDeviceIcon(modelData?.icon || "")
                        color: theme.primary.foreground
                        font.pixelSize: 20
                    }

                    // Battery indicator
                    Rectangle {
                        visible: modelData?.batteryAvailable && modelData?.battery > 0
                        width: 20
                        height: 8
                        radius: 2
                        color: theme.primary.background
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: -2
                        anchors.horizontalCenter: parent.horizontalCenter

                        Rectangle {
                            width: parent.width * Math.min(modelData?.battery || 0, 1) - 2
                            height: parent.height - 2
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: 1
                            radius: 1
                            color: {
                                const battery = modelData?.battery || 0
                                if (battery > 0.7) return theme.normal.green
                                if (battery > 0.3) return theme.normal.yellow
                                return theme.normal.red
                            }
                        }
                    }
                }

                // Device info
                ColumnLayout {
                    spacing: 4
                    Layout.fillWidth: true

                    Text {
                        text: modelData?.name || modelData?.deviceName || modelData?.address || "Unknown"
                        color: theme.primary.foreground
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    Row {
                        spacing: 8

                        Text {
                            text: {
                                if (modelData?.connecting) return "🔄 Đang kết nối..."
                                if (modelData?.connected) return "✓ Đã kết nối"
                                if (modelData?.paired) return "✓ Đã ghép nối"
                                return "Không kết nối"
                            }
                            color: {
                                if (modelData?.connected) return theme.normal.green
                                if (modelData?.paired) return theme.normal.yellow
                                return theme.primary.dim_foreground
                            }
                            font.pixelSize: 11
                        }

                        Text {
                            visible: modelData?.batteryAvailable && modelData?.battery > 0
                            text: `🔋 ${Math.round((modelData?.battery || 0) * 100)}%`
                            color: theme.primary.dim_foreground
                            font.pixelSize: 11
                        }
                    }

                    Text {
                        text: modelData?.address || ""
                        color: theme.primary.dim_foreground
                        font.pixelSize: 10
                        Layout.fillWidth: true
                    }
                }

                // Action buttons
                Row {
                    spacing: 6

                    // Connect/Disconnect button
                    Rectangle {
                        width: 32
                        height: 32
                        radius: 8
                        color: modelData?.connected ? theme.normal.red :
                               modelData?.paired ? theme.normal.blue : theme.button.background
                        opacity: (modelData?.paired || modelData?.connecting) ? 1 : 0.5

                        Text {
                            anchors.centerIn: parent
                            text: modelData?.connecting ? "🔄" :
                                  modelData?.connected ? "🔌" : "🔗"
                            color: theme.primary.foreground
                            font.pixelSize: 14
                        }

                        MouseArea {
                            anchors.fill: parent
                            enabled: modelData?.paired || modelData?.connecting
                            onClicked: {
                                if (modelData?.connected) {
                                    modelData.connected = false
                                } else if (modelData?.paired && !modelData?.connecting) {
                                    modelData.connected = true
                                }
                            }
                        }
                    }

                    // Pair/Forget button
                    Rectangle {
                        width: 32
                        height: 32
                        radius: 8
                        color: modelData?.pairing ? theme.normal.yellow :
                               modelData?.paired ? theme.normal.red : theme.normal.blue
                        opacity: modelData?.pairing ? 0.8 : 1

                        Text {
                            anchors.centerIn: parent
                            text: modelData?.pairing ? "⏳" :
                                  modelData?.paired ? "🗑️" : "👥"
                            color: theme.primary.foreground
                            font.pixelSize: 14
                        }

                        MouseArea {
                            anchors.fill: parent
                            enabled: !modelData?.pairing
                            onClicked: {
                                if (modelData?.paired) {
                                    modelData.forget()
                                } else if (!modelData?.pairing) {
                                    modelData.pair()
                                }
                            }
                        }
                    }
                }
            }

            MouseArea {
                id: deviceMouseArea
                anchors.fill: parent
                hoverEnabled: true
                propagateComposedEvents: true
                onPressed: function(mouse) { mouse.accepted = false }
            }
        }
    }

    // Helper function
    function getDeviceIcon(iconName) {
        if (iconName.includes("audio")) return "🎧"
        if (iconName.includes("phone")) return "📱"
        if (iconName.includes("computer")) return "💻"
        if (iconName.includes("input-mouse")) return "🖱"
        if (iconName.includes("input-keyboard")) return "⌨"
        if (iconName.includes("camera")) return "📷"
        if (iconName.includes("printer")) return "🖨"
        return "📡"
    }
    
    // Drop shadow
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        
        Rectangle {
            anchors.fill: parent
            color: theme.primary.background
            radius: 16
            border.color: theme.normal.black
            border.width: 2
            
            // Main content
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12
                
                // Header with animated gradient
                Rectangle {
                    Layout.fillWidth: true
                    height: 60
                    radius: 12
                    color: theme.primary.dim_background
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 16
                        
                        // Bluetooth icon with animation
                        Rectangle {
                            width: 40
                            height: 40
                            radius: 20
                            color: adapter?.enabled ? theme.normal.blue : theme.normal.red

                            Text {
                                anchors.centerIn: parent
                                text: "⎋"
                                color: theme.primary.foreground
                                font.pixelSize: 22
                                font.bold: true
                            }
                        }
                        
                        ColumnLayout {
                            spacing: 4
                            Layout.fillWidth: true
                            
                            Text {
                                text: "BLUETOOTH"
                                color: theme.primary.dim_foreground
                                font.pixelSize: 12
                                font.weight: Font.Bold
                            }

                            Text {
                                text: adapter?.enabled ?
                                      (connectedCount > 0 ?
                                       `${connectedCount} thiết bị đã kết nối` :
                                       "Đã bật - Sẵn sàng kết nối") :
                                      "Đã tắt"
                                color: adapter?.enabled ? theme.normal.green : theme.normal.red
                                font.pixelSize: 14
                                font.weight: Font.Medium
                            }
                        }
                        
                        // Toggle switch with custom design
                        Rectangle {
                            width: 56
                            height: 32
                            radius: 16
                            color: adapter?.enabled ? theme.normal.green : theme.button.background
                            opacity: adapter ? 1 : 0.5

                            Rectangle {
                                x: adapter?.enabled ? parent.width - width - 4 : 4
                                y: 4
                                width: 24
                                height: 24
                                radius: 12
                                color: theme.primary.foreground
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                enabled: !!adapter
                                onClicked: {
                                    if (adapter) {
                                        adapter.enabled = !adapter.enabled
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Control panel
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: controlPanel.implicitHeight + 20
                    radius: 12
                    color: theme.primary.dim_background
                    clip: true
                    visible: adapter?.enabled || false

                    ColumnLayout {
                        id: controlPanel
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8
                        
                        // Adapter info
                        RowLayout {
                            Layout.fillWidth: true
                            
                            ColumnLayout {
                                spacing: 2
                                Layout.fillWidth: true
                                
                                Text {
                                    text: adapter?.name || "Unknown Adapter"
                                    color: theme.primary.foreground
                                    font.pixelSize: 13
                                    font.weight: Font.Medium
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }

                                Text {
                                    text: `ID: ${adapter?.adapterId || "N/A"}`
                                    color: theme.primary.dim_foreground
                                    font.pixelSize: 11
                                }
                            }

                            Text {
                                text: adapter?.discoverable ? "👁‍🗨 Hiển thị" : "🙈 Ẩn"
                                color: adapter?.discoverable ? theme.normal.green : theme.primary.dim_foreground
                                font.pixelSize: 11
                            }
                        }
                        
                        // Control buttons
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 8
                            
                            Button {
                                id: scanButton
                                Layout.fillWidth: true
                                height: 36
                                
                                background: Rectangle {
                                    radius: 8
                                    color: {
                                        if (adapter?.discovering) return "#ff3b30"
                                        if (scanButton.hovered) return "#007aff"
                                        return "theme.button.background"
                                    }
                                    border.width: 1
                                    border.color: adapter?.discovering ? "#ff3b30" : "theme.button.background"
                                }
                                
                                contentItem: Row {
                                    spacing: 8
                                    anchors.centerIn: parent
                                    
                                    Text {
                                        text: adapter?.discovering ? "⏹" : "🔍"
                                        color: "white"
                                        font.pixelSize: 14
                                    }
                                    
                                    Text {
                                        text: adapter?.discovering ? "DỪNG QUÉT" : "QUÉT THIẾT BỊ"
                                        color: "white"
                                        font.pixelSize: 12
                                        font.weight: Font.Medium
                                    }
                                }
                                
                                onClicked: {
                                    if (adapter) {
                                        adapter.discovering = !adapter.discovering
                                    }
                                }
                            }
                            
                            Button {
                                Layout.preferredWidth: 36
                                height: 36
                                
                                background: Rectangle {
                                    radius: 8
                                    color: adapter?.discoverable ? "#34c759" : "theme.button.background"
                                    border.width: 1
                                    border.color: adapter?.discoverable ? "#34c759" : "theme.button.background"
                                }
                                
                                contentItem: Text {
                                    text: adapter?.discoverable ? "👁" : "🙈"
                                    color: "white"
                                    font.pixelSize: 14
                                    anchors.centerIn: parent
                                }
                                
                                onClicked: {
                                    if (adapter) {
                                        adapter.discoverable = !adapter.discoverable
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Devices list
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 12
                    color: theme.primary.dim_background
                    clip: true
                    visible: adapter?.enabled || false
                    
                    ColumnLayout {
                        anchors.fill: parent
                        
                        // List header
                        Rectangle {
                            Layout.fillWidth: true
                            height: 40
                            color: theme.primary.background
                            radius: 12
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 12
                                
                                Text {
                                    text: "THIẾT BỊ"
                                    color: theme.primary.dim_foreground
                                    font.pixelSize: 11
                                    font.weight: Font.Bold
                                }
                                
                                Item { Layout.fillWidth: true }
                                
                                Text {
                                    text: `${Bluetooth.devices.length} thiết bị`
                                    color: theme.primary.dim_foreground
                                    font.pixelSize: 11
                                }
                            }
                        }
                        
                        // Devices scroll area
                        ScrollView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                            
                            ListView {
                                id: deviceList
                                model: Bluetooth.devices
                                spacing: 4
                                boundsBehavior: Flickable.StopAtBounds
                                
                                delegate: deviceDelegate
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: {
                                        if (!adapter?.enabled) return "Bluetooth đã tắt"
                                        if (adapter?.discovering && deviceList.count === 0) return "🔍 Đang tìm kiếm thiết bị..."
                                        if (deviceList.count === 0) return "Không có thiết bị nào"
                                        return ""
                                    }
                                    color: theme.primary.dim_foreground
                                    font.pixelSize: 13
                                    visible: text !== ""
                                }
                            }
                        }
                    }
                }

                // Empty state when Bluetooth is off
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 12
                    color: theme.primary.dim_background
                    visible: !adapter?.enabled

                    Column {
                        anchors.centerIn: parent
                        spacing: 16

                        Text {
                            text: "📶"
                            color: theme.primary.dim_foreground
                            font.pixelSize: 48
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Text {
                            text: "Bluetooth đã tắt"
                            color: theme.primary.foreground
                            font.pixelSize: 16
                            font.weight: Font.Medium
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        
                        Text {
                            text: "Bật Bluetooth để kết nối với thiết bị"
                            color: theme.primary.dim_foreground
                            font.pixelSize: 12
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }
        }
    }
    
}

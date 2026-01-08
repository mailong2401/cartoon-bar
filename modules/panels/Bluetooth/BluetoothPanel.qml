// Bluetooth Panel - Main component
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import "." as Components

PanelWindow {
    id: root
    implicitWidth: currentSizes.bluetoothPanel?.width || 470
    implicitHeight: currentSizes.bluetoothPanel?.height || 600
    color: "transparent"
    focusable: true
    aboveWindows: true
    objectName: "BluetoothPanel"

    property var sizes: currentSizes.bluetoothPanel || {}
    property var theme: currentTheme
    property var lang: currentLanguage
    property var adapter: Bluetooth.defaultAdapter
    property int connectedCount: {
        let count = 0
        for (let i = 0; i < Bluetooth.devices.length; i++) {
            if (Bluetooth.devices[i].connected) count++
        }
        return count
    }

    property bool isDiscoverable: adapter ? adapter.discoverable : false
    property bool isPairable: adapter ? adapter.pairable : true

    // Timer to automatically stop scanning after 30 seconds
    Timer {
        id: scanTimer
        interval: 30000
        onTriggered: {
            if (adapter && adapter.discovering) {
                adapter.discovering = false
            }
        }
    }

    // Show error message when pairing fails
    property string pairErrorMessage: ""
    Timer {
        id: errorMessageTimer
        interval: 5000
        onTriggered: pairErrorMessage = ""
    }

    // Main container
    Rectangle {
        anchors.fill: parent
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            color: theme.primary.background
            radius: sizes.radius || 16
            border.color: theme.normal.black
            border.width: sizes.borderWidth || 3

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: sizes.margins || 10
                spacing: sizes.spacing || 6

                // Header with title and scan button
                Components.BluetoothHeader {
                    adapter: root.adapter
                    theme: root.theme
                    sizes: root.sizes
                    lang: root.lang
                    isDiscovering: adapter?.discovering || false

                    onScanClicked: {
                        if (adapter) {
                            if (adapter.discovering) {
                                adapter.discovering = false
                                scanTimer.stop()
                            } else {
                                adapter.discovering = true
                                scanTimer.restart()

                                // Ensure adapter is discoverable
                                adapter.discoverable = true
                                adapter.pairable = true
                            }
                        }
                    }
                }

                // Error message
                Rectangle {
                    Layout.fillWidth: true
                    height: pairErrorMessage ? 40 : 0
                    radius: 8
                    color: theme.normal.red
                    visible: pairErrorMessage !== ""
                    clip: true

                    Behavior on height {
                        NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8

                        Text {
                            text: "⚠️ " + pairErrorMessage
                            color: theme.primary.foreground
                            font.pixelSize: 12
                            Layout.fillWidth: true
                        }

                        Text {
                            text: "✕"
                            color: theme.primary.foreground
                            font.pixelSize: 14
                            MouseArea {
                                anchors.fill: parent
                                onClicked: pairErrorMessage = ""
                            }
                        }
                    }
                }

                // Status card with toggle
                Components.BluetoothStatusCard {
                    adapter: root.adapter
                    theme: root.theme
                    sizes: root.sizes
                    lang: root.lang
                    connectedCount: root.connectedCount
                }

                // Device list
                Components.BluetoothDeviceList {
                    adapter: root.adapter
                    theme: root.theme
                    sizes: root.sizes
                    lang: root.lang
                    connectedCount: root.connectedCount

                    onPairError: function(message) {
                        pairErrorMessage = message
                        errorMessageTimer.restart()
                    }
                }

                // Disabled state message
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
                            text: lang?.bluetooth?.disabled || "Bluetooth đã tắt"
                            color: theme.primary.foreground
                            font.pixelSize: 16
                            font.weight: Font.Medium
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Text {
                            text: lang?.bluetooth?.turn_on || "Bật Bluetooth để kết nối với thiết bị"
                            color: theme.primary.dim_foreground
                            font.pixelSize: 12
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }
        }
    }

    // Monitor adapter changes
    Connections {
        target: adapter
        enabled: !!adapter
        function onEnabledChanged() {
            if (adapter?.enabled) {
                // When enabling adapter, set default modes
                adapter.pairable = true
                adapter.discoverable = false // Default not discoverable
            }
        }
        function onDiscoveringChanged() {}
        function onDiscoverableChanged() {}
        function onPairableChanged() {}
    }

    // Monitor device list changes
    Connections {
        target: Bluetooth
        function onDevicesChanged() {}
    }

    Component.onCompleted: {
        // Ensure adapter is pairable on startup
        if (adapter && adapter.enabled) {
            adapter.pairable = true
        }
    }
}

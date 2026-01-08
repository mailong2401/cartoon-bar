// Device list component for Bluetooth panel
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Bluetooth
import "." as Components

Rectangle {
    id: deviceListRoot
    required property var adapter
    required property var theme
    required property var sizes
    required property var lang
    required property int connectedCount

    signal pairError(string message)

    Layout.fillWidth: true
    Layout.fillHeight: true
    radius: 12
    color: theme.primary.dim_background
    clip: true
    visible: adapter?.enabled || false

    ColumnLayout {
        anchors.fill: parent

        Rectangle {
            Layout.fillWidth: true
            height: 20
            color: theme.primary.background
            radius: 12
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

            ListView {
                id: deviceList
                model: Bluetooth.devices
                spacing: 4
                boundsBehavior: Flickable.StopAtBounds

                delegate: Components.BluetoothDeviceItem {
                    adapter: deviceListRoot.adapter
                    theme: deviceListRoot.theme
                    sizes: deviceListRoot.sizes
                    lang: deviceListRoot.lang
                    onPairError: function(message) {
                        deviceListRoot.pairError(message)
                    }
                }

                // Empty state message
                Text {
                    anchors.centerIn: parent
                    text: {
                        if (!adapter?.enabled) return lang?.bluetooth?.disabled || "Bluetooth đã tắt"
                        if (adapter?.discovering && deviceList.count === 0) return "🔍 " + (lang?.bluetooth?.searching || "Đang tìm kiếm thiết bị...")
                        if (deviceList.count === 0) return lang?.bluetooth?.no_devices || "Không có thiết bị nào"
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

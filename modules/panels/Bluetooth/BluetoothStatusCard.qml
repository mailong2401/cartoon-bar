// Status card component for Bluetooth panel
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: statusCard
    required property var adapter
    required property var theme
    required property var sizes
    required property var lang
    required property int connectedCount

    Layout.fillWidth: true
    height: sizes.statusCardHeight || 82
    radius: sizes.statusCardRadius || 12
    color: theme.primary.dim_background
    border.width: 3
    border.color: theme.normal.black

    RowLayout {
        anchors.fill: parent
        anchors.margins: sizes.statusCardMargins || 14
        spacing: sizes.statusCardSpacing || 12

        // Left column: status and device count
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4

            Text {
                text: adapter?.enabled ? (lang?.bluetooth?.enabled || "Bluetooth đang bật") : (lang?.bluetooth?.disabled || "Bluetooth đang tắt")
                color: adapter?.enabled ? theme.normal.blue : theme.primary.dim_foreground
                font.pixelSize: sizes.statusTitleFontSize || 20
                font.family: "ComicShannsMono Nerd Font"
                font.bold: true

                Behavior on color { ColorAnimation { duration: 200 } }
            }

            Text {
                text: `${connectedCount} ` + (lang?.bluetooth?.devices_connected || "thiết bị đã kết nối")
                color: theme.primary.dim_foreground
                font.pixelSize: sizes.statusSubtitleFontSize || 16
                font.family: "ComicShannsMono Nerd Font"
                visible: adapter?.enabled || false
            }
        }

        Item { Layout.fillWidth: true }

        // Toggle button
        Rectangle {
            width: sizes.toggleWidth || 56
            height: sizes.toggleHeight || 32
            radius: sizes.toggleRadius || 16
            color: adapter?.enabled ? theme.normal.blue : theme.button.background
            opacity: adapter ? 1 : 0.5

            scale: toggleMouseArea.containsPress ? 0.95 : (toggleMouseArea.containsMouse ? 1.05 : 1.0)
            Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }
            Behavior on color { ColorAnimation { duration: 300 } }

            Rectangle {
                x: adapter?.enabled ? parent.width - width - 4 : 4
                y: 4
                width: sizes.toggleIndicatorSize || 24
                height: sizes.toggleIndicatorSize || 24
                radius: (sizes.toggleIndicatorSize || 24) / 2
                color: theme.primary.dim_background

                Behavior on x { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
            }

            MouseArea {
                id: toggleMouseArea
                anchors.fill: parent
                enabled: !!adapter
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (adapter) {
                        adapter.enabled = !adapter.enabled
                        if (adapter.enabled) {
                            // When enabling Bluetooth, set necessary modes
                            adapter.pairable = true
                            adapter.discoverable = true
                        }
                    }
                }
            }
        }
    }
}

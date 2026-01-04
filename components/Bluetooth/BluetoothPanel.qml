import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth

PanelWindow {
    id: root
    implicitWidth: 470
    implicitHeight: 600
    color: "transparent"
    focusable: true
    aboveWindows: true
    objectName: "BluetoothPanel"

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
    
    // Timer để tự động tắt chế độ quét sau 30 giây
    Timer {
        id: scanTimer
        interval: 30000
        onTriggered: {
            if (adapter && adapter.discovering) {
                adapter.discovering = false
            }
        }
    }
    
    // Hiển thị thông báo khi có lỗi ghép nối
    property string pairErrorMessage: ""
    Timer {
        id: errorMessageTimer
        interval: 5000
        onTriggered: pairErrorMessage = ""
    }

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
            border.color: modelData?.connected ? theme.normal.blue : "transparent"

            scale: deviceMouseArea.containsPress ? 0.98 : 1.0
            Behavior on scale { NumberAnimation { duration: 100 } }
            Behavior on color { ColorAnimation { duration: 200 } }
            Behavior on border.color { ColorAnimation { duration: 200 } }
            
            // Hiển thị trạng thái ghép nối
            Rectangle {
                id: pairingIndicator
                visible: modelData?.pairing || false
                anchors.centerIn: parent
                width: parent.width - 20
                height: parent.height - 20
                radius: 8
                color: theme.normal.yellow
                opacity: 0.3

                Text {
                    anchors.centerIn: parent
                    text: lang?.bluetooth?.pairing || "Đang ghép nối..."
                    color: theme.primary.foreground
                    font.pixelSize: 14
                    font.weight: Font.Bold
                }
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 12
                opacity: modelData?.pairing ? 0.7 : 1.0

                Rectangle {
                    width: 46
                    height: 46
                    radius: 23
                    color: modelData?.connected ? theme.normal.blue : theme.button.background

                    scale: deviceMouseArea.containsMouse ? 1.05 : 1.0
                    Behavior on scale { NumberAnimation { duration: 200 } }
                    Behavior on color { ColorAnimation { duration: 200 } }

                    Text {
                        anchors.centerIn: parent
                        text: getDeviceIcon(modelData?.icon || "")
                        color: theme.primary.foreground
                        font.pixelSize: 20

                        rotation: deviceMouseArea.containsMouse ? 5 : 0
                        Behavior on rotation { NumberAnimation { duration: 200 } }
                    }

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

                ColumnLayout {
                    spacing: 4
                    Layout.fillWidth: true

                    Text {
                        text: modelData?.name || modelData?.deviceName || modelData?.address || "Unknown"
                        color: deviceMouseArea.containsMouse ? theme.primary.bright_foreground : theme.primary.foreground
                        font.pixelSize: 14
                        font.weight: deviceMouseArea.containsMouse ? Font.Bold : Font.Medium
                        elide: Text.ElideRight
                        Layout.fillWidth: true

                        scale: deviceMouseArea.containsMouse ? 1.02 : 1.0
                        Behavior on scale { NumberAnimation { duration: 200 } }
                        Behavior on color { ColorAnimation { duration: 200 } }
                    }

                    Row {
                        spacing: 8

                        Text {
                            text: {
                                if (modelData?.connecting) return lang?.bluetooth?.connecting || "Đang kết nối..."
                                if (modelData?.connected) return lang?.bluetooth?.connected || "Đã kết nối"
                                if (modelData?.paired) return lang?.bluetooth?.paired || "Đã ghép nối"
                                return lang?.bluetooth?.not_connected || "Không kết nối"
                            }
                            color: {
                                if (modelData?.connected) return theme.normal.green
                                if (modelData?.paired) return theme.normal.yellow
                                return theme.primary.dim_foreground
                            }
                            font.pixelSize: 11

                            opacity: deviceMouseArea.containsMouse ? 1.0 : 0.8
                            Behavior on opacity { NumberAnimation { duration: 200 } }
                        }

                        Text {
                            visible: modelData?.batteryAvailable && modelData?.battery > 0
                            text: `🔋 ${Math.round((modelData?.battery || 0) * 100)}%`
                            color: theme.primary.dim_foreground
                            font.pixelSize: 11

                            opacity: deviceMouseArea.containsMouse ? 1.0 : 0.8
                            Behavior on opacity { NumberAnimation { duration: 200 } }
                        }
                    }
                }

                Row {
                    spacing: 6

                    Rectangle {
                        id: connectButton
                        width: 32
                        height: 32
                        radius: 8
                        color: modelData?.connected ? theme.normal.red :
                               modelData?.paired ? theme.normal.blue : theme.button.background
                        opacity: (modelData?.paired || modelData?.connecting) ? 1 : 0.5
                        enabled: !modelData?.pairing

                        scale: connectMouseArea.containsPress ? 0.9 : (connectMouseArea.containsMouse ? 1.1 : 1.0)
                        Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }
                        Behavior on color { ColorAnimation { duration: 200 } }

                        Text {
                            anchors.centerIn: parent
                            text: modelData?.connecting ? "🔄" :
                                  modelData?.connected ? "🔌" : "🔗"
                            color: theme.primary.foreground
                            font.pixelSize: 14

                            rotation: modelData?.connecting ? 360 : 0
                            RotationAnimator on rotation {
                                running: modelData?.connecting || false
                                from: 0
                                to: 360
                                duration: 1000
                                loops: Animation.Infinite
                            }
                        }

                        MouseArea {
                            id: connectMouseArea
                            anchors.fill: parent
                            enabled: parent.enabled
                            hoverEnabled: true
                            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                            onClicked: {
                                if (modelData?.connected) {
                                    modelData.disconnect()
                                } else if (modelData?.paired && !modelData?.connecting) {
                                    modelData.connect()
                                }
                            }
                        }
                    }

                    Rectangle {
                        id: pairButton
                        width: 32
                        height: 32
                        radius: 8
                        color: modelData?.pairing ? theme.normal.yellow :
                               modelData?.paired ? theme.normal.red : theme.normal.blue
                        opacity: modelData?.pairing ? 0.8 : 1
                        enabled: !modelData?.pairing

                        scale: pairMouseArea.containsPress ? 0.9 : (pairMouseArea.containsMouse ? 1.1 : 1.0)
                        Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }
                        Behavior on color { ColorAnimation { duration: 200 } }

                        Text {
                            anchors.centerIn: parent
                            text: modelData?.pairing ? "⏳" :
                                  modelData?.paired ? "🗑️" : "👥"
                            color: theme.primary.foreground
                            font.pixelSize: 14

                            scale: pairMouseArea.containsMouse ? 1.2 : 1.0
                            Behavior on scale { NumberAnimation { duration: 200 } }
                        }

                        MouseArea {
                            id: pairMouseArea
                            anchors.fill: parent
                            enabled: parent.enabled && !modelData?.connected
                            hoverEnabled: true
                            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                            onClicked: {
                                if (modelData?.paired) {
                                    modelData.forget()
                                } else {
                                    // Đảm bảo adapter ở chế độ có thể ghép nối
                                    if (adapter) {
                                        adapter.pairable = true
                                        adapter.discoverable = true
                                    }

                                    // Thử ghép nối
                                    try {
                                        modelData.pair()
                                    } catch (error) {
                                        pairErrorMessage = lang?.bluetooth?.pair_error || "Không thể ghép nối với thiết bị"
                                        errorMessageTimer.restart()
                                    }
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
            
            // Theo dõi thay đổi trạng thái thiết bị
            Connections {
                target: modelData
                function onPairingChanged() {}
                function onPairedChanged() {}
            }
        }
    }

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

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            color: theme.primary.background
            radius: 16
            border.color: theme.normal.black
            border.width: 3

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 6

                Rectangle {
                    Layout.fillWidth: true
                    height: 100
                    radius: 12
                    color: theme.primary.background

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 12

                        Rectangle {
                            width: 64
                            height: 64
                            radius: 20
                            color: theme.primary.background

                            Image {
                                source: "../../assets/settings/bluetooth.png"
                                width: 64
                                height: 64
                                sourceSize: Qt.size(64, 64)
                                anchors.centerIn: parent
                            }
                        }
                        

                        ColumnLayout {
                            spacing: 4
                            Layout.fillWidth: true

                            Text {
                                text: "Bluetooth"
                                color: theme.primary.foreground
                                font.pixelSize: 40
                                font.family: "ComicShannsMono Nerd Font"
                                font.weight: Font.Bold
                            }
                        }
                                Item { Layout.fillWidth: true }

                        
                        Rectangle {
                            id: scanButton
                            Layout.preferredWidth: 55
                            Layout.preferredHeight: 55
                            radius: 27.5
                            visible: adapter?.enabled || false
                            color: {
                                if (adapter?.discovering) return theme.normal.red
                                if (scanButtonMouse.containsMouse) return theme.normal.blue
                                return theme.primary.dim_foreground
                            }

                            scale: scanButtonMouse.containsPress ? 0.95 : (scanButtonMouse.containsMouse ? 1.1 : 1.0)
                            Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                            Behavior on color { ColorAnimation { duration: 200 } }

                            Image {
                                source: "../../assets/search.png"
                                width: 40
                                height: 40
                                sourceSize: Qt.size(40, 40)
                                anchors.centerIn: parent
                            }

                            Rectangle {
                                anchors.fill: parent
                                radius: 27.5
                                color: "transparent"
                                border.width: 2
                                border.color: theme.normal.green
                                visible: adapter?.discovering || false
                                rotation: scanRotation

                                RotationAnimator on rotation {
                                    id: scanRotation
                                    from: 0
                                    to: 360
                                    duration: 1000
                                    loops: Animation.Infinite
                                    running: adapter?.discovering || false
                                }

                                Rectangle {
                                    width: 4
                                    height: 4
                                    radius: 2
                                    color: theme.normal.green
                                    anchors.top: parent.top
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.topMargin: -2
                                }
                            }

                            MouseArea {
                                id: scanButtonMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (adapter) {
                                        if (adapter.discovering) {
                                            adapter.discovering = false
                                            scanTimer.stop()
                                        } else {
                                            adapter.discovering = true
                                            scanTimer.restart()

                                            // Đảm bảo adapter ở chế độ có thể phát hiện
                                            adapter.discoverable = true
                                            adapter.pairable = true
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Thông báo lỗi
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

                Rectangle {
                    id: statusCard
                    Layout.fillWidth: true
                    height: 82
                    radius: 12
                    color: theme.primary.dim_background
                    border.width: 3
                    border.color: theme.normal.black

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 14
                        spacing: 12

                        // Column bên trái: trạng thái và số thiết bị
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4

                            Text {
                                text: adapter?.enabled ? (lang?.bluetooth?.enabled || "Bluetooth đang bật") : (lang?.bluetooth?.disabled || "Bluetooth đang tắt")
                                color: adapter?.enabled ? theme.normal.blue : theme.primary.dim_foreground
                                font.pixelSize: 20
                                font.family: "ComicShannsMono Nerd Font"
                                font.bold: true

                                Behavior on color { ColorAnimation { duration: 200 } }
                            }

                            Text {
                                text: `${connectedCount} ` + (lang?.bluetooth?.devices_connected || "thiết bị đã kết nối")
                                color: theme.primary.dim_foreground
                                font.pixelSize: 16
                                font.family: "ComicShannsMono Nerd Font"
                                visible: adapter?.enabled || false
                            }
                        }
                        Item { Layout.fillWidth: true }

                        // Nút bật/tắt bluetooth
                        Rectangle {
                            width: 56
                            height: 32
                            radius: 16
                            color: adapter?.enabled ? theme.normal.blue : theme.button.background
                            opacity: adapter ? 1 : 0.5

                            scale: toggleMouseArea.containsPress ? 0.95 : (toggleMouseArea.containsMouse ? 1.05 : 1.0)
                            Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }
                            Behavior on color { ColorAnimation { duration: 300 } }

                            Rectangle {
                                x: adapter?.enabled ? parent.width - width - 4 : 4
                                y: 4
                                width: 24
                                height: 24
                                radius: 12
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
                                            // Khi bật Bluetooth, đặt các chế độ cần thiết
                                            adapter.pairable = true
                                            adapter.discoverable = true
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
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

                                delegate: deviceDelegate

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
    
    // Theo dõi thay đổi của adapter
    Connections {
        target: adapter
        enabled: !!adapter
        function onEnabledChanged() {
            if (adapter?.enabled) {
                // Khi bật adapter, đặt chế độ mặc định
                adapter.pairable = true
                adapter.discoverable = false // Mặc định không hiển thị
            }
        }
        function onDiscoveringChanged() {}
        function onDiscoverableChanged() {}
        function onPairableChanged() {}
    }

    // Theo dõi thay đổi danh sách thiết bị
    Connections {
        target: Bluetooth
        function onDevicesChanged() {}
    }

    Component.onCompleted: {
        // Đảm bảo adapter ở chế độ có thể ghép nối khi khởi động
        if (adapter && adapter.enabled) {
            adapter.pairable = true
        }
    }
}
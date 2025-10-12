import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io



Rectangle {
    id: root
    property string hyprInstance: ""
    property var workspaces: []
    property string activeWorkspace: "1"
    property string status: "Đang khởi động..."

    color: "#F5EEE6"
    radius: 8

    // Socket theo dõi sự kiện từ Hyprland
    Socket {
        id: hyprEvents
        path: root.hyprInstance ? `/run/user/1000/hypr/${root.hyprInstance}/.socket2.sock` : ""
        connected: !!root.hyprInstance
        
        onConnectedChanged: if (connected) initializeWorkspaces()

        parser: SplitParser {
            onRead: msg => {
                if (msg.startsWith("workspace>>")) {
                    const parts = msg.split(">>")[1].split(",")
                    if (parts.length > 0) root.activeWorkspace = parts[0]
                } else if (msg.startsWith("focusedmon>>")) {
                    const parts = msg.split(">>")[1].split(",")
                    if (parts.length > 1) root.activeWorkspace = parts[1]
                } else if (msg.startsWith("createworkspace>>")) {
                    const parts = msg.split(">>")[1].split(",")
                    if (parts.length > 0) addWorkspace(parts[0])
                }
            }
        }

        onError: initializeWorkspaces()
    }

    // Socket điều khiển Hyprland
    Socket {
        id: hyprControl
        path: root.hyprInstance ? `/run/user/1000/hypr/${root.hyprInstance}/.socket2.sock` : ""
        connected: !!root.hyprInstance
    }

    // Khởi tạo workspace 1–10
    function initializeWorkspaces() {
        root.workspaces = []
        for (let i = 1; i <= 10; i++) {
            root.workspaces.push({
                id: i.toString(),
                name: i.toString(),
                windows: 0,
                monitor: "eDP-1",
                exists: true
            })
        }
    }

    function ensureWorkspaceExists(workspaceId) {
        let exists = root.workspaces.some(ws => ws.id === workspaceId)
        if (!exists) {
            root.workspaces.push({
                id: workspaceId,
                name: workspaceId,
                windows: 0,
                monitor: "eDP-1",
                exists: true
            })
            root.workspaces.sort((a, b) => parseInt(a.id) - parseInt(b.id))
            root.workspaces = root.workspaces.slice()
        }
    }

    function addWorkspace(workspaceId) {
        ensureWorkspaceExists(workspaceId)
    }

    function switchWorkspace(workspaceId) {
        if (hyprControl.connected)
            hyprControl.write(`dispatch workspace ${workspaceId}`)
        root.activeWorkspace = workspaceId
        ensureWorkspaceExists(workspaceId)
    }

    // Indicator hiển thị workspace đang active
    Image {
        id: activeIndicator
        width: 40
        height: 40
        source: "./assets/pacman.png"
        smooth: true
        antialiasing: true
        fillMode: Image.PreserveAspectFit
        z: 1
        x: {
            for (let i = 0; i < workspaceRow.children.length; i++) {
                const child = workspaceRow.children[i]
                if (child.workspaceId === root.activeWorkspace)
                    return child.x + (child.width - width) / 2 + 20
            }
            return 0
        }
        y: (parent.height - height) / 2
        Behavior on x {
            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
        }
    }

    Row {
        id: workspaceRow
        anchors.centerIn: parent
        spacing: 8

        Repeater {
            model: root.workspaces

            Rectangle {
                property string workspaceId: modelData.id
                width: 32
                height: 32
                radius: 6
                color: "transparent"
                opacity: modelData.exists ? 1.0 : 0.4

                Image {
                    anchors.centerIn: parent
                    source: modelData.windows > 0 ? "./assets/empty.png" : "./assets/empty.png"
                    width: 40
                    height: 40
                    fillMode: Image.PreserveAspectFit
                    visible: modelData.id !== root.activeWorkspace
                    smooth: false
                    antialiasing: false
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.switchWorkspace(modelData.id)
                }
            }
        }
    }

    // Hiển thị trạng thái (ẩn khi Hyprland có instance)
    Text {
        anchors.centerIn: parent
        text: {
            if (!root.hyprInstance) return "Hyprland không chạy"
            return `Workspaces: ${root.workspaces.filter(ws => ws.exists).length}/${root.workspaces.length}`
        }
        color: "black"
        font.pixelSize: 12
        visible: !root.hyprInstance || root.workspaces.length === 0
    }

    Component.onCompleted: {
        if (!root.hyprInstance) initializeWorkspaces()
    }

    // Timer giả lập cập nhật số cửa sổ
    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: {
            for (let i = 0; i < root.workspaces.length; i++) {
                if (root.workspaces[i].exists && Math.random() > 0.6) {
                    const change = Math.random() > 0.5 ? 1 : -1
                    root.workspaces[i].windows = Math.max(0, root.workspaces[i].windows + change)
                }
            }
            root.workspaces = root.workspaces.slice()
        }
    }
}


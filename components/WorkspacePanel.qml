import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Rectangle {
    id: root
    radius: 10
    border.color: theme.normal.black
    border.width: 3
    color: theme.primary.background

    property string hyprInstance: ""
    property var workspaces: []
    property string activeWorkspace: "1"
    property var existingWorkspaces: ([])
    property string currentWorkspaceId: ""
    property var theme : currentTheme

    // Socket theo dõi Hyprland
    Socket {
        id: hyprEvents
        path: root.hyprInstance ? `/run/user/1000/hypr/${root.hyprInstance}/.socket2.sock` : ""
        connected: !!root.hyprInstance

        onConnectedChanged: {
            if (connected) {
                initializeWorkspaces()
                updateWorkspaceStatus()
            }
        }

        parser: SplitParser {
            onRead: msg => {
                
                if (msg.startsWith("workspace>>")) {
                    const parts = msg.split(">>")[1].split(",")
                    if (parts.length > 0) {
                        root.activeWorkspace = parts[0]
                        markWorkspaceExists(root.activeWorkspace)
                    }
                } else if (msg.startsWith("focusedmon>>")) {
                    const parts = msg.split(">>")[1].split(",")
                    if (parts.length > 1) {
                        root.activeWorkspace = parts[1]
                        markWorkspaceExists(root.activeWorkspace)
                    }
                } else if (msg.startsWith("createworkspace>>")) {
                    const parts = msg.split(">>")[1].split(",")
                    if (parts.length > 0) {
                        const newWorkspace = parts[0]
                        markWorkspaceExists(newWorkspace)
                    }
                } else if (msg.startsWith("destroyworkspace>>")) {
                    const parts = msg.split(">>")[1].split(",")
                    if (parts.length > 0) {
                        const destroyedWorkspace = parts[0]
                        // Vẫn giữ workspace trong UI nhưng đánh dấu không tồn tại
                        unmarkWorkspaceExists(destroyedWorkspace)
                    }
                } else if (msg.startsWith("openwindow>>") || msg.startsWith("closewindow>>")) {
                    // Cập nhật trạng thái cửa sổ
                    updateWorkspaceStatus()
                }
            }
        }

    }

    Socket {
        id: hyprControl
        path: root.hyprInstance ? `/run/user/1000/hypr/${root.hyprInstance}/.socket2.sock` : ""
        connected: !!root.hyprInstance
    }

    Process {
        id: hyprctlProcess
        command: ["hyprctl", "workspaces", "-j"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                if (this.text) {
                    try {
                        const wsList = JSON.parse(this.text)
                        const existingIds = wsList.map(ws => ws.id.toString())
                        root.existingWorkspaces = existingIds

                        for (let i = 0; i < root.workspaces.length; i++) {
                            const ws = root.workspaces[i]
                            const shouldExist = existingIds.includes(ws.id) || ws.id === root.activeWorkspace
                            if (ws.exists !== shouldExist) {
                                root.workspaces[i].exists = shouldExist
                            }
                        }
                        root.workspaces = root.workspaces.slice()
                    } catch(e) {
                        console.warn("❌ Failed to parse hyprctl JSON:", e)
                    }
                }
            }
        }
    }

    Process {
        id: workspaceSwitcher
        // Remove the onFinished handler - Process doesn't have this signal
    }

    function initializeWorkspaces() {
        root.workspaces = []
        for (let i = 1; i <= 10; i++) {
            root.workspaces.push({
                id: i.toString(),
                name: i.toString(),
                windows: 0,
                monitor: "eDP-1",
                exists: false
            })
        }
    }

    function markWorkspaceExists(workspaceId) {
        let found = false
        for (let i = 0; i < root.workspaces.length; i++) {
            if (root.workspaces[i].id === workspaceId) {
                if (!root.workspaces[i].exists) {
                    root.workspaces[i].exists = true
                }
                found = true
                break
            }
        }
        
        if (!found) {
            // Thêm workspace mới nếu chưa có trong danh sách
            root.workspaces.push({
                id: workspaceId,
                name: workspaceId,
                windows: 0,
                monitor: "eDP-1",
                exists: true
            })
            root.workspaces.sort((a, b) => parseInt(a.id) - parseInt(b.id))
        }
        
        root.workspaces = root.workspaces.slice()
    }

    function unmarkWorkspaceExists(workspaceId) {
        for (let i = 0; i < root.workspaces.length; i++) {
            if (root.workspaces[i].id === workspaceId) {
                root.workspaces[i].exists = false
                break
            }
        }
        root.workspaces = root.workspaces.slice()
    }

    function switchWorkspace(workspaceId) {
        currentWorkspaceId = workspaceId
        workspaceSwitcher.command = ["hyprctl", "dispatch", "workspace", workspaceId]
        workspaceSwitcher.running = true
        
        // Update active workspace immediately since we can't use onFinished
        root.activeWorkspace = workspaceId
        markWorkspaceExists(workspaceId)
    }

    function updateWorkspaceStatus() {
        if (hyprctlProcess.running) {
            hyprctlProcess.kill()
        }
        hyprctlProcess.running = true
    }

    // Pacman indicator cho workspace active
    Image {
        id: activeIndicator
        width: 40
        height: 40
        source: "../assets/pacman.png"
        smooth: true
        antialiasing: true
        fillMode: Image.PreserveAspectFit
        z: 2 // Đảm bảo pacman ở trên cùng
        x: {
            for (let i = 0; i < workspaceRow.children.length; i++) {
                const child = workspaceRow.children[i]
                if (child.workspaceId === root.activeWorkspace) {
                    return child.x + (child.width - width) / 2 + 20
                }
            }
            return 20
        }
        y: (parent.height - height) / 2
        Behavior on x { 
            NumberAnimation { 
                duration: 300; 
                easing.type: Easing.OutCubic 
            } 
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

                // Icon workspace
                Image {
                    anchors.centerIn: parent
                    width: 40
                    height: 40
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    antialiasing: true
                    source: modelData.exists ? "../assets/ghost.png" : "../assets/empty.png"
                    opacity: modelData.id === root.activeWorkspace ? 0 : 1 // Ẩn khi active (vì có pacman)
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.switchWorkspace(modelData.id)
                    
                    // Hiệu ứng hover
                    onEntered: {
                        if (parent.workspaceId !== root.activeWorkspace) {
                            parent.scale = 1.1
                        }
                    }
                    onExited: {
                        if (parent.workspaceId !== root.activeWorkspace) {
                            parent.scale = 1.0
                        }
                    }
                }
                
                Behavior on scale { NumberAnimation { duration: 100 } }
            }
        }
    }

    Component.onCompleted: {
        if (root.hyprInstance) {
            console.log("📝 Hyprland Instance:", root.hyprInstance)
        } else {
            console.log("❌ No Hyprland instance found")
            initializeWorkspaces()
        }
    }

    // Timer refresh workspace status
    Timer {
        interval: 2000
        running: root.hyprInstance !== ""
        repeat: true
        onTriggered: updateWorkspaceStatus()
    }
}

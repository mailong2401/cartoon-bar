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

    property var theme: currentTheme
    property string hyprInstance: ""
    property var workspaces: []
    property string activeWorkspace: "1"

    // ✅ Socket Hyprland - realtime event
    Socket {
        id: hyprEvents
        path: `${Quickshell.env("XDG_RUNTIME_DIR")}/hypr/${root.hyprInstance}/.socket2.sock`
        connected: !!root.hyprInstance

        onConnectedChanged: if (connected) { initWorkspaces(); updateStatus() }

        parser: SplitParser {
            onRead: msg => {
                const data = msg.split(">>")[1]?.split(",") || []
                if (msg.startsWith("workspace>>") || msg.startsWith("focusedmon>>"))
                    root.activeWorkspace = data[0] || data[1]
                else if (msg.startsWith("createworkspace>>"))
                    markExists(data[0])
                else if (msg.startsWith("destroyworkspace>>"))
                    markExists(data[0], false)
                else if (msg.startsWith("openwindow>>") || msg.startsWith("closewindow>>"))
                    updateStatus()
            }
        }
    }

    // ✅ Lấy trạng thái workspace từ hyprctl
    Process {
        id: hyprctl
        command: ["hyprctl", "workspaces", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const list = JSON.parse(text)
                    const ids = list.map(ws => ws.id.toString())
                    root.workspaces.forEach(ws => ws.exists = ids.includes(ws.id))
                    root.workspaces = root.workspaces.slice()
                } catch(e) { }
            }
        }
    }

    // ✅ Chuyển workspace
    function switchWs(id) {
        Qt.createQmlObject(`
            import Quickshell.Io
            Process { command: ["hyprctl", "dispatch", "workspace", "${id}"]; running: true }
        `, root)
        root.activeWorkspace = id
        markExists(id)
    }

    // ✅ Khởi tạo workspace 1–10
    function initWorkspaces() {
        root.workspaces = Array.from({length: 10}, (_, i) => ({
            id: (i + 1).toString(),
            exists: false
        }))
    }

    // ✅ Đánh dấu workspace có/không tồn tại
    function markExists(id, state = true) {
        const ws = root.workspaces.find(w => w.id === id)
        if (ws) ws.exists = state
        else root.workspaces.push({ id, exists: state })
        root.workspaces.sort((a,b) => a.id - b.id)
        root.workspaces = root.workspaces.slice()
    }

    // ✅ Refresh hyprctl
    function updateStatus() {
        if (hyprctl.running) hyprctl.kill()
        hyprctl.running = true
    }


    // 🧱 Dòng workspace
    Row {
        id: workspaceRow
        anchors.centerIn: parent
        spacing: 4

        Repeater {
            model: root.workspaces
            Rectangle {
                property string wsId: modelData.id
                width: 32; height: 32; radius: 6
                color: "transparent"

                Image {
      anchors.centerIn: parent
    width: 32; height: 32
    fillMode: Image.PreserveAspectFit
    source: modelData.id === root.activeWorkspace
        ? "../assets/pacman.png"
        : modelData.exists
            ? "../assets/ghost.png"
            : "../assets/empty.png"
            opacity: 1
        }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.switchWs(modelData.id)
                    onEntered: if (wsId !== root.activeWorkspace) parent.scale = 1.1
                    onExited: if (wsId !== root.activeWorkspace) parent.scale = 1.0
                }

                Behavior on scale { NumberAnimation { duration: 100 } }
            }
        }
    }

    Component.onCompleted: {
        initWorkspaces()
        updateStatus()
    }
}


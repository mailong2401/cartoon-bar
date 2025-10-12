import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root
    
    property string hyprInstance: ""
    property var workspaces: []
    property string activeWorkspace: "1"
    
    signal workspacesUpdated()
    signal activeWorkspaceChanged(string workspaceId)
    
    // Socket để theo dõi sự kiện từ Hyprland
    Socket {
        id: hyprEvents
        path: root.hyprInstance ? `/run/user/1000/hypr/${root.hyprInstance}/.socket2.sock` : ""
        connected: !!root.hyprInstance
        
        parser: SplitParser {
            onRead: msg => {
                if (msg.startsWith("workspace>>")) {
                    const parts = msg.split(">>")[1].split(",")
                    if (parts.length > 0) {
                        root.activeWorkspace = parts[0]
                        root.activeWorkspaceChanged(root.activeWorkspace)
                    }
                }
                else if (msg.startsWith("focusedmon>>")) {
                    const parts = msg.split(">>")[1].split(",")
                    if (parts.length > 1) {
                        root.activeWorkspace = parts[1]
                        root.activeWorkspaceChanged(root.activeWorkspace)
                    }
                }
            }
        }
    }
    
    // Socket để điều khiển
    Socket {
        id: hyprControl
        path: root.hyprInstance ? `/run/user/1000/hypr/${root.hyprInstance}/.socket2.sock` : ""
        connected: !!root.hyprInstance
    }
    
    function switchWorkspace(workspaceId) {
        if (hyprControl.connected) {
            hyprControl.write(`dispatch workspace ${workspaceId}`)
        }
    }
}

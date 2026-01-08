import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Rectangle {
    id: container
    radius: currentSizes.launcherPanel?.radius || currentSizes.radius?.normal || 12
    color: theme.primary.dim_background
    border.color: theme.normal.black
    border.width: 2

    property var apps: []
    property string lastQuery: ""
    property var theme : currentTheme
    property int currentIndex: 0


    signal appLaunched()

    ColumnLayout {
        id: rootLayout
        anchors.fill: parent
        anchors.margins: currentSizes.launcherPanel?.listLayoutMargins || 8
        spacing: currentSizes.launcherPanel?.spacing || 6

        Process {
            id: listApps
            running: false
            stdout: StdioCollector { id: outputCollector }

            onExited: {
                try {
                    var txt = outputCollector.text ? outputCollector.text.trim() : ""
                    if (txt !== "") {
                        container.apps = JSON.parse(txt)
                    } else {
                        container.apps = []
                    }
                } catch(e) {
                    container.apps = []
                }
            }
        }

        Component.onCompleted: {
            runSearch("")
        }

        ListView {
    id: appList
    Layout.fillWidth: true
    Layout.fillHeight: true
    clip: true
    spacing: currentSizes.launcherPanel?.listSpacing || 4
    model: container.apps
    currentIndex: container.currentIndex
    focus: true
    keyNavigationWraps: true

    delegate: Rectangle {
        width: ListView.view.width
        height: currentSizes.launcherPanel?.listItemHeight || 56
        radius: currentSizes.launcherPanel?.listItemRadius || 8
        color: (ListView.isCurrentItem || mouseArea.containsMouse)
               ? theme.button.background_select
               : "transparent"
        border.color: (ListView.isCurrentItem || mouseArea.containsMouse)
                      ? theme.button.border_select
                      : "transparent"
        border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.margins: currentSizes.launcherPanel?.listItemMargins || 8
            spacing: currentSizes.launcherPanel?.listItemSpacing || 10

            Image {
                Layout.preferredWidth: currentSizes.launcherPanel?.listItemIconSize || 36
                        Layout.preferredHeight: currentSizes.launcherPanel?.listItemIconSize || 36
                fillMode: Image.PreserveAspectFit
                source: modelData.iconPath || ""
                asynchronous: true
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                Text {
                    text: modelData.name || "Unknown"
                    color: theme.primary.foreground
                    font.family: "ComicShannsMono Nerd Font"
                    font.pixelSize: currentSizes.launcherPanel?.listItemTitleFontSize || 20
                    elide: Text.ElideRight
                }

                Text {
                    text: modelData.comment || ""
                    color: theme.primary.bright_foreground
                    font.family: "ComicShannsMono Nerd Font"
                    font.pixelSize: currentSizes.launcherPanel?.listItemCommentFontSize || 13
                    elide: Text.ElideRight
                }
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                var item = modelData
                if (item && item.exec) {
                    container.launchApplication(item.exec)
                    container.appLaunched()
                }
            }
            onEntered: {
                if (ListView.view) {
                    ListView.view.currentIndex = index
                }
            }
        }
    }

    }


        Text {
            visible: container.apps.length === 0
            text: "Không có kết quả"
            color: "#777"
            font.pixelSize: currentSizes.fontSize?.normal || 14
            font.family: "ComicShannsMono Nerd Font"
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }
    }

    function runSearch(query) {
        if (query === undefined || query === null) query = ""
        if (query === container.lastQuery && container.apps.length > 0) {
            return
        }
        container.lastQuery = query

        if (query.length > 0) {
            listApps.command = [Qt.resolvedUrl("../../../scripts/listapps.py"),query]
        } else {
            listApps.command = [Qt.resolvedUrl("../../../scripts/listapps.py")]
        }

        try { listApps.running = false } catch(e) {}
        listApps.running = true
    }

    function _splitArgs(cmd) {
        var parts = []
        var re = /"([^"]*)"|'([^']*)'|([^ \t"']+)/g
        var m
        while ((m = re.exec(cmd)) !== null) {
            if (m[1] !== undefined) parts.push(m[1])
            else if (m[2] !== undefined) parts.push(m[2])
            else if (m[3] !== undefined) parts.push(m[3])
        }
        return parts
    }

    function launchApplication(execStrOrItem) {
        try {
            var execStr = ""
            if (typeof execStrOrItem === "object" && execStrOrItem !== null) {
                execStr = execStrOrItem.exec || execStrOrItem.command && execStrOrItem.command.join(" ") || ""
            } else if (typeof execStrOrItem === "string") {
                execStr = execStrOrItem
            } else {
                return
            }

            if (!execStr || execStr.trim() === "") {
                return
            }

            execStr = execStr.replace(/%[fFuUdDinkcK%]/g, "").trim()
            var cmdArray = _splitArgs(execStr)

            if (!cmdArray || cmdArray.length === 0) {
                return
            }

            Quickshell.execDetached(cmdArray)
        } catch (err) {
        }
    }

    Shortcut {
        sequence: "Tab"
        onActivated: {
          container.currentIndex = (container.currentIndex + 1) % container.apps.length
          appList.currentIndex = container.currentIndex
        }
      }
      Shortcut {
        sequence: "Up"
        onActivated: {
          container.currentIndex = Math.max(container.currentIndex - 1, 0)
            appList.currentIndex = container.currentIndex
        }
      }
      Shortcut {
        sequence: "Down"
        onActivated: {
          container.currentIndex = (container.currentIndex + 1) % container.apps.length
          appList.currentIndex = container.currentIndex
        }
      }
      Shortcut {
    sequence: "Return"    // hoặc "Enter" đều được
    onActivated: {
                var item = container.apps[container.currentIndex]
                container.launchApplication(item.exec)
                container.appLaunched()
    }
}

}

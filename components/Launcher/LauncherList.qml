import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Rectangle {
    id: container
    radius: 12
    color: "#E8D8C9"
    border.color: "#4f4f5b"
    border.width: 2

    // apps được giữ trên root để parent/instance có thể truy cập nếu cần
    property var apps: []
    property string lastQuery: ""

    signal appLaunched()


    ColumnLayout {
        id: rootLayout
        anchors.fill: parent
        anchors.margins: 8
        spacing: 6

        // Process được khai báo ở root scope (id listApps), để runSearch điều khiển
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
                    console.error("Parse error:", e, "\nOutput was:", outputCollector.text)
                    container.apps = []
                }
            }
        }

        // Mặc định load khi component khởi tạo
        Component.onCompleted: {
            // chạy load ban đầu (không tham số)
            runSearch("")
        }

        // LISTVIEW
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 4
            model: container.apps

            delegate: Rectangle {
                width: ListView.view.width
                height: 56
                radius: 8
                color: mouseArea.containsMouse ? "#d6ccc2" : "transparent"
                border.color: mouseArea.containsMouse ? "#4f4f5b" : "transparent"
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 10

                    Image {
                        Layout.preferredWidth: 36
                        Layout.preferredHeight: 36
                        fillMode: Image.PreserveAspectFit
                        source: container.apps[index].iconPath
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2

                        Text {
                            text: container.apps[index].name
                            color: "black"
                            font.family: "ComicShannsMono Nerd Font"
                            font.pixelSize: 20
                            elide: Text.ElideRight
                        }

                        Text {
                            text: container.apps[index].comment || ""
                            color: "#555"
                            font.family: "ComicShannsMono Nerd Font"
                            font.pixelSize: 13
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
                        var item = container.apps[index]
                        if (item && item.exec) {
                            console.log("Launching:", item.name, "->", item.exec)
                            launchApplication(item.exec)

                            container.appLaunched()
                        } else {
                            console.warn("No exec for", item ? item.name : index)
                        }
                    }
                }
            }
        }

        // Empty state
        Text {
            visible: container.apps.length === 0
            text: "Không có kết quả"
            color: "#777"
            font.pixelSize: 14
            font.family: "ComicShannsMono Nerd Font"
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }
    }

    /*
     * PUBLIC API:
     * runSearch(query) -- chạy script listapps.py [query] và cập nhật container.apps
     */
    function runSearch(query) {
        if (query === undefined || query === null) query = ""
        // tránh gọi lại nếu query giống trước và đã có kết quả
        if (query === container.lastQuery && container.apps.length > 0) {
            return
        }
        container.lastQuery = query

        var script = "scripts/listapps.py"
        if (query.length > 0) {
            listApps.command = ["python3", script, query]
        } else {
            listApps.command = ["python3", script]
        }

        // khởi chạy lại process
        try { listApps.running = false } catch(e) {}
        listApps.running = true
      }
      function _splitArgs(cmd) {
    // split giữ nguyên phần trong "..." hoặc '...'
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
            // nếu truyền object (model), lấy trường exec ưu tiên
            execStr = execStrOrItem.exec || execStrOrItem.command && execStrOrItem.command.join(" ") || ""
        } else if (typeof execStrOrItem === "string") {
            execStr = execStrOrItem
        } else {
            console.warn("launchApplication: invalid argument", execStrOrItem)
            return
        }

        if (!execStr || execStr.trim() === "") {
            console.warn("launchApplication: empty exec string")
            return
        }

        // Loại bỏ field codes (an toàn)
        execStr = execStr.replace(/%[fFuUdDinkcK%]/g, "").trim()

        // Tách args
        var cmdArray = _splitArgs(execStr)

        if (!cmdArray || cmdArray.length === 0) {
            console.warn("launchApplication: cannot parse command:", execStr)
            return
        }

        // Debug
        console.log("launchApplication ->", JSON.stringify(cmdArray))

        // Thực thi không chặn
        Quickshell.execDetached(cmdArray, "")
    } catch (err) {
        console.error("launchApplication error:", err)
    }
    }
}


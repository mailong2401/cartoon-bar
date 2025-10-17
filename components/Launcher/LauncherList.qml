import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Rectangle {
    id: container
    radius: 12
    color: theme.primary.dim_background
    border.color: theme.normal.black
    border.width: 2

    property var apps: []
    property string lastQuery: ""
    property var theme : currentTheme

    signal appLaunched()

    ColumnLayout {
        id: rootLayout
        anchors.fill: parent
        anchors.margins: 8
        spacing: 6

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

        Component.onCompleted: {
            runSearch("")
        }

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
                color: mouseArea.containsMouse ? theme.button.background_select : "transparent"
                border.color: mouseArea.containsMouse ? theme.button.border_select : "transparent"
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 10

                    Image {
                        Layout.preferredWidth: 36
                        Layout.preferredHeight: 36
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
                            font.pixelSize: 20
                            elide: Text.ElideRight
                        }

                        Text {
                            text: modelData.comment || ""
                            color: theme.primary.bright_foreground
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
                        var item = modelData
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

function runSearch(query) {
    // --- Nếu query rỗng hoặc null ---
    if (!query)
        query = ""

    // --- Nếu giống truy vấn trước và đã có kết quả, bỏ qua ---
    if (query === container.lastQuery && container.apps.length > 0)
        return

    container.lastQuery = query

    // --- Lấy đường dẫn script tuyệt đối ---
    var scriptPath = Qt.resolvedUrl("../../scripts/listapps.py")

    // --- Kiểm tra xem script có tồn tại không ---
    if (!Qt.resolvedUrl) {
        console.warn("Không thể xác định đường dẫn script listapps.py")
        return
    }

    // --- Gán lệnh chạy ---
    if (query.length > 0)
        listApps.command = ["python3", scriptPath, query]
    else
        listApps.command = ["python3", scriptPath]

    // --- Dừng tiến trình cũ nếu đang chạy ---
    if (listApps.running) {
        try { listApps.running = false } catch(e) {}
    }

    // --- Chạy lại tiến trình ---
    try {
        listApps.running = true
        console.debug("Đang chạy script:", listApps.command.join(" "))
    } catch (e) {
        console.error("Không thể chạy script:", e)
    }
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
                console.warn("launchApplication: invalid argument", execStrOrItem)
                return
            }

            if (!execStr || execStr.trim() === "") {
                console.warn("launchApplication: empty exec string")
                return
            }

            execStr = execStr.replace(/%[fFuUdDinkcK%]/g, "").trim()
            var cmdArray = _splitArgs(execStr)

            if (!cmdArray || cmdArray.length === 0) {
                console.warn("launchApplication: cannot parse command:", execStr)
                return
            }

            console.log("launchApplication ->", JSON.stringify(cmdArray))
            // SỬA LỖI: Chỉ truyền một tham số
            Quickshell.execDetached(cmdArray)
        } catch (err) {
            console.error("launchApplication error:", err)
        }
    }
}

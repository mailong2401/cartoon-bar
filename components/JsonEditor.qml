import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: editor

    property string filePath: ""
    property var json: ({})

    property Timer reloadTimer: Timer {
        interval: 30
        repeat: false
        onTriggered: configLoader.loadConfig()
    }

    // Load file
    function load(path) {
        filePath = path
        var xhr = new XMLHttpRequest()
        xhr.open("GET", filePath, false)
        xhr.send()

        if (xhr.status === 200) {
            try {
                json = JSON.parse(xhr.responseText)
                return json
            } catch(e) {
                return {}
            }
        }
        return {}
    }

    // Lưu file
    function save() {
        var process = Qt.createQmlObject('import Quickshell.Io; Process {}', editor)
        var content = JSON.stringify(json, null, 2)
        var actualPath = filePath.toString().replace("file://", "")

        process.command = ["bash", "-c", "echo '" + content.replace(/'/g, "'\\''") + "' > " + actualPath]
        process.running = true
    }

    // Set giá trị (support path dạng a.b.c)
    function set(path, value) {
        var keys = path.split(".")
        var obj = json

        for (var i = 0; i < keys.length - 1; i++) {
            if (!obj[keys[i]])
                obj[keys[i]] = {}
            obj = obj[keys[i]]
        }

        obj[keys[keys.length - 1]] = value
        save()
        reloadTimer.restart()
    }

    // Get giá trị
    function get(path, fallback) {
        var keys = path.split(".")
        var obj = json

        for (var i = 0; i < keys.length; i++) {
            if (!obj || obj[keys[i]] === undefined)
                return fallback
            obj = obj[keys[i]]
        }
        return obj
    }
}

import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
    id: root

    property int barCount: 64
    property var values: []
    property bool isRunning: false

    Component.onCompleted: {
        initializeValues()
    }

    function initializeValues() {
        let arr = []
        for (let i = 0; i < barCount; i++) {
            arr.push(2)
        }
        values = arr
    }

    property var cavaProc: Process {
        running: false

        command: [
            "sh", "-c",
            `printf '[general]
framerate=30
bars=${root.barCount}
autosens=1
[smoothing]
noise_reduction=50
[output]
method=raw
raw_target=/dev/stdout
data_format=ascii
ascii_max_range=100
bit_format=8bit' | cava -p /dev/stdin`
        ]

        stdout: SplitParser {
            onRead: function(data) {
                let lines = data.split("\n")
                for (let i = 0; i < lines.length; i++) {
                    let line = lines[i].trim()
                    if (line === "") continue

                    try {
                        let newValues = line.split(";")
                            .filter(val => val.trim() !== "")
                            .map(val => {
                                let num = parseInt(val, 10)
                                return isNaN(num) ? 2 : Math.max(2, Math.min(num, 200))
                            })

                        if (newValues.length >= root.barCount) {
                            root.values = newValues.slice(0, root.barCount)
                        }
                    } catch (error) {
                    }
                }
            }
        }

        onRunningChanged: {
            root.isRunning = running
        }
    }

    function open() {
        initializeValues()
        cavaProc.running = true
    }

    function close() {
        cavaProc.running = false
        initializeValues()
    }

    function toggle() {
        if (cavaProc.running) {
            close()
        } else {
            open()
        }
    }
}

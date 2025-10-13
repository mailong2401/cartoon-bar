import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io

Rectangle {
    id: musicPlayer
    color: "#F5EEE6"
    radius: 8

    property string currentSong: "No song playing"
    property string currentArtist: ""
    property bool isPlaying: false

    // Process lấy thông tin bài hát
    Process {
        id: playerctl
        running: false
        command: ["playerctl", "metadata", "--format", "{{artist}} - {{title}}"]

        stdout: StdioCollector {
            onStreamFinished: {
                if (this.text) {
                    var data = this.text.trim()
                    var parts = data.split(" - ")
                    if (parts.length >= 2) {
                        musicPlayer.currentArtist = parts[0]
                        musicPlayer.currentSong = parts[1]
                    } else {
                        musicPlayer.currentSong = data
                        musicPlayer.currentArtist = ""
                    }
                }
            }
        }
    }

    // Process kiểm tra trạng thái phát
    Process {
        id: statusCheck
        running: false
        command: ["playerctl", "status"]

        stdout: StdioCollector {
            onStreamFinished: {
                isPlaying = (this.text.trim() === "Playing")
            }
        }
    }

    // Timer refresh metadata và trạng thái phát
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            if (!playerctl.running) playerctl.running = true
            if (!statusCheck.running) statusCheck.running = true
        }
    }

RowLayout {
    anchors.fill: parent
    anchors.margins: 8
    Layout.alignment: Qt.AlignVCenter  // thay verticalAlignment

    // Song info
    ColumnLayout {
        spacing: 2
        Layout.fillWidth: true

        Text {
            text: currentSong
            color: "#000"
            font.pixelSize: 16
            elide: Text.ElideRight
        }

        Text {
            text: currentArtist
            color: "#6272a4"
            font.pixelSize: 10
            elide: Text.ElideRight
        }
      }
      Item { Layout.fillWidth: true }  // spacer

    // Controls
    Row {
        spacing: 12
        Layout.alignment: Qt.AlignVCenter  // căn giữa theo hàng

        Image {
        id: nextBtn
        source: "./assets/music/pre.png"
        width: 30
        height: 30
        fillMode: Image.PreserveAspectFit
        }

        Image {
        id: playPauseBtn
        source: isPlaying ? "./assets/music/pause-button.png" : "./assets/music/play.png";
        width: 30
        height: 30
        fillMode: Image.PreserveAspectFit
        smooth: true
        }

        Image {
        id: preBtn
        source: "./assets/music/next.png"
        width: 30
        height: 30
        fillMode: Image.PreserveAspectFit
        }
    }
}
}


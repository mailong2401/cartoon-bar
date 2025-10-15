import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io

Rectangle {
    id: musicPlayer
    color: "#F5EEE6"
    border.color: "#4f4f5b"
    border.width: 3
    radius: 10

    property string currentSong: "No song playing"
    property string currentArtist: ""
    property bool isPlaying: false
    property string truncatedSong: ""

    // Cập nhật truncatedSong khi currentSong thay đổi
    onCurrentSongChanged: {
        if (currentSong.length > 30) {
            truncatedSong = currentSong.substring(0, 30) + "..."
        } else {
            truncatedSong = currentSong
        }
    }

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
        Layout.alignment: Qt.AlignVCenter

        // Song info với hiệu ứng marquee
        ColumnLayout {
            spacing: 2
            Layout.fillWidth: true
            Layout.maximumWidth: parent.width * 0.7 // Giới hạn chiều rộng

            // Container cho song title với marquee effect
            Rectangle {
                id: songContainer
                Layout.fillWidth: true
                height: 20
                color: "transparent"
                clip: true

                Text {
                    id: songText
                    text: musicPlayer.truncatedSong
                    color: "#000"
                    font.pixelSize: 16
                    
                    // Hiệu ứng marquee khi text quá dài
                    property bool needsMarquee: musicPlayer.currentSong.length > 30
                    property int textWidth: contentWidth
                    
                    // Marquee animation
                    SequentialAnimation on x {
                        id: marqueeAnimation
                        running: songText.needsMarquee && musicPlayer.isPlaying
                        loops: Animation.Infinite
                        
                        // Dừng ở vị trí ban đầu
                        PauseAnimation { duration: 2000 }
                        // Di chuyển sang trái
                        NumberAnimation {
                            from: 0
                            to: -songText.textWidth + songContainer.width
                            duration: 5000
                            easing.type: Easing.Linear
                        }
                        // Dừng ở cuối
                        PauseAnimation { duration: 1000 }
                        // Reset về vị trí ban đầu
                        NumberAnimation {
                            to: 0
                            duration: 0
                        }
                    }
                }
            }

            // Artist name
            Text {
                text: currentArtist
                color: "#6272a4"
                font.pixelSize: 10
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }

        Item { Layout.fillWidth: true }  // spacer

        // Controls
        Row {
            spacing: 12
            Layout.alignment: Qt.AlignVCenter

            // Previous button
            Image {
                id: preBtn
                source: "../assets/music/pre.png"
                width: 30
                height: 30
                fillMode: Image.PreserveAspectFit
                smooth: true

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        Qt.createQmlObject('import Quickshell; Process { command: ["playerctl", "previous"]; running: true }', musicPlayer)
                    }
                    onEntered: parent.scale = 1.2
                    onExited: parent.scale = 1.0
                }
                Behavior on scale { NumberAnimation { duration: 100 } }
            }

            // Play/Pause button
            Image {
                id: playPauseBtn
                source: isPlaying ? "../assets/music/pause.png" : "../assets/music/play.png"
                width: 30
                height: 30
                fillMode: Image.PreserveAspectFit
                smooth: true

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        Qt.createQmlObject('import Quickshell; Process { command: ["playerctl", "play-pause"]; running: true }', musicPlayer)
                    }
                    onEntered: parent.scale = 1.2
                    onExited: parent.scale = 1.0
                }
                Behavior on scale { NumberAnimation { duration: 100 } }
            }

            // Next button
            Image {
                id: nextBtn
                source: "../assets/music/next.png"
                width: 30
                height: 30
                fillMode: Image.PreserveAspectFit
                smooth: true

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        Qt.createQmlObject('import Quickshell; Process { command: ["playerctl", "next"]; running: true }', musicPlayer)
                    }
                    onEntered: parent.scale = 1.2
                    onExited: parent.scale = 1.0
                }
                Behavior on scale { NumberAnimation { duration: 100 } }
            }
        }
    }

    Component.onCompleted: {
        console.log("🎵 Music Player Started")
        truncatedSong = currentSong.length > 30 ? currentSong.substring(0, 30) + "..." : currentSong
    }
}

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
                    text: truncatedSong
                    color: "#000"
                    font.pixelSize: 16
                    elide: Text.ElideRight
                    
                    // Hiệu ứng marquee khi text quá dài
                    property bool needsMarquee: currentSong.length > 30
                    
                    x: needsMarquee && marqueeTimer.running ? -marqueeAnimation.value : 0
                    
                    Behavior on x {
                        NumberAnimation { duration: 500; easing.type: Easing.InOutQuad }
                    }
                }

                // Animation cho marquee effect
                PropertyAnimation {
                    id: marqueeAnimation
                    target: songText
                    property: "x"
                    from: 0
                    to: -songText.width + songContainer.width
                    duration: 3000
                    running: false
                }

                // Timer để kích hoạt marquee
                Timer {
                    id: marqueeTimer
                    interval: 2000
                    running: songText.needsMarquee
                    repeat: true
                    onTriggered: {
                        if (songText.needsMarquee) {
                            marqueeAnimation.start()
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
                        // Thêm command để chuyển bài trước
                        Qt.createQmlObject('import Quickshell; Process { command: ["playerctl", "previous"]; running: true }', musicPlayer)
                    }
                    
                    // Hiệu ứng hover
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
                        // Command play/pause
                        Qt.createQmlObject('import Quickshell; Process { command: ["playerctl", "play-pause"]; running: true }', musicPlayer)
                    }
                    
                    // Hiệu ứng hover
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
                        // Thêm command để chuyển bài tiếp theo
                        Qt.createQmlObject('import Quickshell; Process { command: ["playerctl", "next"]; running: true }', musicPlayer)
                    }
                    
                    // Hiệu ứng hover
                    onEntered: parent.scale = 1.2
                    onExited: parent.scale = 1.0
                }
                
                Behavior on scale { NumberAnimation { duration: 100 } }
            }
        }
    }


    Component.onCompleted: {
        console.log("🎵 Music Player Started")
        // Khởi tạo truncatedSong
        truncatedSong = currentSong.length > 30 ? currentSong.substring(0, 30) + "..." : currentSong
    }
}

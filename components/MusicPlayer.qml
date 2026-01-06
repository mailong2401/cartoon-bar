import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io

Rectangle {
    id: musicPlayer
    color: theme.primary.background
    border.color: theme.normal.black
    border.width: 3
    radius: currentSizes.radius?.normal || 10

    property string currentSong: "No song playing"
    property string currentArtist: ""
    property bool isPlaying: false
    property string truncatedSong: ""
    property var theme : currentTheme

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

    // 🧠 Kiểm tra trạng thái phát nhạc
    Process {
        id: statusCheck
        command: [Qt.resolvedUrl("../scripts/check-playing")]

        stdout: StdioCollector {
            onStreamFinished: {
                musicPlayer.isPlaying = (this.text.trim() === "true")
            }
        }
    }

    // 🧠 Các lệnh điều khiển
    Process { id: nextMusic; command: [Qt.resolvedUrl("../scripts/music-controller"), "next"] }
    Process { id: preMusic;  command: [Qt.resolvedUrl("../scripts/music-controller"), "pre"] }
    Process { id: playMusic; command: [Qt.resolvedUrl("../scripts/music-controller"), "play"] }
    Process { id: pauseMusic; command: [Qt.resolvedUrl("../scripts/music-controller"), "pause"] }


    function runProcess(proc) {
        if (!proc.running) {
            proc.running = true
        }
    }

    function musicController(action) {
      switch (action) {
      case "next": runProcess(nextMusic); break;
      case "pre": runProcess(preMusic); break; 
      case "pause": runProcess(pauseMusic); break;
      case "play": runProcess(playMusic); break;
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
        anchors.margins: currentSizes.spacing?.normal || 8
        spacing: currentSizes.spacing?.medium || 12

        // Song info với hiệu ứng marquee - chiếm toàn bộ không gian còn lại
        ColumnLayout {
            id: songInfoColumn
            Layout.fillWidth: true
            spacing: currentSizes.spacing?.small || 2

            // Container cho song title với marquee effect
            Rectangle {
                id: songContainer
                Layout.fillWidth: true
                height: currentSizes.musicPlayerLayout?.songContainerHeight || 20
                color: "transparent"
                clip: true

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: {
                        if (musicPanelLoader.active && musicPanelLoader.item) {
                            musicPanelLoader.item.visible = !musicPanelLoader.item.visible
                        } else {
                            musicPanelLoader.active = true
                        }
                    }
                    onEntered: songContainer.opacity = 0.8
                    onExited: songContainer.opacity = 1.0
                }

                Text {
                    id: songText
                    text: truncatedSong
                    color: theme.primary.foreground
                    font.pixelSize: currentSizes.fontSize?.medium || 16
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

                Behavior on opacity {
                    NumberAnimation { duration: 100 }
                }
            }

            // Artist name
            Text {
                text: currentArtist
                color: theme.primary.dim_foreground
                font.pixelSize: currentSizes.fontSize?.small || 10
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }

        // Controls - chỉ đủ rộng cho các nút
        RowLayout {
            id: controlsRow
            spacing: currentSizes.spacing?.medium || 12
            Layout.fillHeight: true  // Chiếm toàn bộ chiều cao
            Layout.preferredWidth: childrenRect.width // Chỉ đủ rộng cho các nút
            Layout.minimumWidth: childrenRect.width
            Layout.maximumWidth: childrenRect.width

            // Previous button
            Image {
                id: preBtn
                source: theme.type === "dark" ? "../assets/music/pre_dark.png" : "../assets/music/pre.png"
                Layout.preferredWidth: currentSizes.iconSize?.normal || 30
                Layout.preferredHeight: currentSizes.iconSize?.normal || 30
                fillMode: Image.PreserveAspectFit
                smooth: true

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        // Thêm command để chuyển bài trước
                        musicPlayer.musicController("pre")
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
                source: {
                    var suffix = theme.type === "dark" ? "_dark" : ""
                    return isPlaying ? "../assets/music/pause" + suffix + ".png" : "../assets/music/play" + suffix + ".png"
                }
                Layout.preferredWidth: currentSizes.iconSize?.normal || 30
                Layout.preferredHeight: currentSizes.iconSize?.normal || 30
                fillMode: Image.PreserveAspectFit
                smooth: true

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        // Command play/pause
                        isPlaying ? musicPlayer.musicController("pause") : musicPlayer.musicController("play")
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
                source: theme.type === "dark" ? "../assets/music/next_dark.png" : "../assets/music/next.png"
                Layout.preferredWidth: currentSizes.iconSize?.normal || 30
                Layout.preferredHeight: currentSizes.iconSize?.normal || 30
                fillMode: Image.PreserveAspectFit
                smooth: true

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        musicPlayer.musicController("next")
                    }
                    
                    // Hiệu ứng hover
                    onEntered: parent.scale = 1.2
                    onExited: parent.scale = 1.0
                }
                
                Behavior on scale { NumberAnimation { duration: 100 } }
            }
        }
    }


    // Loader for MusicPanel
    Loader {
        id: musicPanelLoader
        active: false
        source: "MusicPanel.qml"
        onLoaded: {
            item.visible = true
        }
    }

    Component.onCompleted: {
        truncatedSong = currentSong.length > 30 ? currentSong.substring(0, 30) + "..." : currentSong
    }
}
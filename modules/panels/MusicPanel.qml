import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Widgets
import "../../services" as Services

PanelWindow {
    id: musicPanel

    property var sizes: currentSizes.musicPanel || {}
    property var theme: currentTheme
    property var lang: currentLanguage

    // Music data
    property string currentSong: "No song playing"
    property string currentArtist: "Unknown Artist"
    property string albumArt: ""
    property bool isPlaying: false
    property int position: 0
    property int duration: 0

    implicitWidth: sizes.width || 500
    implicitHeight: sizes.height || 400
    focusable: true

    anchors {
        top: currentConfig.mainPanelPos === "top"
        bottom: currentConfig.mainPanelPos === "bottom"
        left: true
    }

    margins {
        top: currentConfig.mainPanelPos === "top" ? (sizes.marginTop || 10) : 0
        bottom: currentConfig.mainPanelPos === "bottom" ? (sizes.marginBottom || 10) : 0
        left: sizes.marginLeft || 400
    }

    exclusiveZone: 0
    color: "transparent"

    // CavaService instance
    Services.CavaService { id: cavaService }

    // Process get metadata
    Process {
        id: metadataProc
        running: false
        command: ["playerctl", "metadata", "--format", "{{artist}}|||{{title}}|||{{mpris:artUrl}}|||{{position}}|||{{mpris:length}}"]

        stdout: StdioCollector {
            onStreamFinished: {
                if (this.text) {
                    var parts = this.text.trim().split("|||")
                    if (parts.length >= 3) {
                        musicPanel.currentArtist = parts[0] || "Unknown Artist"
                        musicPanel.currentSong = parts[1] || "No song playing"
                        var artUrl = parts[2] || ""
                        if (artUrl.startsWith("file://")) {
                            musicPanel.albumArt = artUrl
                        } else if (artUrl.startsWith("http")) {
                            musicPanel.albumArt = artUrl
                        } else {
                            musicPanel.albumArt = ""
                        }
                        if (parts.length >= 5) {
                            musicPanel.position = parseInt(parts[3]) || 0
                            musicPanel.duration = parseInt(parts[4]) || 0
                        }
                    }
                }
            }
        }
    }

    // Process check playing status
    Process {
        id: statusProc
        running: false
        command: ["playerctl", "status"]

        stdout: StdioCollector {
            onStreamFinished: {
                musicPanel.isPlaying = (this.text.trim() === "Playing")
            }
        }
    }

    // Control processes
    Process { id: nextProc; command: ["playerctl", "next"] }
    Process { id: prevProc; command: ["playerctl", "previous"] }
    Process { id: playProc; command: ["playerctl", "play"] }
    Process { id: pauseProc; command: ["playerctl", "pause"] }

    function runProcess(proc) {
        if (!proc.running) proc.running = true
    }

    function formatTime(microseconds) {
        var totalSeconds = Math.floor(microseconds / 1000000)
        var minutes = Math.floor(totalSeconds / 60)
        var seconds = totalSeconds % 60
        return minutes + ":" + (seconds < 10 ? "0" : "") + seconds
    }

    // Refresh timer
    Timer {
        interval: 1000
        running: musicPanel.visible
        repeat: true
        onTriggered: {
            if (!metadataProc.running) metadataProc.running = true
            if (!statusProc.running) statusProc.running = true
        }
    }

    // Start cava when panel opens
    onVisibleChanged: {
        if (visible) {
            cavaService.open()
            if (!metadataProc.running) metadataProc.running = true
            if (!statusProc.running) statusProc.running = true
        } else {
            cavaService.close()
        }
    }

    // Main content
    Rectangle {
        anchors.fill: parent
        radius: sizes.radius || 16
        color: theme.primary.background
        border.color: theme.normal.black
        border.width: sizes.borderWidth || 3

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: sizes.margins || 20
            spacing: sizes.spacing || 16

            // Header
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: sizes.headerHeight || 50

                // Title centered
                Row {
                    anchors.centerIn: parent
                    spacing: sizes.headerSpacing || 12

                    Image {
                        source: "../../assets/music/music-icon.png"
                        width: sizes.headerIconSize || 32
                        height: sizes.headerIconSize || 32
                        fillMode: Image.PreserveAspectFit
                        visible: source != ""
                    }

                    Text {
                        text: lang.musicPanel?.title || "Music Player"
                        font.family: "ComicShannsMono Nerd Font"
                        font.pixelSize: currentSizes.ramManagement?.header?.fontSize || 40
                        font.bold: true
                        color: theme.primary.foreground
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                // Close button (right side)
                Rectangle {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: sizes.closeButtonSize || 32
                    height: sizes.closeButtonSize || 32
                    radius: sizes.closeButtonRadius || 8
                    color: closeArea.containsMouse ? theme.normal.red : theme.button.background

                    Text {
                        anchors.centerIn: parent
                        text: "x"
                        font.family: "ComicShannsMono Nerd Font"
                        font.pixelSize: sizes.closeButtonFontSize || 18
                        font.bold: true
                        color: theme.primary.foreground
                    }

                    MouseArea {
                        id: closeArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: musicPanel.visible = false
                    }
                }
            }

            // Album art and info section
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: sizes.albumSectionHeight || 180
                spacing: sizes.albumSpacing || 20

                // Album art (circular with rotation)
                Item {
                    Layout.preferredWidth: sizes.albumArtSize || 160
                    Layout.preferredHeight: sizes.albumArtSize || 160

                    // Rotating container
                    Item {
                        id: rotatingContainer
                        anchors.fill: parent

                        RotationAnimation on rotation {
                            from: 0
                            to: 360
                            duration: 10000
                            loops: Animation.Infinite
                            running: isPlaying
                        }

                        ClippingRectangle {
                            id: albumArtContainer
                            anchors.fill: parent
                            radius: width / 2
                            color: theme.primary.dim_background
                            border.color: theme.normal.black
                            border.width: sizes.borderWidth || 3

                            Image {
                                id: albumImage
                                anchors.fill: parent
                                source: musicPanel.albumArt
                                fillMode: Image.PreserveAspectCrop
                                visible: status === Image.Ready
                                cache: false
                                asynchronous: true
                                smooth: true
                            }

                            // Placeholder when no album art
                            Text {
                                anchors.centerIn: parent
                                text: "No Art"
                                font.family: "ComicShannsMono Nerd Font"
                                font.pixelSize: sizes.placeholderFontSize || 14
                                color: theme.primary.dim_foreground
                                visible: albumImage.status !== Image.Ready
                            }
                        }
                    }
                }


                // Song info
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: sizes.infoSpacing || 8

                    Item { Layout.fillHeight: true }

                    // Song title with marquee effect
                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: songText.height
                        clip: true

                        Text {
                            id: songText
                            text: currentSong
                            font.family: "ComicShannsMono Nerd Font"
                            font.pixelSize: sizes.songFontSize || 22
                            font.bold: true
                            color: theme.primary.foreground

                            property bool needsMarquee: width > parent.width

                            x: 0

                            SequentialAnimation on x {
                                id: marqueeAnimation
                                running: songText.needsMarquee && musicPanel.visible
                                loops: Animation.Infinite

                                // Pause at start
                                PauseAnimation { duration: 2000 }

                                // Scroll left
                                NumberAnimation {
                                    to: -(songText.width - songText.parent.width)
                                    duration: Math.max(2000, (songText.width - songText.parent.width) * 20)
                                    easing.type: Easing.Linear
                                }

                                // Pause at end
                                PauseAnimation { duration: 2000 }

                                // Scroll back
                                NumberAnimation {
                                    to: 0
                                    duration: Math.max(2000, (songText.width - songText.parent.width) * 20)
                                    easing.type: Easing.Linear
                                }
                            }
                        }
                    }

                    Text {
                        text: currentArtist
                        font.family: "ComicShannsMono Nerd Font"
                        font.pixelSize: sizes.artistFontSize || 16
                        color: theme.primary.dim_foreground
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    // Progress bar
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        visible: duration > 0

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: sizes.progressBarHeight || 6
                            radius: sizes.progressBarRadius || 3
                            color: theme.primary.dim_background

                            Rectangle {
                                width: duration > 0 ? parent.width * (position / duration) : 0
                                height: parent.height
                                radius: parent.radius
                                color: theme.normal.blue

                                Behavior on width {
                                    NumberAnimation { duration: 200 }
                                }
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true

                            Text {
                                text: formatTime(position)
                                font.family: "ComicShannsMono Nerd Font"
                                font.pixelSize: sizes.timeFontSize || 11
                                color: theme.primary.dim_foreground
                            }

                            Item { Layout.fillWidth: true }

                            Text {
                                text: formatTime(duration)
                                font.family: "ComicShannsMono Nerd Font"
                                font.pixelSize: sizes.timeFontSize || 11
                                color: theme.primary.dim_foreground
                            }
                        }
                    }

                    Item { Layout.fillHeight: true }
                }
            }

            // Controls
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: sizes.controlsHeight || 60
                spacing: sizes.controlsSpacing || 24

                Item { Layout.fillWidth: true }

                // Previous
                Rectangle {
                    Layout.preferredWidth: sizes.controlButtonSize || 48
                    Layout.preferredHeight: sizes.controlButtonSize || 48
                    radius: sizes.controlButtonRadius || 24
                    color: prevArea.containsMouse ? theme.button.background_select : theme.button.background

                    Image {
                        anchors.centerIn: parent
                        source: theme.type === "dark" ? "../../assets/music/pre_dark.png" : "../../assets/music/pre.png"
                        width: sizes.controlIconSize || 28
                        height: sizes.controlIconSize || 28
                        fillMode: Image.PreserveAspectFit
                    }

                    MouseArea {
                        id: prevArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: runProcess(prevProc)
                    }

                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                // Play/Pause
                Rectangle {
                    Layout.preferredWidth: sizes.playButtonSize || 64
                    Layout.preferredHeight: sizes.playButtonSize || 64
                    radius: sizes.playButtonRadius || 32
                    color: playArea.containsMouse ? theme.normal.blue : theme.button.background

                    Image {
                        anchors.centerIn: parent
                        source: {
                            var suffix = theme.type === "dark" ? "_dark" : ""
                            return isPlaying ? "../../assets/music/pause" + suffix + ".png" : "../../assets/music/play" + suffix + ".png"
                        }
                        width: sizes.playIconSize || 32
                        height: sizes.playIconSize || 32
                        fillMode: Image.PreserveAspectFit
                    }

                    MouseArea {
                        id: playArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: isPlaying ? runProcess(pauseProc) : runProcess(playProc)
                    }

                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                // Next
                Rectangle {
                    Layout.preferredWidth: sizes.controlButtonSize || 48
                    Layout.preferredHeight: sizes.controlButtonSize || 48
                    radius: sizes.controlButtonRadius || 24
                    color: nextArea.containsMouse ? theme.button.background_select : theme.button.background

                    Image {
                        anchors.centerIn: parent
                        source: theme.type === "dark" ? "../../assets/music/next_dark.png" : "../../assets/music/next.png"
                        width: sizes.controlIconSize || 28
                        height: sizes.controlIconSize || 28
                        fillMode: Image.PreserveAspectFit
                    }

                    MouseArea {
                        id: nextArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: runProcess(nextProc)
                    }

                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                Item { Layout.fillWidth: true }
            }

            // Cava Visualizer
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumHeight: sizes.cavaHeight || 100
                radius: sizes.cavaRadius || 12
                color: theme.primary.dim_background
                clip: true

                Row {
                    id: cavaRow
                    anchors.fill: parent
                    anchors.margins: sizes.cavaMargins || 8
                    spacing: sizes.cavaBarSpacing || 2

                    Repeater {
                        model: cavaService.values.length

                        Rectangle {
                            width: (cavaRow.width - (cavaService.values.length - 1) * (sizes.cavaBarSpacing || 2)) / cavaService.values.length
                            height: Math.max(4, (cavaService.values[index] / 100) * cavaRow.height)
                            anchors.bottom: parent.bottom
                            radius: sizes.cavaBarRadius || 2
                            color: {
                                // Gradient based on height using theme colors
                                var ratio = cavaService.values[index] / 100
                                if (ratio < 0.3) return theme.normal.blue
                                if (ratio < 0.5) return theme.normal.cyan
                                if (ratio < 0.7) return theme.normal.green
                                if (ratio < 0.85) return theme.normal.yellow
                                return theme.normal.red
                            }

                            Behavior on height {
                                NumberAnimation { duration: 50 }
                            }

                            Behavior on color {
                                ColorAnimation { duration: 100 }
                            }
                        }
                    }
                }

                // No music playing overlay
                Rectangle {
                    anchors.fill: parent
                    color: theme.primary.dim_background
                    opacity: 0.8
                    visible: !cavaService.isRunning || !isPlaying

                    Text {
                        anchors.centerIn: parent
                        text: !isPlaying ? (lang.musicPanel?.notPlaying || "Not playing") : (lang.musicPanel?.loading || "Loading...")
                        font.family: "ComicShannsMono Nerd Font"
                        font.pixelSize: sizes.cavaPlaceholderFontSize || 14
                        color: theme.primary.dim_foreground
                    }
                }
            }
        }
    }
}

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets

Scope {
    id: root

    property var sizes: currentSizes.volumeOsd || {}
    property var theme: currentTheme
    property var lang: currentLanguage
    property bool shouldShowOsd: false
    property real currentVolume: Pipewire.defaultAudioSink?.audio.volume ?? 0
    property bool isMuted: Pipewire.defaultAudioSink?.audio.mute ?? false

    PwObjectTracker {
        objects: [ Pipewire.defaultAudioSink ]
    }

    Connections {
        target: Pipewire.defaultAudioSink?.audio ?? null

        function onVolumeChanged() {
            root.shouldShowOsd = true;
            hideTimer.restart();
        }
    }

    Timer {
        id: hideTimer
        interval: sizes.hideDelay || 1000
        onTriggered: root.shouldShowOsd = false
    }

    LazyLoader {
        active: root.shouldShowOsd

        PanelWindow {
            anchors {
                bottom: true
            }
            margins {
              bottom: sizes.marginBottom || 120
            }
            exclusiveZone: 0
            implicitWidth: sizes.width || 280
            implicitHeight: sizes.height || 100
            color: "transparent"
            mask: Region {}

            Rectangle {
                anchors.fill: parent
                radius: sizes.radius || 15
                color: theme.primary.background
                border.color: theme.normal.black
                border.width: sizes.borderWidth || 3

                ColumnLayout {
                    anchors {
                        fill: parent
                        leftMargin: sizes.margins || 15
                        rightMargin: sizes.margins || 15
                        bottomMargin: sizes.margins || 15
                    }
                    spacing: sizes.spacing || 12

                    RowLayout {
                        Image {
                          Layout.preferredWidth: sizes.iconSize || 40
                          Layout.preferredHeight: sizes.iconSize || 40
                          source: root.getVolumeIcon()
                          fillMode: Image.PreserveAspectFit
                          smooth: true
                        }
                    Text {
                          text: isMuted ? (lang?.volume?.muted || "Muted") : Math.round(currentVolume * 100) + "%"
                          color: theme.primary.foreground
                          font.family: "ComicShannsMono Nerd Font"
                          font.pixelSize: sizes.percentFontSize || 30
                          font.bold: true
                        }
                        Rectangle {
                                      color: "transparent"

                          Layout.fillWidth: true
                        Layout.fillHeight: true
                            Text {
                          text: " " + (lang?.volume?.title || "Âm thanh")
                          anchors.margins: 10
                          anchors.top: parent.top
                            anchors.right: parent.right
                          color: theme.primary.foreground
                          font.family: "ComicShannsMono Nerd Font"
                          font.pixelSize: sizes.titleFontSize || 20
                          font.bold: true
                      }
                        }

                    }


                    // Thanh volume
                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 4

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: sizes.progressBarHeight || 20
                            radius: sizes.progressBarRadius || 20
                            color: "#333333"

                            Rectangle {
                                anchors {
                                    left: parent.left
                                    top: parent.top
                                    bottom: parent.bottom
                                }
                                width: parent.width * currentVolume
                                radius: parent.radius
                                color: isMuted ? "#ff6b6b" : "#4a86e8"
                            }
                        }
                    }
                }
            }
        }
    }

    function getVolumeIcon() {
        if (isMuted || currentVolume == 0) return "../../assets/volume/volume_0.png"
        if (currentVolume <= 0.25) return "../../assets/volume/volume_1.png"
        if (currentVolume <= 0.50) return "../../assets/volume/volume_2.png"
        if (currentVolume <= 0.75) return "../../assets/volume/volume_3.png"
        if (currentVolume <= 1) return "../../assets/volume/volume_4.png"
        return "../../assets/volume/volume_5.png"
    }
}

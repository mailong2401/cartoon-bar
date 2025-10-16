import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets

Scope {
    id: root

    PwObjectTracker {
        objects: [ Pipewire.defaultAudioSink ]
    }

    Connections {
        target: Pipewire.defaultAudioSink?.audio

        function onVolumeChanged() {
            root.shouldShowOsd = true;
            hideTimer.restart();
        }
    }

    property bool shouldShowOsd: false
    property real currentVolume: Pipewire.defaultAudioSink?.audio.volume ?? 0
    property bool isMuted: Pipewire.defaultAudioSink?.audio.mute ?? false

    Timer {
        id: hideTimer
        interval: 1000
        onTriggered: root.shouldShowOsd = false
    }

    LazyLoader {
        active: root.shouldShowOsd

        PanelWindow {
            anchors {
                bottom: true
            }
            margins {
              bottom: 120
            }
            exclusiveZone: 0
            implicitWidth: 280
            implicitHeight: 100
            color: "transparent"
            mask: Region {}

            Rectangle {
                anchors.fill: parent
                radius: 15
                color: "#F5EEE6"
                border.color: "#4f4f5b"
                border.width: 2

                ColumnLayout {
                    anchors {
                        fill: parent
                        leftMargin: 15
                        rightMargin: 15
                        bottomMargin: 15
                    }
                    spacing: 12

                    RowLayout {
                        Image {
                          Layout.preferredWidth: 40
                          Layout.preferredHeight: 40
                          source: root.getVolumeIcon()
                          fillMode: Image.PreserveAspectFit
                          smooth: true
                        }
                    Text {
                          text: isMuted ? "Muted" : Math.round(currentVolume * 100) + "%"
                          color: "#4f4f5b"
                          font.family: "ComicShannsMono Nerd Font"
                          font.pixelSize: 30
                          font.bold: true
                        }
                        Rectangle {
                                      color: "transparent"

                          Layout.fillWidth: true
                        Layout.fillHeight: true
                            Text {
                          text: " Âm thanh"
                          anchors.margins: 10
                          anchors.top: parent.top
                            anchors.right: parent.right
                          color: "#4f4f5b"
                          font.family: "ComicShannsMono Nerd Font"
                          font.pixelSize: 20
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
                            Layout.preferredHeight: 20
                            radius: 20
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
        if (isMuted || currentVolume == 0) return "../assets/volume/volume_0.png"
        if (currentVolume <= 0.25) return "../assets/volume/volume_1.png"
        if (currentVolume <= 0.50) return "../assets/volume/volume_2.png"
        if (currentVolume <= 0.75) return "../assets/volume/volume_3.png"
        if (currentVolume <= 1) return "../assets/volume/volume_4.png"
        return "../assets/volume/volume_5.png"
    }
}

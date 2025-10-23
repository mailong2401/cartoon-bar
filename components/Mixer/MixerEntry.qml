import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.Pipewire

ColumnLayout {
    required property PwNode node
    property alias showIcon: icon.visible
    property alias showMediaName: mediaLabel.visible
    
    // bind the node so we can read its properties
    PwObjectTracker { objects: [ node ] }

    spacing: 8

    // Header row với app info và controls
    RowLayout {
        spacing: 8

        // App icon với styling theme
        Rectangle {
            id: icon
            width: 24
            height: 24
            radius: 4
            color: theme.button.background
            
            Image {
                anchors.fill: parent
                anchors.margins: 2
                source: {
                    const iconName = node.properties["application.icon-name"] ?? "audio-volume-high-symbolic"
                    return `image://icon/${iconName}`
                }
                sourceSize.width: 20
                sourceSize.height: 20
                fillMode: Image.PreserveAspectFit
            }
        }

        // App và media info
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Label {
                id: appLabel
                text: {
                    const appName = node.properties["application.name"] ?? 
                                   (node.description != "" ? node.description : node.name)
                    return appName || "Unknown Application"
                }
                font.bold: true
                font.family: "ComicShannsMono Nerd Font"
                font.pixelSize: 16
                elide: Text.ElideRight
                Layout.fillWidth: true
                color: theme.primary.foreground
            }

            Label {
                id: mediaLabel
                text: node.properties["media.name"] ?? ""
                font.family: "ComicShannsMono Nerd Font"
                font.pixelSize: 14
                opacity: 0.8
                elide: Text.ElideRight
                Layout.fillWidth: true
                visible: text !== ""
                color: theme.primary.foreground
            }
        }

        // Mute button với icon theme
        Button {
            id: muteButton
            text: ""
            width: 28
            height: 28
            opacity: hovered ? 1.0 : 0.8
            
            background: Rectangle {
                color: "transparent"
                radius: 4
                border.color: theme.button.border
                border.width: muteButton.down ? 2 : 1
                opacity: 0.5
            }
            
            contentItem: Text {
                text: node.audio.muted ? "🔇" : "🔊"
                font.pixelSize: 11
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: node.audio.muted ? theme.normal.red : theme.normal.green
            }
            
            onClicked: node.audio.muted = !node.audio.muted
            
            ToolTip.text: node.audio.muted ? "Unmute" : "Mute"
            ToolTip.visible: hovered
        }
    }

    // Volume control section
    RowLayout {
        spacing: 8

        // Volume percentage
        Label {
            Layout.preferredWidth: 40
            text: `${Math.round(node.audio.volume * 100)}%`
            font.pixelSize: 11
            font.bold: true
            color: node.audio.muted ? theme.normal.red : theme.normal.blue
            horizontalAlignment: Text.AlignRight
        }

        // Custom slider với theme
        Slider {
            id: volumeSlider
            Layout.fillWidth: true
            from: 0
            to: 1
            value: node.audio.volume
            enabled: !node.audio.muted
            opacity: enabled ? 1.0 : 0.5
            
            onMoved: node.audio.volume = value
            
            background: Rectangle {
                x: volumeSlider.leftPadding
                y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                implicitWidth: 200
                implicitHeight: 6
                width: volumeSlider.availableWidth
                height: implicitHeight
                radius: 3
                color: theme.button.background
                
                // Progress fill
                Rectangle {
                    width: volumeSlider.visualPosition * parent.width
                    height: parent.height
                    color: {
                        if (node.audio.muted) return theme.normal.black
                        const vol = node.audio.volume
                        if (vol > 1.0) return theme.normal.red
                        if (vol > 0.8) return theme.normal.yellow
                        return theme.normal.blue
                    }
                    radius: 3
                    Behavior on color { 
                        ColorAnimation { 
                            duration: 200 
                            easing.type: Easing.InOutQuad
                        } 
                    }
                }
                
                // Clip indicator (khi volume > 100%)
                Rectangle {
                    visible: node.audio.volume > 1.0
                    x: parent.width - width
                    width: 3
                    height: parent.height + 2
                    radius: 1.5
                    color: theme.normal.red
                    border.color: theme.bright.red
                    border.width: 1
                }
            }
            
            handle: Rectangle {
                x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
                y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                implicitWidth: 16
                implicitHeight: 16
                radius: 8
                color: volumeSlider.pressed ? theme.normal.blue : theme.primary.background
                border.color: node.audio.muted ? theme.normal.black : 
                           node.audio.volume > 1.0 ? theme.normal.red :
                           node.audio.volume > 0.8 ? theme.normal.yellow : theme.normal.blue
                border.width: 2
                
                // Inner dot
                Rectangle {
                    anchors.centerIn: parent
                    width: 4
                    height: 4
                    radius: 2
                    color: theme.primary.foreground
                    opacity: volumeSlider.pressed ? 1.0 : 0.7
                }
                
                Behavior on color { 
                    ColorAnimation { 
                        duration: 150 
                        easing.type: Easing.InOutQuad
                    } 
                }
                Behavior on border.color { 
                    ColorAnimation { 
                        duration: 200 
                        easing.type: Easing.InOutQuad
                    } 
                }
            }
        }
    }

    // Peak level indicator (hiển thị khi có âm thanh phát ra)
    Rectangle {
        visible: node.audio.peak > 0.01
        Layout.fillWidth: true
        Layout.preferredHeight: 2
        radius: 1
        color: theme.button.background
        
        Rectangle {
            width: parent.width * Math.min(node.audio.peak, 1.0)
            height: parent.height
            radius: 1
            color: {
                const peak = node.audio.peak
                if (peak > 0.9) return theme.normal.red
                if (peak > 0.7) return theme.normal.yellow
                return theme.normal.green
            }
            
            Behavior on width {
                NumberAnimation { 
                    duration: 80 
                    easing.type: Easing.OutCubic
                }
            }
            Behavior on color {
                ColorAnimation { 
                    duration: 150 
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }


}

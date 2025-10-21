// components/Settings/AudioSettings.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    property var theme : currentTheme
    
    ScrollView {
        anchors.fill: parent
        anchors.margins: 20
        clip: true
        
        ColumnLayout {
            width: parent.width
            spacing: 20
            
            // Tiêu đề
            Text {
                text: "Audio Settings"
                color: theme.primary.foreground
                font.pixelSize: 24
                font.bold: true
                font.family: "ComicShannsMono Nerd Font"
                Layout.topMargin: 10
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: theme.primary.dim_foreground + "40"
            }
            
            // 1️⃣ Thông tin và điều chỉnh cơ bản
            Rectangle {
                width: 470
                Layout.preferredHeight: basicContentLayout.height + 30
                radius: 8
                color: theme.primary.background
                border.color: theme.normal.black
                border.width: 1
                
                ColumnLayout {
                    id: basicContentLayout
                    width: parent.width
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 15
                    spacing: 15
                    
                    Text {
                        text: "Basic Audio Controls"
                        color: theme.primary.foreground
                        font.pixelSize: 18
                        font.bold: true
                        font.family: "ComicShannsMono Nerd Font"
                    }
                    
                    // Master Volume
                    RowLayout {
                        spacing: 15
                        
                        Text {
                            text: "Master Volume:"
                            color: theme.primary.foreground
                            font.pixelSize: 14
                            font.family: "ComicShannsMono Nerd Font"
                            Layout.preferredWidth: 120
                        }
                        
                        Slider {
                            id: masterVolumeSlider
                            Layout.fillWidth: true
                            from: 0
                            to: 100
                            value: 75
                            
                            background: Rectangle {
                                x: parent.leftPadding
                                y: parent.topPadding + parent.availableHeight / 2 - height / 2
                                implicitWidth: 200
                                implicitHeight: 4
                                width: parent.availableWidth
                                height: implicitHeight
                                radius: 2
                                color: theme.primary.dim_foreground + "40"
                                
                                Rectangle {
                                    width: parent.width * (masterVolumeSlider.value / 100)
                                    height: parent.height
                                    color: theme.accent.color
                                    radius: 2
                                }
                            }
                            
                            handle: Rectangle {
                                x: parent.leftPadding + parent.availableWidth * (parent.visualPosition || 0) - width / 2
                                y: parent.topPadding + parent.availableHeight / 2 - height / 2
                                implicitWidth: 20
                                implicitHeight: 20
                                radius: 10
                                color: parent.pressed ? theme.accent.color : theme.primary.foreground
                                border.color: theme.accent.color
                                border.width: 2
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: Math.round(masterVolumeSlider.value) + "%"
                                    color: theme.primary.background
                                    font.pixelSize: 8
                                    font.bold: true
                                }
                            }
                        }
                        
                        Text {
                            text: Math.round(masterVolumeSlider.value) + "%"
                            color: theme.primary.foreground
                            font.pixelSize: 14
                            font.family: "ComicShannsMono Nerd Font"
                            Layout.preferredWidth: 40
                        }
                        
                        Button {
                            id: muteButton
                            text: masterVolumeSlider.value === 0 ? "🔇 Unmute" : "🔊 Mute"
                            font.family: "ComicShannsMono Nerd Font"
                            Layout.preferredWidth: 100
                            
                            background: Rectangle {
                                radius: 6
                                color: parent.down ? theme.button.background_select : 
                                       parent.hovered ? theme.button.background + "80" : theme.button.background
                                border.color: theme.button.border
                                border.width: 1
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                color: theme.primary.foreground
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font: parent.font
                            }
                            
                            onClicked: {
                                if (masterVolumeSlider.value === 0) {
                                    masterVolumeSlider.value = 75
                                } else {
                                    masterVolumeSlider.value = 0
                                }
                            }
                        }
                    }
                    
                    // Balance Control
                    RowLayout {
                        spacing: 15
                        
                        Text {
                            text: "Balance:"
                            color: theme.primary.foreground
                            font.pixelSize: 14
                            font.family: "ComicShannsMono Nerd Font"
                            Layout.preferredWidth: 120
                        }
                        
                        Slider {
                            id: balanceSlider
                            Layout.fillWidth: true
                            from: -100
                            to: 100
                            value: 0
                            
                            background: Rectangle {
                                x: parent.leftPadding
                                y: parent.topPadding + parent.availableHeight / 2 - height / 2
                                implicitWidth: 200
                                implicitHeight: 4
                                width: parent.availableWidth
                                height: implicitHeight
                                radius: 2
                                color: theme.primary.dim_foreground + "40"
                                
                                Rectangle {
                                    x: parent.width / 2 - width / 2
                                    width: Math.abs(parent.width * (balanceSlider.value / 200))
                                    height: parent.height
                                    color: theme.accent.color
                                    radius: 2
                                }
                            }
                            
                            handle: Rectangle {
                                x: parent.leftPadding + parent.availableWidth * ((parent.value + 100) / 200) - width / 2
                                y: parent.topPadding + parent.availableHeight / 2 - height / 2
                                implicitWidth: 16
                                implicitHeight: 16
                                radius: 8
                                color: parent.pressed ? theme.accent.color : theme.primary.foreground
                                border.color: theme.accent.color
                                border.width: 2
                            }
                        }
                        
                        Text {
                            text: {
                                if (balanceSlider.value === 0) return "Center"
                                else if (balanceSlider.value > 0) return "R+" + Math.abs(balanceSlider.value) + "%"
                                else return "L+" + Math.abs(balanceSlider.value) + "%"
                            }
                            color: theme.primary.foreground
                            font.pixelSize: 12
                            font.family: "ComicShannsMono Nerd Font"
                            Layout.preferredWidth: 60
                        }
                    }
                }
            }
            
            // 2️⃣ Output Devices
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: outputContentLayout.height + 30
                radius: 8
                color: theme.primary.background
                border.color: theme.normal.black
                border.width: 1
                
                ColumnLayout {
                    id: outputContentLayout
                    width: parent.width
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 15
                    spacing: 10
                    
                    Text {
                        text: "Output Devices"
                        color: theme.primary.foreground
                        font.pixelSize: 18
                        font.bold: true
                        font.family: "ComicShannsMono Nerd Font"
                    }
                    
                    Repeater {
                        model: [
                            { name: "Built-in Audio Analog Stereo", type: "Analog", default: true },
                            { name: "HDMI / DisplayPort", type: "Digital", default: false },
                            { name: "JBL Bluetooth Headphones", type: "Bluetooth", default: false },
                            { name: "USB Audio Device", type: "Digital", default: false }
                        ]
                        
                        delegate: Rectangle {
                            width: parent.width
                            height: 50
                            radius: 6
                            color: mouseArea.containsMouse ? theme.button.background + "40" : "transparent"
                            border.color: modelData.default ? theme.accent.color : "transparent"
                            border.width: 2
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 10
                                spacing: 10
                                
                                Rectangle {
                                    width: 30
                                    height: 30
                                    radius: 15
                                    color: theme.accent.color + "20"
                                    border.color: theme.accent.color
                                    border.width: 1
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: {
                                            switch(modelData.type) {
                                                case "Analog": return "🔈";
                                                case "Digital": return "📺";
                                                case "Bluetooth": return "🎧";
                                                default: return "🔊";
                                            }
                                        }
                                        font.pixelSize: 14
                                    }
                                }
                                
                                ColumnLayout {
                                    spacing: 2
                                    Layout.fillWidth: true
                                    
                                    Text {
                                        text: modelData.name
                                        color: theme.primary.foreground
                                        font.pixelSize: 14
                                        font.family: "ComicShannsMono Nerd Font"
                                        font.bold: modelData.default
                                    }
                                    
                                    Text {
                                        text: modelData.type + (modelData.default ? " • Default" : "")
                                        color: theme.primary.dim_foreground
                                        font.pixelSize: 11
                                        font.family: "ComicShannsMono Nerd Font"
                                    }
                                }
                                
                                Button {
                                    text: modelData.default ? "Default" : "Set Default"
                                    font.family: "ComicShannsMono Nerd Font"
                                    font.pixelSize: 11
                                    Layout.preferredWidth: 80
                                    enabled: !modelData.default
                                    
                                    background: Rectangle {
                                        radius: 4
                                        color: parent.down ? theme.accent.color : 
                                               parent.hovered ? theme.accent.color + "40" : theme.button.background
                                        border.color: theme.accent.color
                                        border.width: 1
                                    }
                                    
                                    contentItem: Text {
                                        text: parent.text
                                        color: modelData.default ? theme.primary.foreground : theme.accent.color
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        font: parent.font
                                    }
                                }
                            }
                            
                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    console.log("Selected:", modelData.name)
                                }
                            }
                        }
                    }
                }
            }
            
            // 3️⃣ Input Devices (Microphone)
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: inputContentLayout.height + 30
                radius: 8
                color: theme.primary.background
                border.color: theme.normal.black
                border.width: 1
                
                ColumnLayout {
                    id: inputContentLayout
                    width: parent.width
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 15
                    spacing: 15
                    
                    Text {
                        text: "Input Devices (Microphone)"
                        color: theme.primary.foreground
                        font.pixelSize: 18
                        font.bold: true
                        font.family: "ComicShannsMono Nerd Font"
                    }
                    
                    Repeater {
                        model: [
                            { name: "Built-in Microphone", default: true, volume: 80, muted: false },
                            { name: "USB Webcam Microphone", default: false, volume: 60, muted: true },
                            { name: "Bluetooth Headset Mic", default: false, volume: 90, muted: false }
                        ]
                        
                        delegate: Rectangle {
                            width: parent.width
                            height: 80
                            radius: 6
                            color: mouseAreaInput.containsMouse ? theme.button.background + "40" : "transparent"
                            border.color: modelData.default ? theme.accent.color : "transparent"
                            border.width: 2
                            
                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 10
                                spacing: 5
                                
                                // Device header
                                RowLayout {
                                    spacing: 10
                                    
                                    Rectangle {
                                        width: 25
                                        height: 25
                                        radius: 12.5
                                        color: theme.accent.color + "20"
                                        border.color: theme.accent.color
                                        border.width: 1
                                        
                                        Text {
                                            anchors.centerIn: parent
                                            text: "🎤"
                                            font.pixelSize: 12
                                        }
                                    }
                                    
                                    Text {
                                        text: modelData.name
                                        color: theme.primary.foreground
                                        font.pixelSize: 14
                                        font.family: "ComicShannsMono Nerd Font"
                                        font.bold: modelData.default
                                        Layout.fillWidth: true
                                    }
                                    
                                    Text {
                                        text: modelData.default ? "Default" : ""
                                        color: theme.accent.color
                                        font.pixelSize: 11
                                        font.family: "ComicShannsMono Nerd Font"
                                    }
                                    
                                    Button {
                                        text: modelData.muted ? "🔇 Unmute" : "🔊 Mute"
                                        font.family: "ComicShannsMono Nerd Font"
                                        font.pixelSize: 11
                                        Layout.preferredWidth: 80
                                        
                                        background: Rectangle {
                                            radius: 4
                                            color: parent.down ? theme.button.background_select : 
                                                   parent.hovered ? theme.button.background + "40" : theme.button.background
                                            border.color: theme.button.border
                                            border.width: 1
                                        }
                                        
                                        contentItem: Text {
                                            text: parent.text
                                            color: theme.primary.foreground
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            font: parent.font
                                        }
                                    }
                                    
                                    Button {
                                        text: "Set Default"
                                        font.family: "ComicShannsMono Nerd Font"
                                        font.pixelSize: 11
                                        Layout.preferredWidth: 80
                                        enabled: !modelData.default
                                        
                                        background: Rectangle {
                                            radius: 4
                                            color: parent.down ? theme.accent.color : 
                                                   parent.hovered ? theme.accent.color + "40" : theme.button.background
                                            border.color: theme.accent.color
                                            border.width: 1
                                        }
                                        
                                        contentItem: Text {
                                            text: parent.text
                                            color: modelData.default ? theme.primary.foreground : theme.accent.color
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            font: parent.font
                                        }
                                    }
                                }
                                
                                // Microphone volume slider
                                RowLayout {
                                    spacing: 10
                                    
                                    Text {
                                        text: "Mic Volume:"
                                        color: theme.primary.foreground
                                        font.pixelSize: 12
                                        font.family: "ComicShannsMono Nerd Font"
                                        Layout.preferredWidth: 80
                                    }
                                    
                                    Slider {
                                        id: micVolumeSlider
                                        Layout.fillWidth: true
                                        from: 0
                                        to: 100
                                        value: modelData.volume
                                        enabled: !modelData.muted
                                        
                                        background: Rectangle {
                                            x: parent.leftPadding
                                            y: parent.topPadding + parent.availableHeight / 2 - height / 2
                                            implicitWidth: 200
                                            implicitHeight: 3
                                            width: parent.availableWidth
                                            height: implicitHeight
                                            radius: 1.5
                                            color: theme.primary.dim_foreground + "40"
                                            
                                            Rectangle {
                                                width: parent.width * (micVolumeSlider.value / 100)
                                                height: parent.height
                                                color: theme.accent.color
                                                radius: 1.5
                                            }
                                        }
                                        
                                        handle: Rectangle {
                                            x: parent.leftPadding + parent.availableWidth * (parent.visualPosition || 0) - width / 2
                                            y: parent.topPadding + parent.availableHeight / 2 - height / 2
                                            implicitWidth: 14
                                            implicitHeight: 14
                                            radius: 7
                                            color: parent.pressed ? theme.accent.color : theme.primary.foreground
                                            border.color: theme.accent.color
                                            border.width: 2
                                        }
                                    }
                                    
                                    Text {
                                        text: Math.round(micVolumeSlider.value) + "%"
                                        color: modelData.muted ? theme.primary.dim_foreground : theme.primary.foreground
                                        font.pixelSize: 11
                                        font.family: "ComicShannsMono Nerd Font"
                                        Layout.preferredWidth: 35
                                    }
                                }
                            }
                            
                            MouseArea {
                                id: mouseAreaInput
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                            }
                        }
                    }
                }
            }
            
            // 4️⃣ Audio Profiles
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: profileContentLayout.height + 30
                radius: 8
                color: theme.primary.background
                border.color: theme.normal.black
                border.width: 1
                
                ColumnLayout {
                    id: profileContentLayout
                    width: parent.width
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 15
                    spacing: 10
                    
                    Text {
                        text: "Audio Profiles"
                        color: theme.primary.foreground
                        font.pixelSize: 18
                        font.bold: true
                        font.family: "ComicShannsMono Nerd Font"
                    }
                    
                    Flow {
                        width: parent.width
                        spacing: 10
                        
                        Repeater {
                            model: ["Stereo", "Mono", "Surround 5.1", "High Fidelity", "Voice Chat"]
                            
                            delegate: Rectangle {
                                width: 120
                                height: 40
                                radius: 6
                                color: profileMouseArea.containsMouse ? theme.accent.color + "20" : 
                                       index === 0 ? theme.accent.color : theme.button.background
                                border.color: index === 0 ? theme.accent.color : theme.button.border
                                border.width: 1
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: modelData
                                    color: index === 0 ? theme.primary.background : theme.primary.foreground
                                    font.pixelSize: 12
                                    font.family: "ComicShannsMono Nerd Font"
                                    font.bold: index === 0
                                }
                                
                                MouseArea {
                                    id: profileMouseArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        console.log("Selected profile:", modelData)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            // 5️⃣ Advanced Settings
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: advancedContentLayout.height + 30
                radius: 8
                color: theme.primary.background
                border.color: theme.normal.black
                border.width: 1
                
                ColumnLayout {
                    id: advancedContentLayout
                    width: parent.width
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 15
                    spacing: 15
                    
                    Text {
                        text: "Advanced Settings"
                        color: theme.primary.foreground
                        font.pixelSize: 18
                        font.bold: true
                        font.family: "ComicShannsMono Nerd Font"
                    }
                    
                    RowLayout {
                        spacing: 20
                        
                        ColumnLayout {
                            spacing: 10
                            
                            Text {
                                text: "Sample Rate"
                                color: theme.primary.foreground
                                font.pixelSize: 14
                                font.family: "ComicShannsMono Nerd Font"
                            }
                            
                            ComboBox {
                                id: sampleRateCombo
                                model: ["44100 Hz", "48000 Hz", "96000 Hz", "192000 Hz"]
                                currentIndex: 1
                                Layout.preferredWidth: 150
                                
                                background: Rectangle {
                                    radius: 4
                                    color: theme.button.background
                                    border.color: theme.button.border
                                    border.width: 1
                                }
                                
                                contentItem: Text {
                                    text: sampleRateCombo.displayText
                                    color: theme.primary.foreground
                                    font.pixelSize: 12
                                    font.family: "ComicShannsMono Nerd Font"
                                    verticalAlignment: Text.AlignVCenter
                                    leftPadding: 10
                                }
                            }
                        }
                        
                        ColumnLayout {
                            spacing: 10
                            
                            Text {
                                text: "Bit Depth"
                                color: theme.primary.foreground
                                font.pixelSize: 14
                                font.family: "ComicShannsMono Nerd Font"
                            }
                            
                            ComboBox {
                                id: bitDepthCombo
                                model: ["16-bit", "24-bit", "32-bit"]
                                currentIndex: 1
                                Layout.preferredWidth: 120
                                
                                background: Rectangle {
                                    radius: 4
                                    color: theme.button.background
                                    border.color: theme.button.border
                                    border.width: 1
                                }
                                
                                contentItem: Text {
                                    text: bitDepthCombo.displayText
                                    color: theme.primary.foreground
                                    font.pixelSize: 12
                                    font.family: "ComicShannsMono Nerd Font"
                                    verticalAlignment: Text.AlignVCenter
                                    leftPadding: 10
                                }
                            }
                        }
                    }
                    
                    RowLayout {
                        spacing: 20
                        
                        CheckBox {
                            id: showNotifications
                            text: "Show volume change notifications"
                            checked: true
                            font.family: "ComicShannsMono Nerd Font"
                            font.pixelSize: 12
                            
                            indicator: Rectangle {
                                implicitWidth: 16
                                implicitHeight: 16
                                radius: 3
                                border.color: theme.button.border
                                border.width: 1
                                color: theme.button.background
                                
                                Rectangle {
                                    width: 10
                                    height: 10
                                    radius: 2
                                    color: theme.accent.color
                                    visible: showNotifications.checked
                                    anchors.centerIn: parent
                                }
                            }
                            
                            contentItem: Text {
                                text: showNotifications.text
                                font: showNotifications.font
                                color: theme.primary.foreground
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: showNotifications.indicator.width + showNotifications.spacing
                            }
                        }
                        
                        CheckBox {
                            id: perAppVolume
                            text: "Enable per-application volume"
                            checked: false
                            font.family: "ComicShannsMono Nerd Font"
                            font.pixelSize: 12
                            
                            indicator: Rectangle {
                                implicitWidth: 16
                                implicitHeight: 16
                                radius: 3
                                border.color: theme.button.border
                                border.width: 1
                                color: theme.button.background
                                
                                Rectangle {
                                    width: 10
                                    height: 10
                                    radius: 2
                                    color: theme.accent.color
                                    visible: perAppVolume.checked
                                    anchors.centerIn: parent
                                }
                            }
                            
                            contentItem: Text {
                                text: perAppVolume.text
                                font: perAppVolume.font
                                color: theme.primary.foreground
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: perAppVolume.indicator.width + perAppVolume.spacing
                            }
                        }
                    }
                }
            }
        }
    }
}

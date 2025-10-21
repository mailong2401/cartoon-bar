// components/Settings/AppearanceSettings.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    property var theme: currentTheme
    
    ScrollView {
        anchors.fill: parent
        anchors.margins: 20
        clip: true
        ColumnLayout {
            width: parent.width
            spacing: 20
            Text {
                text: "Giao diện"
                color: theme.primary.foreground
                font {
                    family: "ComicShannsMono Nerd Font"
                    pixelSize: 24
                    bold: true
                }
                Layout.topMargin: 10
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: theme.primary.dim_foreground + "40"
            }
            
            // Theme Selection
            RowLayout {
                Layout.fillWidth: true
                
                Text {
                    text: "Chủ đề:"
                    color: theme.primary.foreground
                    font {
                        family: "ComicShannsMono Nerd Font"
                        pixelSize: 16
                    }
                    Layout.preferredWidth: 150
                }
                
                Row {
                    spacing: 15
                    
                    // Light Theme Card
                    Rectangle {
                        id: lightThemeCard
                        width: 100
                        height: 80
                        radius: 12
                        color: "#f5eee6"
                        border.color: theme.type === "light" ? 
                                    theme.normal.blue : theme.button.border
                        border.width: theme.type === "light" ? 3 : 2
                        
                        Column {
                            anchors.centerIn: parent
                            spacing: 6
                            
                            Rectangle {
                                width: 60
                                height: 24
                                radius: 6
                                color: "#2b2530"
                            }
                            
                            Rectangle {
                                width: 60
                                height: 10
                                radius: 3
                                color: "#b0a89e"
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: themeLoader.changeTheme("light")
                        }
                        
                        Text {
                            text: "Sáng"
                            color: "#2b2530"
                            font {
                                family: "ComicShannsMono Nerd Font"
                                pixelSize: 12
                                bold: true
                            }
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 8
                        }
                        
                        // Checkmark for selected theme
                        Rectangle {
                            visible: theme.type === "light"
                            width: 20
                            height: 20
                            radius: 10
                            color: theme.normal.blue
                            anchors.top: parent.top
                            anchors.right: parent.right
                            anchors.margins: 5
                            
                            Text {
                                text: "✓"
                                color: theme.primary.background
                                font.pixelSize: 12
                                font.bold: true
                                anchors.centerIn: parent
                            }
                        }
                    }
                    
                    // Dark Theme Card
                    Rectangle {
                        id: darkThemeCard
                        width: 100
                        height: 80
                        radius: 12
                        color: "#24273a"
                        border.color: theme.type === "dark" ? 
                                    theme.normal.blue : theme.button.border
                        border.width: theme.type === "dark" ? 3 : 2
                        
                        Column {
                            anchors.centerIn: parent
                            spacing: 6
                            
                            Rectangle {
                                width: 60
                                height: 24
                                radius: 6
                                color: "#cad3f5"
                            }
                            
                            Rectangle {
                                width: 60
                                height: 10
                                radius: 3
                                color: "#494d64"
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: themeLoader.changeTheme("dark")
                        }
                        
                        Text {
                            text: "Tối"
                            color: "#cad3f5"
                            font {
                                family: "ComicShannsMono Nerd Font"
                                pixelSize: 12
                                bold: true
                            }
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 8
                        }
                        
                        // Checkmark for selected theme
                        Rectangle {
                            visible: theme.type === "dark"
                            width: 20
                            height: 20
                            radius: 10
                            color: theme.normal.blue
                            anchors.top: parent.top
                            anchors.right: parent.right
                            anchors.margins: 5
                            
                            Text {
                                text: "✓"
                                color: theme.primary.background
                                font.pixelSize: 12
                                font.bold: true
                                anchors.centerIn: parent
                            }
                        }
                    }
                }
            }
            
            // Opacity Setting
            RowLayout {
                Layout.fillWidth: true
                spacing: 15
                
                Text {
                    text: "Độ trong suốt:"
                    color: theme.primary.foreground
                    font {
                        family: "ComicShannsMono Nerd Font"
                        pixelSize: 16
                    }
                    Layout.preferredWidth: 150
                }
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 5
                    
                    Slider {
                        id: opacitySlider
                        Layout.fillWidth: true
                        value: 0.9
                        from: 0.5
                        to: 1.0
                        
                        background: Rectangle {
                            x: opacitySlider.leftPadding
                            y: opacitySlider.topPadding + opacitySlider.availableHeight / 2 - height / 2
                            implicitWidth: 200
                            implicitHeight: 6
                            width: opacitySlider.availableWidth
                            height: implicitHeight
                            radius: 3
                            color: theme.button.background
                            
                            Rectangle {
                                width: opacitySlider.visualPosition * parent.width
                                height: parent.height
                                color: theme.normal.blue
                                radius: 3
                            }
                        }
                        
                        handle: Rectangle {
                            x: opacitySlider.leftPadding + opacitySlider.visualPosition * (opacitySlider.availableWidth - width)
                            y: opacitySlider.topPadding + opacitySlider.availableHeight / 2 - height / 2
                            implicitWidth: 22
                            implicitHeight: 22
                            radius: 11
                            color: opacitySlider.pressed ? theme.normal.blue : theme.primary.background
                            border.color: theme.normal.blue
                            border.width: 3
                            
                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                        }
                    }
                    
                    RowLayout {
                        Layout.fillWidth: true
                        
                        Text {
                            text: "50%"
                            color: theme.primary.dim_foreground
                            font {
                                family: "ComicShannsMono Nerd Font"
                                pixelSize: 12
                            }
                        }
                        
                        Item { Layout.fillWidth: true }
                        
                        Text {
                            text: Math.round(opacitySlider.value * 100) + "%"
                            color: theme.normal.blue
                            font {
                                family: "ComicShannsMono Nerd Font"
                                pixelSize: 14
                                bold: true
                            }
                        }
                        
                        Item { Layout.fillWidth: true }
                        
                        Text {
                            text: "100%"
                            color: theme.primary.dim_foreground
                            font {
                                family: "ComicShannsMono Nerd Font"
                                pixelSize: 12
                            }
                        }
                    }
                }
            }
            
            // Animation Settings
            RowLayout {
                Layout.fillWidth: true
                spacing: 15
                
                Text {
                    text: "Hiệu ứng:"
                    color: theme.primary.foreground
                    font {
                        family: "ComicShannsMono Nerd Font"
                        pixelSize: 16
                    }
                    Layout.preferredWidth: 150
                }
                
                Column {
                    Layout.fillWidth: true
                    spacing: 12
                    
                    // Custom CheckBox for Motion Effects
                    Row {
                        spacing: 12
                        
                        Rectangle {
                            id: motionCheck
                            width: 24
                            height: 24
                            radius: 6
                            border.color: theme.normal.blue
                            border.width: 2
                            color: motionCheckArea.containsMouse ? theme.normal.blue + "20" : "transparent"
                            
                            Rectangle {
                                width: 12
                                height: 12
                                anchors.centerIn: parent
                                radius: 3
                                color: theme.normal.blue
                                visible: true
                            }
                            
                            MouseArea {
                                id: motionCheckArea
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onClicked: {
                                    // Toggle logic here
                                }
                            }
                        }
                        
                        Text {
                            text: "Hiệu ứng chuyển động"
                            color: theme.primary.foreground
                            font {
                                family: "ComicShannsMono Nerd Font"
                                pixelSize: 16
                            }
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                    
                    // Custom CheckBox for Transparency Effects
                    Row {
                        spacing: 12
                        
                        Rectangle {
                            id: transparencyCheck
                            width: 24
                            height: 24
                            radius: 6
                            border.color: theme.button.border
                            border.width: 2
                            color: transparencyCheckArea.containsMouse ? theme.button.background + "80" : "transparent"
                            
                            Rectangle {
                                width: 12
                                height: 12
                                anchors.centerIn: parent
                                radius: 3
                                color: theme.normal.blue
                                visible: false
                            }
                            
                            MouseArea {
                                id: transparencyCheckArea
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onClicked: {
                                    // Toggle logic here
                                }
                            }
                        }
                        
                        Text {
                            text: "Hiệu ứng trong suốt"
                            color: theme.primary.foreground
                            font {
                                family: "ComicShannsMono Nerd Font"
                                pixelSize: 16
                            }
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                    
                    // Custom CheckBox for Blur Effects
                    Row {
                        spacing: 12
                        
                        Rectangle {
                            id: blurCheck
                            width: 24
                            height: 24
                            radius: 6
                            border.color: theme.normal.blue
                            border.width: 2
                            color: blurCheckArea.containsMouse ? theme.normal.blue + "20" : "transparent"
                            
                            Rectangle {
                                width: 12
                                height: 12
                                anchors.centerIn: parent
                                radius: 3
                                color: theme.normal.blue
                                visible: true
                            }
                            
                            MouseArea {
                                id: blurCheckArea
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onClicked: {
                                    // Toggle logic here
                                }
                            }
                        }
                        
                        Text {
                            text: "Hiệu ứng mờ"
                            color: theme.primary.foreground
                            font {
                                family: "ComicShannsMono Nerd Font"
                                pixelSize: 16
                            }
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }
            
            // Additional Appearance Settings
            RowLayout {
                Layout.fillWidth: true
                spacing: 15
                
                Text {
                    text: "Font chữ:"
                    color: theme.primary.foreground
                    font {
                        family: "ComicShannsMono Nerd Font"
                        pixelSize: 16
                    }
                    Layout.preferredWidth: 150
                }
                
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 45
                    radius: 8
                    color: theme.button.background
                    border.color: theme.button.border
                    border.width: 2
                    
                    Text {
                        text: "ComicShannsMono Nerd Font"
                        color: theme.primary.foreground
                        font {
                            family: "ComicShannsMono Nerd Font"
                            pixelSize: 14
                        }
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 15
                    }
                    
                    Rectangle {
                        width: 30
                        height: 30
                        radius: 6
                        color: theme.button.background_select
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        
                        Text {
                            text: "⋯"
                            color: theme.primary.foreground
                            font.pixelSize: 16
                            font.bold: true
                            anchors.centerIn: parent
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                // Open font picker
                            }
                        }
                    }
                }
            }
            
            Item { Layout.fillHeight: true } // Spacer
        }
    }
}

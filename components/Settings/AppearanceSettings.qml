// components/Settings/AppearanceSettings.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "."

Item {
  property var theme: currentTheme

    signal toggleClockPanel()

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

              RowLayout {
                Layout.fillWidth: true
                spacing: 10
                
                Text {
                  text: "bảng đồng hồ: "
                    color: theme.primary.foreground
                    font.family: "ComicShannsMono Nerd Font"
                    font.pixelSize: 18
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                }
                
                Item { Layout.fillWidth: true }  // Spacer, đẩy Switch sang phải
                
                Switch {
                    id: autoStartSwitch
                    checked: clockPanelVisible
                    onCheckedChanged: {
                        toggleClockPanel()
                    }
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignRight

                    background: Rectangle {
                        implicitWidth: 48
                        implicitHeight: 28
                        radius: 14
                        color: autoStartSwitch.checked ? theme.normal.green : theme.button.background
                        border.color: autoStartSwitch.checked ? theme.normal.green : theme.button.border
                        border.width: 2
                    }
                    indicator: Rectangle {
                        x: autoStartSwitch.checked ? parent.background.width - width - 4 : 4
                        y: (parent.background.height - height) / 2
                        width: 20
                        height: 20
                        radius: 10
                        color: theme.primary.background
                        
                        Behavior on x {
                            NumberAnimation { duration: 150 }
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
                        
            // Additional Appearance Settings
                        
            Item { Layout.fillHeight: true } // Spacer
        }
    }
}

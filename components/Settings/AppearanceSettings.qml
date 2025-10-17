// components/Settings/AppearanceSettings.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    property var theme
    
    ScrollView {
        anchors.fill: parent
        anchors.margins: 20
        clip: true
        
        ColumnLayout {
            width: parent.width
            spacing: 15
            
            Text {
                text: "Giao diện"
                color: theme.primary.foreground
                font.pixelSize: 24
                font.bold: true
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
                    font.pixelSize: 14
                    Layout.preferredWidth: 150
                }
                
                Row {
                    spacing: 10
                    
                    Rectangle {
                        width: 80
                        height: 60
                        radius: 8
                        color: "#f5eee6"
                        border.color: theme.type === "light" ? 
                                    theme.normal.blue : "transparent"
                        border.width: 3
                        
                        Column {
                            anchors.centerIn: parent
                            spacing: 4
                            
                            Rectangle {
                                width: 50
                                height: 20
                                radius: 4
                                color: "#2b2530"
                            }
                            
                            Rectangle {
                                width: 50
                                height: 8
                                radius: 2
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
                            font.pixelSize: 10
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 5
                        }
                    }
                    
                    Rectangle {
                        width: 80
                        height: 60
                        radius: 8
                        color: "#24273a"
                        border.color: theme.type === "dark" ? 
                                    theme.normal.blue : "transparent"
                        border.width: 3
                        
                        Column {
                            anchors.centerIn: parent
                            spacing: 4
                            
                            Rectangle {
                                width: 50
                                height: 20
                                radius: 4
                                color: "#cad3f5"
                            }
                            
                            Rectangle {
                                width: 50
                                height: 8
                                radius: 2
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
                            font.pixelSize: 10
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 5
                        }
                    }
                }
            }
            
            // Opacity Setting
            RowLayout {
                Layout.fillWidth: true
                
                Text {
                    text: "Độ trong suốt:"
                    color: theme.primary.foreground
                    font.pixelSize: 14
                    Layout.preferredWidth: 150
                }
                
                Slider {
                    id: opacitySlider
                    Layout.fillWidth: true
                    value: 0.9
                    from: 0.5
                    to: 1.0
                    background: Rectangle {
                        color: theme.button.background
                        radius: 3
                        height: 6
                    }
                    handle: Rectangle {
                        width: 20
                        height: 20
                        radius: 10
                        color: theme.normal.blue
                        border.color: theme.button.border
                    }
                }
                
                Text {
                    text: Math.round(opacitySlider.value * 100) + "%"
                    color: theme.primary.dim_foreground
                    font.pixelSize: 12
                    Layout.preferredWidth: 40
                }
            }
            
            // Animation Settings
            RowLayout {
                Layout.fillWidth: true
                
                Text {
                    text: "Hiệu ứng:"
                    color: theme.primary.foreground
                    font.pixelSize: 14
                    Layout.preferredWidth: 150
                }
                
                Column {
                    Layout.fillWidth: true
                    spacing: 8
                    
                    CheckBox {
                        text: "Hiệu ứng chuyển động"
                        checked: true
                    }
                    CheckBox {
                        text: "Hiệu ứng trong suốt"
                        checked: false
                    }
                    CheckBox {
                        text: "Hiệu ứng mờ"
                        checked: true
                    }
                }
            }
            
            Item { Layout.fillHeight: true } // Spacer
        }
    }
}

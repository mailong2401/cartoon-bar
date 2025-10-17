// components/SettingsPanel.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: settingsPanel
    property var theme
    radius: 12
    color: theme.primary.background
    // Shadow effect
    layer.enabled: true
    RowLayout {
        anchors.fill: parent
        spacing: 0
        // Sidebar
        SidebarSettings {

        }
        // Content Area
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
            
            StackLayout {
                id: settingsStack
                anchors.fill: parent
                anchors.margins: 20
                currentIndex: settingsListView.currentIndex
                
                // General Settings
                Item {
                    id: generalSettings
                    
                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 15
                        
                        Text {
                            text: "Cài đặt chung"
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
                        
                        // Language Setting
                        RowLayout {
                            Layout.fillWidth: true
                            
                            Text {
                                text: "Ngôn ngữ:"
                                color: theme.primary.foreground
                                font.pixelSize: 14
                                Layout.preferredWidth: 150
                            }
                            
                            ComboBox {
                                id: languageCombo
                                Layout.preferredWidth: 200   // chiều rộng mong muốn
                                Layout.preferredHeight: 40   // chiều cao mong muốn
                                Layout.fillWidth: true
                                model: ["Tiếng Việt", "English", "中文", "日本語"]
                                background: Rectangle {
                                    color: theme.button.background
                                    border.color: theme.button.border
                                    radius: 6
                                }
                                popup.background: Rectangle {
                                    color: theme.primary.background
                                    border.color: theme.button.border
                                }
                            }
                        }
                        
                        // Auto-start
                        RowLayout {
                            Layout.fillWidth: true
                            
                            Text {
                                text: "Tự động khởi chạy:"
                                color: theme.primary.foreground
                                font.pixelSize: 14
                                Layout.preferredWidth: 150
                            }
                            
                            Switch {
                                checked: true
                                background: Rectangle {
                                    color: theme.button.background
                                    radius: 12
                                }
                            }
                        }
                        
                        // Notification Settings
                        RowLayout {
                            Layout.fillWidth: true
                            
                            Text {
                                text: "Thông báo:"
                                color: theme.primary.foreground
                                font.pixelSize: 14
                                Layout.preferredWidth: 150
                            }
                            
                            Column {
                                Layout.fillWidth: true
                                spacing: 8
                                
                                CheckBox {
                                    text: "Hiển thị thông báo hệ thống"
                                    checked: true
                                }
                                CheckBox {
                                    text: "Âm thanh thông báo"
                                    checked: false
                                }
                                CheckBox {
                                    text: "Thông báo hiệu suất"
                                    checked: true
                                }
                            }
                        }
                        
                        Item { Layout.fillHeight: true } // Spacer
                    }
                }
                
                // Appearance Settings
                Item {
                    id: appearanceSettings
                    
                    ColumnLayout {
                        anchors.fill: parent
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
                                    color: theme.type === "light" ? "#f5eee6" : "#24273a"
                                    border.color: theme.type === "light"  ? 
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
                                    color: theme.type === "dark" ? "#f5eee6" : "#24273a"
                                    border.color: theme.currentTheme === "dark" ? 
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
                
                // Network Settings
                Item {
                    id: networkSettings
                    
                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 15
                        
                        Text {
                            text: "Mạng"
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
                        
                        // Network content would go here
                        Text {
                            text: "Cài đặt mạng sẽ được hiển thị ở đây"
                            color: theme.primary.dim_foreground
                            font.pixelSize: 14
                            Layout.alignment: Qt.AlignCenter
                            Layout.fillHeight: true
                        }
                    }
                }
                
                // Other settings categories would follow the same pattern...
            }
        }
    }
    
    // Properties
    property string currentCategory: "general"
    property ListView settingsListView: ListView {
        id: settingsListView
        model: 8 // Number of categories
        currentIndex: 0
    }
    
}

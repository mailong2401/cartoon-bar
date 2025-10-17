// components/SettingsPanel.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
            id: sidebar
            Layout.preferredWidth: 200
            Layout.fillHeight: true
            color: theme.primary.dim_background
            radius: 12
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 5
                
                Text {
                    text: "Cài đặt"
                    color: theme.primary.foreground
                    font.pixelSize: 18
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 10
                    Layout.bottomMargin: 20
                }
                
                // Settings Categories
                Repeater {
                    model: ListModel {
                        ListElement { name: "Chung"; icon: "⚙️"; category: "general" }
                        ListElement { name: "Giao diện"; icon: "🎨"; category: "appearance" }
                        ListElement { name: "Mạng"; icon: "🌐"; category: "network" }
                        ListElement { name: "Âm thanh"; icon: "🔊"; category: "audio" }
                        ListElement { name: "Hiệu suất"; icon: "📊"; category: "performance" }
                        ListElement { name: "Phím tắt"; icon: "⌨️"; category: "shortcuts" }
                        ListElement { name: "Ứng dụng"; icon: "📱"; category: "applications" }
                        ListElement { name: "Hệ thống"; icon: "💻"; category: "system" }
                    }
                    
                    delegate: Rectangle {
                        id: categoryDelegate
                        Layout.fillWidth: true
                        height: 45
                        radius: 8
                        color: settingsListView.currentIndex === index ? 
                               theme.button.background_select : "transparent"
                        border.color: settingsListView.currentIndex === index ? 
                                     theme.button.border_select : "transparent"
                        border.width: 2
                        
                        Row {
                            spacing: 12
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 15
                            
                            Text {
                                text: model.icon
                                color: theme.primary.foreground
                                font.pixelSize: 16
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            
                            Text {
                                text: model.name
                                color: theme.primary.foreground
                                font.pixelSize: 14
                                font.bold: settingsListView.currentIndex === index
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                settingsListView.currentIndex = index
                                currentCategory = model.category
                            }
                            onEntered: {
                                if (settingsListView.currentIndex !== index) {
                                    categoryDelegate.color = theme.button.background + "80"
                                }
                            }
                            onExited: {
                                if (settingsListView.currentIndex !== index) {
                                    categoryDelegate.color = "transparent"
                                }
                            }
                        }
                    }
                }
                
                Item { Layout.fillHeight: true } // Spacer
                
                // Close Button
                Rectangle {
                    Layout.fillWidth: true
                    height: 45
                    radius: 8
                    color: theme.normal.red + "40"
                    border.color: theme.normal.red
                    border.width: 1
                    
                    Text {
                        text: "Đóng ❌"
                        color: theme.normal.red
                        font.pixelSize: 14
                        font.bold: true
                        anchors.centerIn: parent
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: settingsPanel.visible = false
                        onEntered: parent.color = theme.normal.red + "60"
                        onExited: parent.color = theme.normal.red + "40"
                    }
                }
            }
        }

// components/Settings/GeneralSettings.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../"

Item {
    property var theme : currentTheme
    
    ScrollView {
        anchors.fill: parent
        anchors.margins: 20
        clip: true
        
        ColumnLayout {
            width: parent.width
            spacing: 15
            
            Text {
                text: "Cài đặt chung"
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
            
            // Language Setting
            RowLayout {
                Layout.fillWidth: true
                
                Text {
                    text: "Ngôn ngữ:"
                    color: theme.primary.foreground
                    font {
                        family: "ComicShannsMono Nerd Font"
                        pixelSize: 18
                    }
                    Layout.preferredWidth: 150
                }
                
                // Sử dụng ComboBox thường trước, sau đó sẽ custom
                ComboBox {
                    id: languageCombo
                    Layout.preferredWidth: 250
                    Layout.preferredHeight: 45
                    model: ["Tiếng Việt", "English", "한국어", "日本語", "中文"]
                    
                    background: Rectangle {
                        color: theme.button.background
                        border.color: theme.button.border
                        border.width: 2
                        radius: 8
                    }
                    
                    contentItem: Text {
                        text: languageCombo.displayText
                        color: theme.primary.foreground
                        font.pixelSize: 16
                        font.family: "ComicShannsMono Nerd Font"
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        elide: Text.ElideRight
                        leftPadding: 15
                    }
                    
                    popup: Popup {
                        y: languageCombo.height - 1
                        width: languageCombo.width
                        implicitHeight: contentItem.implicitHeight
                        padding: 1
                        
                        background: Rectangle {
                            color: theme.primary.background
                            border.color: theme.button.border
                            border.width: 2
                            radius: 8
                        }
                        
                        contentItem: ListView {
                            clip: true
                            implicitHeight: contentHeight
                            model: languageCombo.popup.visible ? languageCombo.delegateModel : null
                            currentIndex: languageCombo.highlightedIndex
                            
                            delegate: ItemDelegate {
                                width: languageCombo.width
                                text: modelData
                                font.family: "ComicShannsMono Nerd Font"
                                font.pixelSize: 16
                                highlighted: languageCombo.highlightedIndex === index
                                background: Rectangle {
                                    color: highlighted ? theme.button.background_select : 
                                           hovered ? theme.button.background + "80" : "transparent"
                                    radius: 6
                                }
                            }
                            
                            ScrollIndicator.vertical: ScrollIndicator { }
                        }
                    }
                    
                    // Sự kiện chọn ngôn ngữ
                    onActivated: (index) => {
                      switch (index) {
        case 0:
            languageLoader.changeLanguage("vi")
            break
        case 1:
            languageLoader.changeLanguage("en")
            break
        case 2:
            languageLoader.changeLanguage("kr")
            break
        case 3:
            languageLoader.changeLanguage("ja")
            break
        case 4:
            languageLoader.changeLanguage("zh")
            break
        }
                    }
                }
            }
            
            // Auto-start
            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                
                Text {
                    text: "Tự động khởi chạy:"
                    color: theme.primary.foreground
                    font.family: "ComicShannsMono Nerd Font"
                    font.pixelSize: 18
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                }
                
                Item { Layout.fillWidth: true }  // Spacer, đẩy Switch sang phải
                
                Switch {
                    id: autoStartSwitch
                    checked: true
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
            
            // Notification Settings
            RowLayout {
                Layout.fillWidth: true
                
                Text {
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                    text: "Thông báo:"
                    color: theme.primary.foreground
                    font {
                        family: "ComicShannsMono Nerd Font"
                        pixelSize: 18
                    }
                    Layout.preferredWidth: 150
                }
                
                Column {
                    Layout.fillWidth: true
                    spacing: 8
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                    
                    // Custom CheckBox đơn giản
                    Row {
                        spacing: 10
                        
                        Rectangle {
                            width: 24
                            height: 24
                            radius: 6
                            border.color: theme.button.border
                            border.width: 2
                            color: "transparent"
                            
                            Rectangle {
                                width: 12
                                height: 12
                                anchors.centerIn: parent
                                radius: 3
                                color: theme.normal.blue
                                visible: true // Thay bằng property checked
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    // Toggle logic here
                                }
                            }
                        }
                        
                        Text {
                            text: "Hiển thị thông báo hệ thống"
                            color: theme.primary.foreground
                            font.family: "ComicShannsMono Nerd Font"
                            font.pixelSize: 16
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                    
                    Row {
                        spacing: 10
                        
                        Rectangle {
                            width: 24
                            height: 24
                            radius: 6
                            border.color: theme.button.border
                            border.width: 2
                            color: "transparent"
                            
                            Rectangle {
                                width: 12
                                height: 12
                                anchors.centerIn: parent
                                radius: 3
                                color: theme.normal.blue
                                visible: false // Thay bằng property checked
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    // Toggle logic here
                                }
                            }
                        }
                        
                        Text {
                            text: "Âm thanh thông báo"
                            color: theme.primary.foreground
                            font.family: "ComicShannsMono Nerd Font"
                            font.pixelSize: 16
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                    
                    Row {
                        spacing: 10
                        
                        Rectangle {
                            width: 24
                            height: 24
                            radius: 6
                            border.color: theme.button.border
                            border.width: 2
                            color: "transparent"
                            
                            Rectangle {
                                width: 12
                                height: 12
                                anchors.centerIn: parent
                                radius: 3
                                color: theme.normal.blue
                                visible: true // Thay bằng property checked
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    // Toggle logic here
                                }
                            }
                        }
                        
                        Text {
                            text: "Thông báo hiệu suất"
                            color: theme.primary.foreground
                            font.family: "ComicShannsMono Nerd Font"
                            font.pixelSize: 16
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }
            
            Item { Layout.fillHeight: true } // Spacer
        }
    }
}

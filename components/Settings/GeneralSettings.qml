// components/Settings/GeneralSettings.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ".." as Components


Item {
    property var theme: currentTheme
    property var lang: currentLanguage
    property var panelConfig  // Received from parent SettingsPanel

    property Timer reloadTimer: Timer {
        interval: 30
        repeat: false
        onTriggered: languageLoader.loadLanguage()
    }

    function setLanguageEditor(name) {
        panelConfig.set("lang",name)
        reloadTimer.restart()
    }
    
    ScrollView {
        anchors.fill: parent
        anchors.margins: 20
        clip: true
        
        ColumnLayout {
            width: parent.width
            spacing: 15
            
            Text {
                text: lang.general?.title || "Cài đặt chung"
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
            
            // Language Selection
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 10

                Text {
                    text: lang.general?.language_label || "Ngôn ngữ:"
                    color: theme.primary.foreground
                    font {
                        family: "ComicShannsMono Nerd Font"
                        pixelSize: 16
                    }
                }

                Grid {
                    Layout.fillWidth: true
                    columns: 5
                    columnSpacing: 8
                    rowSpacing: 8

                    Repeater {
                        model: [
  { code: "vi", name: "Tiếng Việt", flagImg: "vietnam" },
  { code: "en", name: "English", flagImg: "britain" },
  { code: "zh", name: "中文", flagImg: "china" },
  { code: "ja", name: "日本語", flagImg: "japan" },
  { code: "kr", name: "한국어", flagImg: "korea" },
  { code: "ru", name: "Русский", flagImg: "russia" },
  { code: "hi", name: "हिन्दी", flagImg: "india" },
  { code: "es", name: "Español", flagImg: "spain" },
  { code: "pt", name: "Português", flagImg: "portugal" },
  { code: "fr", name: "Français", flagImg: "france" },
  { code: "de", name: "Deutsch", flagImg: "german" },
  { code: "it", name: "Italiano", flagImg: "italy" },
  { code: "ar", name: "العربية", flagImg: "saudi_arabia" },
  { code: "tr", name: "Türkçe", flagImg: "turkey" },
  { code: "nl", name: "Nederlands", flagImg: "netherlands" },
]


                        delegate: Rectangle {
                            width: 90
                            height: 70
                            radius: 10
                            color: currentConfig.lang === modelData.code ? theme.normal.blue : (langMouseArea.containsMouse ? theme.button.background_select : theme.button.background)
                            border.color: currentConfig.lang === modelData.code ? theme.normal.blue : (langMouseArea.containsPress ? theme.button.border_select : theme.button.border)
                            border.width: 2

                            Column {
                                anchors.centerIn: parent
                                spacing: 4

                                Image {
                                    source: `../../assets/flags/${modelData.flagImg}.png`
                                    width: 48
                                    height: 32
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: modelData.name
                                    color: currentConfig.lang === modelData.code ? theme.primary.background : theme.primary.foreground
                                    font {
                                        family: "ComicShannsMono Nerd Font"
                                        pixelSize: 11
                                        bold: currentConfig.lang === modelData.code
                                    }
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }

                            MouseArea {
                                id: langMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    setLanguageEditor(modelData.code)
                                    
                                }
                            }

                            // Checkmark for selected language
                            Rectangle {
                                visible: currentConfig.lang === modelData.code
                                width: 18
                                height: 18
                                radius: 9
                                color: theme.normal.blue
                                anchors.top: parent.top
                                anchors.right: parent.right
                                anchors.margins: 4

                                Text {
                                    text: "✓"
                                    color: theme.primary.background
                                    font.pixelSize: 11
                                    font.bold: true
                                    anchors.centerIn: parent
                                }
                            }
                        }
                    }
                }
            }
            
            // Auto-start
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Text {
                    text: lang.general?.autostart_label || "Tự động khởi chạy:"
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
                        color: autoStartSwitch.checked ? theme.normal.blue : theme.button.background
                        border.color: autoStartSwitch.checked ? theme.normal.blue : theme.button.border
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
                    text: lang.general?.notification_label || "Thông báo:"
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
                            text: lang.general?.notification_system || "Hiển thị thông báo hệ thống"
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
                            text: lang.general?.notification_sound || "Âm thanh thông báo"
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
                            text: lang.general?.notification_performance || "Thông báo hiệu suất"
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

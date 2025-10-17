// components/Settings/GeneralSettings.qml
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
                
                ComboBox {
                  id: languageCombo
                  Layout.preferredWidth: 200
                  Layout.preferredHeight: 40
                  Layout.fillWidth: true
                  model: ["Tiếng Việt", "English", "中文", "日本語"]

                  background: Rectangle {
                      color: theme.button.background
                      border.color: theme.button.border
                      radius: 6
                  }

                  contentItem: Text {
                      text: languageCombo.displayText
                      color: theme.primary.foreground
                      font.pixelSize: 18
                      font.family: "ComicShannsMono Nerd Font"
                      verticalAlignment: Text.AlignVCenter
                      horizontalAlignment: Text.AlignHCenter
                      elide: Text.ElideRight
                  }

                  popup.background: Rectangle {
                      color: theme.primary.background
                      border.color: theme.button.border
                  }

                  // ---- Sự kiện chọn ngôn ngữ ----
                  onActivated: (index) => {
    switch (index) {
    case 0:
        currentLanguage.changeLanguage("vi")
        break
    case 1:
        currentLanguage.changeLanguage("en")
        break
    case 2:
        currentLanguage.changeLanguage("kr")
        break
    case 3:
        currentLanguage.changeLanguage("ja")
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
                    checked: true
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
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
}

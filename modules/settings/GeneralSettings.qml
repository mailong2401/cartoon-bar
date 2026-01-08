// components/Settings/GeneralSettings.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../utils/components" as Utils


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
        anchors.margins: currentSizes.generalSettings?.margin || 20
        clip: true
        
        ColumnLayout {
            width: parent.width
            spacing: currentSizes.generalSettings?.spacing || 15
            
            Text {
                text: lang.general?.title || "Cài đặt chung"
                color: theme.primary.foreground
                font {
                    family: "ComicShannsMono Nerd Font"
                    pixelSize: currentSizes.generalSettings?.titleFontSize || 24
                    bold: true
                }
                Layout.topMargin: currentSizes.spacing?.normal || 10
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: theme.primary.dim_foreground + "40"
            }
            
            // Language Selection
            ColumnLayout {
                Layout.fillWidth: true
                spacing: currentSizes.spacing?.normal || 10

                Text {
                    text: lang.general?.language_label || "Ngôn ngữ:"
                    color: theme.primary.foreground
                    font {
                        family: "ComicShannsMono Nerd Font"
                        pixelSize: currentSizes.generalSettings?.labelFontSize || 16
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
  { code: "pl", name: "Polski", flagImg: "poland" },
  { code: "sv", name: "Svenska", flagImg: "sweden" },
  { code: "th", name: "ไทย", flagImg: "thailand" },
  { code: "uk", name: "Українська", flagImg: "ukraine" },
  { code: "no", name: "Norsk", flagImg: "norway" },
  { code: "da", name: "Dansk", flagImg: "denmark" },
  { code: "fi", name: "Suomi", flagImg: "finland" },
  { code: "id", name: "Indonesia", flagImg: "indonesia" },
  { code: "cs", name: "Čeština", flagImg: "czech" },
  { code: "el", name: "Ελληνικά", flagImg: "greece" },
  { code: "he", name: "עברית", flagImg: "israel" },
  { code: "ro", name: "Română", flagImg: "romania" },
  { code: "hu", name: "Magyar", flagImg: "hungary" },
  { code: "bg", name: "Български", flagImg: "bulgaria" },
  { code: "sk", name: "Slovenčina", flagImg: "slovakia" },
]


                        delegate: Rectangle {
                            width: currentSizes.generalSettings?.languageItemWidth || 85
                            height: currentSizes.generalSettings?.languageItemHeight || 70
                            radius: currentSizes.generalSettings?.languageItemRadius || 10
                            color: currentConfig.lang === modelData.code ? theme.normal.blue : (langMouseArea.containsMouse ? theme.button.background_select : theme.button.background)
                            border.color: currentConfig.lang === modelData.code ? theme.normal.blue : (langMouseArea.containsPress ? theme.button.border_select : theme.button.border)
                            border.width: 2

                            Column {
                                anchors.centerIn: parent
                                spacing: 4

                                Image {
                                    source: `../../assets/flags/${modelData.flagImg}.png`
                                    width: currentSizes.generalSettings?.flagImageWidth || 48
                                    height: currentSizes.generalSettings?.flagImageHeight || 32
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: modelData.name
                                    color: currentConfig.lang === modelData.code ? theme.primary.background : theme.primary.foreground
                                    font {
                                        family: "ComicShannsMono Nerd Font"
                                        pixelSize: currentSizes.generalSettings?.languageNameFontSize || 11
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
                                width: currentSizes.generalSettings?.checkmarkSize || 18
                                height: currentSizes.generalSettings?.checkmarkSize || 18
                                radius: currentSizes.generalSettings?.checkmarkRadius || 9
                                color: theme.normal.blue
                                anchors.top: parent.top
                                anchors.right: parent.right
                                anchors.margins: currentSizes.generalSettings?.checkmarkMargin || 4

                                Text {
                                    text: "✓"
                                    color: theme.primary.background
                                    font.pixelSize: currentSizes.fontSize?.small || 11
                                    font.bold: true
                                    anchors.centerIn: parent
                                }
                            }
                        }
                    }
                }
            }   
            Item { Layout.fillHeight: true } // Spacer
        }
    }
}

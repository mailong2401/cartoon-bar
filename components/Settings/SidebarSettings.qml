import QtQuick
import QtQuick.Layouts

Rectangle {
    id: sidebarSettings
    property var theme : currentTheme
    property var lang : currentLanguage
    property int currentIndex: 0
    signal categoryChanged(int index)
    signal backRequested()

    Layout.preferredWidth: currentSizes.settingsPanel?.sidebarWidth || 200
    Layout.fillHeight: true
    color: theme.primary.dim_background
    radius: currentSizes.settingsPanel?.sidebarRadius || currentSizes.radius?.normal || 12
    border.color: theme.normal.black
    border.width: 2

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: currentSizes.settingsPanel?.sidebarMargins || 12
        spacing: currentSizes.settingsPanel?.sidebarSpacing || 10

        Text {
            text: lang.settings.title
            color: theme.primary.foreground
            font {
                family: "ComicShannsMono Nerd Font"
                pixelSize: currentSizes.settingsPanel?.sidebarTitleFontSize || currentSizes.fontSize?.xlarge || 26
                bold: true
            }
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: currentSizes.settingsPanel?.sidebarTitleTopMargin || currentSizes.spacing?.medium || 15
            Layout.bottomMargin: currentSizes.settingsPanel?.sidebarTitleBottomMargin || currentSizes.spacing?.large || 25
        }

        // Danh mục cài đặt
        Repeater {
            model: [
                { name: lang.settings.general, icon: "../../assets/settings/home.png", category: "general" },
                { name: lang.settings.appearance, icon: "../../assets/settings/paint-brush.png", category: "appearance" },
                { name: lang.settings.wallpapers, icon: "../../assets/settings/Wallpaper.png", category: "wallpaper" },
                { name: lang.settings.network, icon: "../../assets/settings/network.png", category: "network" },
                { name: lang.settings.audio, icon: "../../assets/settings/volume.png", category: "audio" },
                { name: lang.settings.performance, icon: "../../assets/settings/speedometer.png", category: "performance" },
                { name: lang.settings.shortcuts, icon: "../../assets/settings/keyboard.png", category: "shortcuts" },
                { name: lang.settings.system, icon: "../../assets/settings/mark.png", category: "system" }
            ]

            delegate: Rectangle {
                id: categoryDelegate
                Layout.fillWidth: true
                Layout.preferredHeight: currentSizes.settingsPanel?.sidebarCategoryItemHeight || 50
                radius: currentSizes.settingsPanel?.sidebarCategoryItemRadius || currentSizes.radius?.small || 8
                
                property bool hovered: false
                property bool selected: sidebarSettings.currentIndex === index

                color: mouseArea.containsPress ? theme.button.background_select : 
                       hovered ? theme.button.background_select + "80" : 
                       selected ? theme.button.background_select : theme.button.background
                
                border.color: mouseArea.containsPress ? theme.button.border_select : 
                             hovered ? theme.normal.blue : 
                             selected ? theme.button.border_select : theme.button.border
                border.width: 2
                
                // Hiệu ứng scale
                scale: mouseArea.containsPress ? 0.98 : 1.0
                Behavior on scale { NumberAnimation { duration: 100 } }
                
                // Hiệu ứng màu
                Behavior on color { ColorAnimation { duration: 200 } }
                Behavior on border.color { ColorAnimation { duration: 100 } }

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: currentSizes.settingsPanel?.sidebarCategoryItemMargins || currentSizes.spacing?.normal || 8
                    spacing: currentSizes.settingsPanel?.sidebarCategoryItemSpacing || currentSizes.spacing?.medium || 12
                    
                    Image {
                        source: modelData.icon
                        Layout.preferredHeight: currentSizes.settingsPanel?.sidebarCategoryIconSize || currentSizes.iconSize?.normal || 28
                        Layout.preferredWidth: currentSizes.settingsPanel?.sidebarCategoryIconSize || currentSizes.iconSize?.normal || 28
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        
                        // Hiệu ứng xoay icon khi hover
                        rotation: hovered ? (index % 2 === 0 ? 10 : -10) : 0
                        Behavior on rotation { 
                            NumberAnimation { 
                                duration: 300; 
                                easing.type: Easing.OutBack 
                            } 
                        }
                        
                        // Hiệu ứng scale icon khi hover
                        scale: hovered ? 1.1 : 1.0
                        Behavior on scale { 
                            NumberAnimation { 
                                duration: 200; 
                                easing.type: Easing.OutCubic 
                            } 
                        }
                    }

                    Text {
                        text: modelData.name
                        color: hovered ? theme.primary.bright_foreground : 
                               selected ? theme.primary.bright_foreground : theme.primary.foreground
                        font {
                            family: "ComicShannsMono Nerd Font"
                            pixelSize: currentSizes.settingsPanel?.sidebarCategoryFontSize || currentSizes.fontSize?.medium || 16
                            bold: selected || hovered
                        }
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        
                        // Hiệu ứng scale text khi hover
                        scale: hovered ? 1.05 : 1.0
                        Behavior on scale { 
                            NumberAnimation { 
                                duration: 200; 
                                easing.type: Easing.OutCubic 
                            } 
                        }
                        Behavior on color { ColorAnimation { duration: 200 } }
                    }
                    
                    // Indicator khi selected
                    Rectangle {
                        Layout.preferredWidth: currentSizes.settingsPanel?.sidebarCategoryIndicatorWidth || 4
                        Layout.preferredHeight: currentSizes.settingsPanel?.sidebarCategoryIndicatorHeight || 20
                        radius: 2
                        color: theme.normal.blue
                        visible: selected
                        opacity: hovered ? 1.0 : 0.8
                        
                        // Hiệu ứng xuất hiện
                        scale: selected ? 1.0 : 0.0
                        Behavior on scale { 
                            NumberAnimation { 
                                duration: 300; 
                                easing.type: Easing.OutBack 
                            } 
                        }
                        Behavior on opacity { NumberAnimation { duration: 200 } }
                    }
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        sidebarSettings.currentIndex = index
                        sidebarSettings.categoryChanged(index)
                    }

                    onEntered: categoryDelegate.hovered = true
                    onExited: categoryDelegate.hovered = false
                }
            }
        }

        Item { Layout.fillHeight: true } // Spacer
    }
}
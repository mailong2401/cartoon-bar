// components/Settings/SidebarSettings.qml
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: sidebarSettings
    property var theme : currentTheme
    property var lang : currentLanguage
    property int currentIndex: 0
    signal categoryChanged(int index)
    signal backRequested()

    Layout.preferredWidth: 200
    Layout.fillHeight: true
    color: theme.primary.dim_background
    radius: 12
    border.color: theme.normal.black
    border.width: 2

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        Text {
            text: lang.settings.title
            color: theme.primary.foreground
            font {
                family: "ComicShannsMono Nerd Font"
                pixelSize: 26
                bold: true
            }
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 15
            Layout.bottomMargin: 25
        }

        // Danh mục cài đặt
        Repeater {
            model: [
                { name: lang.settings.general, icon: "../../assets/settings/home.png", category: "general" },
                { name: lang.settings.appearance, icon: "../../assets/settings/paint-brush.png", category: "appearance" },
                { name: lang.settings.network, icon: "../../assets/settings/network.png", category: "network" },
                { name: lang.settings.audio, icon: "../../assets/settings/volume.png", category: "audio" },
                { name: lang.settings.performance, icon: "../../assets/settings/speedometer.png", category: "performance" },
                { name: lang.settings.shortcuts, icon: "../../assets/settings/keyboard.png", category: "shortcuts" },
                { name: lang.settings.system, icon: "../../assets/settings/mark.png", category: "system" }
            ]

            delegate: Rectangle {
                id: categoryDelegate
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                radius: 8
                
                property bool hovered: false
                property bool selected: sidebarSettings.currentIndex === index

                color: mouseArea.containsPress ? theme.button.background_select : 
                       hovered ? theme.button.background_select + "80" : 
                       selected ? theme.button.background_select : theme.button.background
                
                border.color: mouseArea.containsPress ? theme.button.border_select : 
                             hovered ? theme.button.border_select + "80" : 
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
                    anchors.margins: 8
                    spacing: 12
                    
                    Image {
                        source: modelData.icon
                        Layout.preferredHeight: 28
                        Layout.preferredWidth: 28
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
                            pixelSize: 16
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
                        Layout.preferredWidth: 4
                        Layout.preferredHeight: 20
                        radius: 2
                        color: theme.accent.color
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

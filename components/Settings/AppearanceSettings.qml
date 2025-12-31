// components/Settings/AppearanceSettings.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "."
import ".." as Components

Item {
  property var theme: currentTheme
  id: root

    signal toggleClockPanel()
    signal posClockPanel(string pos)

    // Tạo JsonEditor riêng cho panel settings
    Components.JsonEditor {
        id: panelConfig
        filePath: Qt.resolvedUrl("../../themes/sizes/" + currentSizeProfile + ".json")
        Component.onCompleted: {
            panelConfig.load(panelConfig.filePath)
        }
    }

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

              RowLayout {
                Layout.fillWidth: true
                
                Text {
                    text: "Vị trí đồng hồ:"
                    color: theme.primary.foreground
                    font {
                        family: "ComicShannsMono Nerd Font"
                        pixelSize: 16
                    }
                    Layout.preferredWidth: 150
                }
                Column {
                                      spacing: 15

                
                Row {
                    spacing: 15
                    // Top-Left
                    Rectangle {
                        width: 60
                        height: 60
                        radius: 12
                        color: mouseAreaTopLeft.containsMouse ? theme.button.background_select : theme.button.background
                        border.color: mouseAreaTopLeft.containsPress ? theme.button.border_select : theme.button.border
                        border.width: 3
                        Rectangle {
                          width: 25
                          height: 15
                          anchors.top: parent.top
                          anchors.left: parent.left
                          anchors.topMargin: 10
                          anchors.leftMargin: 10
                          color: theme.primary.background
                          radius: 6
                        }
                        
                        MouseArea {
                            id: mouseAreaTopLeft
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            
                            onClicked: {
                              root.posClockPanel("topLeft")
                            }
                        }
                    }
                    // Top
                    Rectangle {
                        width: 60
                        height: 60
                        radius: 12
                        color: mouseAreaTop.containsMouse ? theme.button.background_select : theme.button.background
                        border.color: mouseAreaTop.containsPress ? theme.button.border_select : theme.button.border
                        border.width: 3
                        Rectangle {
                          width: 25
                          height: 15
                          anchors.top: parent.top
                          anchors.topMargin: 10
                          anchors.horizontalCenter: parent.horizontalCenter
                          color: theme.primary.background
                          radius: 6
                        }
                        
                        MouseArea {
                            id: mouseAreaTop
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            
                            onClicked: {
                              root.posClockPanel("top")
                            }
                        }
                    }
                    // Top - Right
                      Rectangle {
                        width: 60
                        height: 60
                        radius: 12
                        color: mouseAreaTopRight.containsMouse ? theme.button.background_select : theme.button.background
                        border.color: mouseAreaTopRight.containsPress ? theme.button.border_select : theme.button.border
                        border.width: 3
                        Rectangle {
                          width: 25
                          height: 15
                          anchors.top: parent.top
                          anchors.right: parent.right
                          anchors.topMargin: 10
                          anchors.rightMargin: 10
                          color: theme.primary.background
                          radius: 6
                        }
                        
                        MouseArea {
                            id: mouseAreaTopRight
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            
                            onClicked: {
                              root.posClockPanel("topRight")
                            }
                        }
                    }
                  }
                  Row {
                    spacing: 15
                    
                    // Left
                    Rectangle {
                        width: 60
                        height: 60
                        radius: 12
                        color: mouseAreaLeft.containsMouse ? theme.button.background_select : theme.button.background
                        border.color: mouseAreaLeft.containsPress ? theme.button.border_select : theme.button.border
                        border.width: 3
                        Rectangle {
                          width: 25
                          height: 15
                          anchors.left: parent.left
                          anchors.leftMargin: 10
                          anchors.verticalCenter: parent.verticalCenter
                          color: theme.primary.background
                          radius: 6
                        }
                        
                        MouseArea {
                            id: mouseAreaLeft
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            
                            onClicked: {
                              root.posClockPanel("left")
                            }
                        }
                    }
                    // Center
                    Rectangle {
                        width: 60
                        height: 60
                        radius: 12
                        color: mouseAreaCenter.containsMouse ? theme.button.background_select : theme.button.background
                        border.color: mouseAreaCenter.containsPress ? theme.button.border_select : theme.button.border
                        border.width: 3
                        Rectangle {
                          width: 25
                          height: 15
                          anchors.horizontalCenter: parent.horizontalCenter
                          anchors.verticalCenter: parent.verticalCenter
                          color: theme.primary.background
                          radius: 6
                        }
                        
                        MouseArea {
                            id: mouseAreaCenter
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            
                            onClicked: {
                              root.posClockPanel("center")
                            }
                        }
                    }
                    // Right
                      Rectangle {
                        width: 60
                        height: 60
                        radius: 12
                        color: mouseAreaRight.containsMouse ? theme.button.background_select : theme.button.background
                        border.color: mouseAreaRight.containsPress ? theme.button.border_select : theme.button.border
                        border.width: 3
                        Rectangle {
                          width: 25
                          height: 15
                          anchors.right: parent.right
                          anchors.rightMargin: 10
                          anchors.verticalCenter: parent.verticalCenter
                          color: theme.primary.background
                          radius: 6
                        }
                        
                        MouseArea {
                            id: mouseAreaRight
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            
                            onClicked: {
                              root.posClockPanel("right")
                            }
                        }
                    }
                  }
                  Row {
                    spacing: 15
                    
                    // Left - Bottom
                    Rectangle {
                        width: 60
                        height: 60
                        radius: 12
                        color: mouseAreaLeftBottom.containsMouse ? theme.button.background_select : theme.button.background
                        border.color: mouseAreaLeftBottom.containsPress ? theme.button.border_select : theme.button.border
                        border.width: 3
                        Rectangle {
                          width: 25
                          height: 15
                          anchors.left: parent.left
                          anchors.leftMargin: 10
                          anchors.bottom: parent.bottom
                          anchors.bottomMargin: 10
                          color: theme.primary.background
                          radius: 6
                        }
                        
                        MouseArea {
                            id: mouseAreaLeftBottom
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            
                            onClicked: {
                              root.posClockPanel("bottomLeft")
                            }
                        }
                    }
                    // Bottom
                    Rectangle {
                        width: 60
                        height: 60
                        radius: 12
                        color: mouseAreaBottom.containsMouse ? theme.button.background_select : theme.button.background
                        border.color: mouseAreaBottom.containsPress ? theme.button.border_select : theme.button.border
                        border.width: 3
                        Rectangle {
                          width: 25
                          height: 15
                          anchors.bottom: parent.bottom
                          anchors.bottomMargin: 10
                          anchors.horizontalCenter: parent.horizontalCenter
                          color: theme.primary.background
                          radius: 6
                        }
                        
                        MouseArea {
                            id: mouseAreaBottom
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            
                            onClicked: {
                              root.posClockPanel("bottom")
                            }
                        }
                    }
                    //bottom - right
                      Rectangle {
                        width: 60
                        height: 60
                        radius: 12
                        color: mouseAreaRightBottom.containsMouse ? theme.button.background_select : theme.button.background
                        border.color: mouseAreaRightBottom.containsPress ? theme.button.border_select : theme.button.border
                        border.width: 3
                        Rectangle {
                          width: 25
                          height: 15
                          anchors.right: parent.right
                          anchors.rightMargin: 10
                          anchors.bottom: parent.bottom
                          anchors.bottomMargin: 10
                          color: theme.primary.background
                          radius: 6
                        }
                        
                        MouseArea {
                            id: mouseAreaRightBottom
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            
                            onClicked: {
                              root.posClockPanel("bottomRight")
                            }
                        }
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
                        value: 0.5
                        from: 0
                        to: 1.0

                        property bool isInitialized: false

                        Component.onCompleted: {
                            // Đợi panelConfig load xong rồi mới set giá trị
                            Qt.callLater(function() {
                                if (panelConfig && panelConfig.json && panelConfig.json.width_panel !== undefined) {
                                    value = panelConfig.json.width_panel / 100
                                }
                                isInitialized = true
                            })
                        }

                        onValueChanged: {
                            // Chỉ lưu khi đã initialized để tránh lưu giá trị mặc định
                            if (!isInitialized) return

                            var newValue = Math.round(value * 100)
                            if (panelConfig && panelConfig.json) {
                                panelConfig.set("width_panel", newValue)
                                // Gọi loadSizes() để reload lại sizes
                                Qt.callLater(function() {
                                    sizeLoader.loadSizes()
                                })
                            }
                        }

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

                    Text {
                        text: Math.round(opacitySlider.value * 100) + "%"
                        color: theme.primary.dim_foreground
                        font {
                            family: "ComicShannsMono Nerd Font"
                            pixelSize: 14
                        }
                        Layout.alignment: Qt.AlignRight
                    }
                }
            }

            Item { Layout.fillHeight: true } // Spacer
        }
    }
    Component.onCompleted: {
    console.log("AppearanceSettings loaded with profile:", currentSizeProfile)
}

}

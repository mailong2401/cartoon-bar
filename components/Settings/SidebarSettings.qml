// components/Settings/SidebarSettings.qml
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: sidebarSettings
    property var theme
    signal categoryChanged(int index)
    signal backRequested()
    
    Layout.preferredWidth: 200
    Layout.fillHeight: true
    color: theme.primary.dim_background
    radius: 8

    border {
              color : theme.normal.black
              width: 2
            }
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 5
        
        Text {
            text: "Cài đặt"
            color: theme.primary.foreground
            font {
              family: "ComicShannsMono Nerd Font"
              pixelSize: 20
              bold : true
            }
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 10
            Layout.bottomMargin: 20
        }
        
        // Settings Categories
        Repeater {
            model: [
                { name: "Chung", icon: "⚙️", category: "general" },
                { name: "Giao diện", icon: "🎨", category: "appearance" },
                { name: "Mạng", icon: "🌐", category: "network" },
                { name: "Âm thanh", icon: "🔊", category: "audio" },
                { name: "Hiệu suất", icon: "📊", category: "performance" },
                { name: "Phím tắt", icon: "⌨️", category: "shortcuts" },
                { name: "Hệ thống", icon: "💻", category: "system" }
            ]
            
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
                        text: modelData.icon
                        color: theme.primary.foreground
                        font {
                          family: "ComicShannsMono Nerd Font"
                          pixelSize: 18
                        }

                        anchors.verticalCenter: parent.verticalCenter
                    }
                    
                    Text {
                        text: modelData.name
                        color: theme.primary.foreground
                        font {
                          family: "ComicShannsMono Nerd Font"
                          pixelSize: 18
                        }
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
                        sidebarSettings.categoryChanged(index)
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
        
        // Back Button
        Rectangle {
            Layout.fillWidth: true
            height: 45
            radius: 8
            color: theme.normal.blue + "40"
            border.color: theme.normal.blue
            border.width: 1
            
            Text {
                text: "Quay lại ↩"
                color: theme.normal.blue
                font.pixelSize: 14
                font.bold: true
                anchors.centerIn: parent
            }
            
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: sidebarSettings.backRequested()
                onEntered: parent.color = theme.normal.blue + "60"
                onExited: parent.color = theme.normal.blue + "40"
            }
        }
    }
    
    property ListView settingsListView: ListView {
        id: settingsListView
        model: 8
        currentIndex: 0
    }
}

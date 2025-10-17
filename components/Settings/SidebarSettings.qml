// components/Settings/SidebarSettings.qml
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: sidebarSettings
    property var theme : currentTheme
    property int currentIndex: 0
    signal categoryChanged(int index)
    signal backRequested()

    Layout.preferredWidth: 200
    Layout.fillHeight: true
    color: theme.primary.dim_background
    radius: 8
    border.color: theme.normal.black
    border.width: 2

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
                bold: true
            }
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 10
            Layout.bottomMargin: 20
        }

        // Danh mục cài đặt
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

                property bool hovered: false
                property bool selected: sidebarSettings.currentIndex === index

                color: selected ? theme.button.background_select
                      : hovered ? theme.button.background + "80"
                      : "transparent"

                border.color: selected ? theme.button.border_select : "transparent"
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
                    }

                    Text {
                        text: modelData.name
                        color: theme.primary.foreground
                        font {
                            family: "ComicShannsMono Nerd Font"
                            pixelSize: 18
                            bold: selected
                        }
                    }
                }

                MouseArea {
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


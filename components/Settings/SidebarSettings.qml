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
    radius: 8
    border.color: theme.normal.black
    border.width: 2

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 5

        Text {
            text: lang.settings.title
            color: theme.primary.foreground
            font {
                family: "ComicShannsMono Nerd Font"
                pixelSize: 30
                bold: true
            }
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 10
            Layout.bottomMargin: 20
        }

        // Danh mục cài đặt
        Repeater {
            model: [
                { name: lang.settings.general, icon: "⚙️", category: "general" },
                { name: lang.settings.appearance, icon: "🎨", category: "appearance" },
                { name: lang.settings.network, icon: "🌐", category: "network" },
                { name: lang.settings.audio, icon: "🔊", category: "audio" },
                { name: lang.settings.performance, icon: "📊", category: "performance" },
                { name: lang.settings.shortcuts, icon: "⌨️", category: "shortcuts" },
                { name: lang.settings.system, icon: "💻", category: "system" }
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


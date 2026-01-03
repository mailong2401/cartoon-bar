import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "." as Components

PanelWindow {
    id: flagSelectionPanel

    Components.JsonEditor {
        id: panelConfig
        filePath: Qt.resolvedUrl("../themes/sizes/" + currentSizeProfile + ".json")
        Component.onCompleted: {
            panelConfig.load(panelConfig.filePath)
        }
    }
    
    implicitWidth: 600
    implicitHeight: 420

    property var theme: currentTheme
    property string selectedFlag: currentSizes.selectedFlag

    signal flagSelected(string flagName)

    property var flagList: [
        { name: "britain", displayName: "Britain" },
        { name: "china", displayName: "China" },
        { name: "france", displayName: "France" },
        { name: "german", displayName: "Germany" },
        { name: "india", displayName: "India" },
        { name: "italy", displayName: "Italy" },
        { name: "japan", displayName: "Japan" },
        { name: "korea", displayName: "Korea" },
        { name: "netherlands", displayName: "Netherlands" },
        { name: "portugal", displayName: "Portugal" },
        { name: "russia", displayName: "Russia" },
        { name: "saudi_arabia", displayName: "Saudi Arabia" },
        { name: "spain", displayName: "Spain" },
        { name: "turkey", displayName: "Turkey" },
        { name: "vietnam", displayName: "Vietnam" }
    ]

    anchors {
        top: currentSizes.mainPanelPos === "top"
        bottom: currentSizes.mainPanelPos === "bottom"
    }

    margins {
        top: currentSizes.mainPanelPos === "top" ? 10 : 0
        bottom: currentSizes.mainPanelPos === "bottom" ? 10 : 0
        left: 800
    }

    exclusiveZone: 0
    color: "transparent"

    function setFlag(name) {
        panelConfig.set("countryFlag", name)
    }


    Rectangle {
        anchors.fill: parent
        color: theme.primary.background
        radius: 10
        border.color: theme.normal.black
        border.width: 3

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            // Header
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Image {
                    source: "../assets/panel/earth.png"
                    width: 32
                    height: 32
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                }

                Text {
                    text: "Select Your Country Flag"
                    color: theme.primary.foreground
                    font {
                        pixelSize: 32
                        bold: true
                        family: "ComicShannsMono Nerd Font"
                    }
                    Layout.fillWidth: true
                }
            }

            // Divider
            Rectangle {
                Layout.fillWidth: true
                height: 2
                color: theme.normal.black
                radius: 1
            }

            // Flag Grid
            Grid {
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 5
                columnSpacing: 12
                rowSpacing: 12

                Repeater {
                    model: flagSelectionPanel.flagList

                    Rectangle {
                        width: 105
                        height: 70
                        color: flagSelectionPanel.selectedFlag === modelData.name ? theme.primary.dim_background : theme.primary.background
                        border.color: flagSelectionPanel.selectedFlag === modelData.name ? theme.normal.green : theme.normal.black
                        border.width: flagSelectionPanel.selectedFlag === modelData.name ? 3 : 2
                        radius: 10

                        Column {
                            anchors.centerIn: parent
                            spacing: 4

                            Image {
                                source: `../assets/flags/${modelData.name}.png`
                                width: 64
                                height: 45
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: modelData.displayName
                                color: theme.primary.foreground
                                font {
                                    pixelSize: 12
                                    family: "ComicShannsMono Nerd Font"
                                    bold: flagSelectionPanel.selectedFlag === modelData.name
                                }
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                setFlag(modelData.name)
                                
                            }

                            onEntered: {
                                parent.scale = 1.05
                            }

                            onExited: {
                                parent.scale = 1.0
                            }
                        }

                        Behavior on scale { NumberAnimation { duration: 150 } }
                        Behavior on border.width { NumberAnimation { duration: 150 } }
                    }
                }
            }

            // Footer info
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: theme.normal.black
                opacity: 0.3
            }

            Text {
                text: `Selected: ${flagSelectionPanel.selectedFlag}`
                color: theme.primary.dim_foreground
                font {
                    pixelSize: 16
                    family: "ComicShannsMono Nerd Font"
                    italic: true
                }
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}

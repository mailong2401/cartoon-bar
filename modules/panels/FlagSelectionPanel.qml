import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "../../services" as Services

PanelWindow {
    id: flagSelectionPanel

    property var sizes: currentSizes.flagSelectionPanel || {}
    property var theme: currentTheme
    property string selectedFlag: currentConfig.selectedFlag

    Services.JsonEditor {
        id: panelConfig
        filePath: Qt.resolvedUrl("../../config/configs/" + currentConfigProfile + ".json")
        Component.onCompleted: {
            panelConfig.load(panelConfig.filePath)
        }
    }

    implicitWidth: sizes.width || 600
    implicitHeight: sizes.height || 420

    property var flagList: [
        { name: "britain", displayName: "Britain" },
        { name: "bulgaria", displayName: "Bulgaria" },
        { name: "china", displayName: "China" },
        { name: "czech", displayName: "Czech" },
        { name: "denmark", displayName: "Denmark" },
        { name: "finland", displayName: "Finland" },
        { name: "france", displayName: "France" },
        { name: "german", displayName: "Germany" },
        { name: "greece", displayName: "Greece" },
        { name: "hungary", displayName: "Hungary" },
        { name: "india", displayName: "India" },
        { name: "indonesia", displayName: "Indonesia" },
        { name: "israel", displayName: "Israel" },
        { name: "italy", displayName: "Italy" },
        { name: "japan", displayName: "Japan" },
        { name: "korea", displayName: "Korea" },
        { name: "netherlands", displayName: "Netherlands" },
        { name: "norway", displayName: "Norway" },
        { name: "poland", displayName: "Poland" },
        { name: "portugal", displayName: "Portugal" },
        { name: "romania", displayName: "Romania" },
        { name: "russia", displayName: "Russia" },
        { name: "saudi_arabia", displayName: "Saudi Arabia" },
        { name: "slovakia", displayName: "Slovakia" },
        { name: "spain", displayName: "Spain" },
        { name: "sweden", displayName: "Sweden" },
        { name: "thailand", displayName: "Thailand" },
        { name: "turkey", displayName: "Turkey" },
        { name: "ukraine", displayName: "Ukraine" },
        { name: "vietnam", displayName: "Vietnam" }
    ]

    anchors {
        top: currentConfig.mainPanelPos === "top"
        bottom: currentConfig.mainPanelPos === "bottom"
    }

    margins {
        top: currentConfig.mainPanelPos === "top" ? (sizes.marginTop || 10) : 0
        bottom: currentConfig.mainPanelPos === "bottom" ? (sizes.marginBottom || 10) : 0
        left: sizes.marginLeft || 800
    }

    exclusiveZone: 0
    color: "transparent"

    function setFlag(name) {
        panelConfig.set("countryFlag", name)
    }


    Rectangle {
        anchors.fill: parent
        color: theme.primary.background
        radius: sizes.radius || 10
        border.color: theme.normal.black
        border.width: sizes.borderWidth || 3

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: sizes.margins || 20
            spacing: sizes.spacing || 15

            // Header
            RowLayout {
                Layout.fillWidth: true
                spacing: sizes.headerSpacing || 10

                Image {
                    source: "../../assets/panel/earth.png"
                    width: sizes.headerIconSize || 32
                    height: sizes.headerIconSize || 32
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                }

                Text {
                    text: "Select Your Country Flag"
                    color: theme.primary.foreground
                    font {
                        pixelSize: sizes.headerFontSize || 32
                        bold: true
                        family: "ComicShannsMono Nerd Font"
                    }
                    Layout.fillWidth: true
                }
            }

            // Divider


            // Flag Grid with Scroll
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                ScrollBar.vertical.policy: ScrollBar.AlwaysOff
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOn

                Flow {
                    height: 3 * (sizes.flagItemHeight || 70) + 2 * (sizes.gridColumnSpacing || 12)
                    spacing: sizes.gridColumnSpacing || 12
                    flow: Flow.TopToBottom

                    Repeater {
                        model: flagSelectionPanel.flagList

                        Rectangle {
                            width: sizes.flagItemWidth || 105
                            height: sizes.flagItemHeight || 70
                            color: flagSelectionPanel.selectedFlag === modelData.name ? theme.primary.dim_background : theme.primary.background
                            border.color: flagSelectionPanel.selectedFlag === modelData.name ? theme.normal.green : theme.normal.black
                            border.width: flagSelectionPanel.selectedFlag === modelData.name ? (sizes.flagItemSelectedBorderWidth || 3) : (sizes.flagItemBorderWidth || 2)
                            radius: sizes.flagItemRadius || 10

                            Column {
                                anchors.centerIn: parent
                                spacing: sizes.flagItemSpacing || 4

                                Image {
                                    source: `../../assets/flags/${modelData.name}.png`
                                    width: sizes.flagImageWidth || 64
                                    height: sizes.flagImageHeight || 45
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: modelData.displayName
                                    color: theme.primary.foreground
                                    font {
                                        pixelSize: sizes.flagNameFontSize || 12
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
                    pixelSize: sizes.footerFontSize || 16
                    family: "ComicShannsMono Nerd Font"
                    italic: true
                }
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}

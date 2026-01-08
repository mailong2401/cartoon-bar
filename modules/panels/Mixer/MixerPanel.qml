// Main mixer panel
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import "./" as Components

PanelWindow {
    id: root

    property var sizes: currentSizes.mixerPanel || {}

    implicitWidth: sizes.width || 430
    implicitHeight: sizes.height || 600
    property var lang : currentLanguage

    anchors {
            top: currentConfig.mainPanelPos === "top"
            bottom: currentConfig.mainPanelPos === "bottom"
            right: true
        }
        margins {
            top: currentConfig.mainPanelPos === "top" ? 10 : 0
            right: 10
            bottom: currentConfig.mainPanelPos === "bottom" ? 10 : 0
        }
    color: "transparent"

    property var theme: currentTheme

    Rectangle {
        anchors.fill: parent
        color: theme.primary.background
        radius: sizes.radius || 8
        border.color: theme.normal.black
        border.width: sizes.borderWidth || 3

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: sizes.margins || 16
            spacing: sizes.spacing || 20

            // Header với icon và title
            RowLayout {
                Layout.fillWidth: true
                spacing: sizes.headerSpacing || 12

                Rectangle {
                    width: sizes.headerIconSize || 50
                    height: sizes.headerIconSize || 50
                    color: "transparent"

                    Image {
                        anchors.centerIn: parent
                        source: "../../../assets/system/mixer.png"
                        width: sizes.headerIconSize || 50
                        height: sizes.headerIconSize || 50
                        fillMode: Image.PreserveAspectFit
                    }
                }


                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    Label {
                        text: lang.mixer.title
                        font.family: "ComicShannsMono Nerd Font"
                        font.bold: true
                        font.pixelSize: sizes.headerTitleFontSize || 17
                        color: theme.primary.foreground
                    }

                    Label {
                        text: lang.mixer.subtitle
                        font.family: "ComicShannsMono Nerd Font"
                        font.pixelSize: sizes.headerSubtitleFontSize || 13
                        color: theme.primary.dim_foreground
                        opacity: 0.8
                    }
                }
            }

            // Default sink section
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: sizes.outputSectionHeight || 120
                color: theme.primary.dim_background
                radius: sizes.sectionRadius || 6
                border.color: theme.normal.blue
                border.width: sizes.sectionBorderWidth || 2

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: sizes.sectionMargins || 12
                    spacing: sizes.sectionSpacing || 8

                    Label {
                        text: lang.mixer.output_device
                        font.bold: true
                        font.pixelSize: sizes.sectionLabelFontSize || 16
                        font.family: "ComicShannsMono Nerd Font"

                        color: theme.normal.blue
                        Layout.fillWidth: true
                    }

                    Components.MixerEntry {
                        node: Pipewire.defaultAudioSink
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        showIcon: false
                        showMediaName: false
                    }
                }
            }

            // Applications section
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: theme.primary.dim_background
                radius: sizes.sectionRadius || 6
                border.color: theme.normal.black
                border.width: sizes.sectionBorderWidth || 2

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: sizes.sectionSpacing || 8
                    spacing: sizes.sectionSpacing || 8

                    // Section header
                    Label {
                        text: lang.mixer.application_streams
                        font.bold: true

                        font.family: "ComicShannsMono Nerd Font"
                        font.pixelSize: sizes.sectionLabelFontSize || 16
                        color: theme.primary.foreground
                        Layout.fillWidth: true
                        Layout.leftMargin: 8
                        Layout.topMargin: 4
                    }

                    // Applications list
                    ScrollView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        contentWidth: availableWidth

                        ColumnLayout {
                            width: parent.width
                            spacing: sizes.sectionSpacing || 8
                            anchors.margins: 8

                            Repeater {
                                model: linkTracker.linkGroups

                                Components.MixerEntry {
                                    required property PwLinkGroup modelData
                                    node: modelData.source
                                    Layout.fillWidth: true
                                }
                            }

                            // Empty state
                            Label {
                                visible: linkTracker.linkGroups.count === 0
                                text: lang.mixer.no_streams
                                color: theme.primary.dim_foreground
                                font.italic: true
                                horizontalAlignment: Text.AlignHCenter
                                Layout.fillWidth: true
                                Layout.topMargin: 20
                            }
                        }
                    }
                }
            }

            // Footer với status info
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: sizes.footerHeight || 20
                    color: "transparent"
                    border.color: theme.normal.black
                    border.width: 1
                    radius: sizes.footerRadius || 4

                    Label {
                        anchors.centerIn: parent
                        text: `Active streams: ${linkTracker.linkGroups.count}`
                        font.pixelSize: sizes.footerFontSize || 10
                        color: theme.primary.dim_foreground
                    }
                }

                Rectangle {
                    width: sizes.statusIndicatorSize || 20
                    height: sizes.statusIndicatorSize || 20
                    radius: sizes.footerRadius || 4
                    color: theme.normal.green
                    opacity: 0.7

                    Label {
                        anchors.centerIn: parent
                        text: "●"
                        font.pixelSize: 8
                        color: theme.primary.background
                    }
                }
            }
        }
    }

    PwNodeLinkTracker {
        id: linkTracker
        node: Pipewire.defaultAudioSink
    }
}

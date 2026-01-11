import QtQuick
import QtQuick.Layouts

Rectangle {
    id: forecastSection

    required property var theme
    property var sizes : currentSizes
    required property var forecastDays

    visible: forecastDays.length > 0
    Layout.fillWidth: true
    Layout.preferredHeight: sizes.weatherPanel?.forecastHeight || 200
    radius: sizes.weatherPanel?.sectionRadius || 16
    color: Qt.rgba(theme.normal.black.r, theme.normal.black.g, theme.normal.black.b, 0.05)
    border.color: Qt.rgba(theme.normal.black.r, theme.normal.black.g, theme.normal.black.b, 0.1)
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: sizes.weatherPanel?.forecastMargins || 16
        spacing: sizes.weatherPanel?.forecastSpacing || 12

        // Forecast row - horizontal layout
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: sizes.weatherPanel?.forecastCardSpacing || 10

            Repeater {
                model: forecastSection.forecastDays

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: sizes.weatherPanel?.forecastCardRadius || 12
                    color: Qt.rgba(theme.normal.black.r, theme.normal.black.g, theme.normal.black.b, 0.05)
                    border.color: Qt.rgba(theme.normal.black.r, theme.normal.black.g, theme.normal.black.b, 0.1)
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: sizes.weatherPanel?.forecastCardMargins || 10
                        spacing: 8

                        // Day name
                        Text {
                            text: modelData.dayName
                            color: theme.primary.foreground
                            font {
                                pixelSize: sizes.fontSize?.xlarge || 24
                                bold: index === 0
                                family: "ComicShannsMono Nerd Font"
                            }
                            Layout.alignment: Qt.AlignHCenter
                            elide: Text.ElideRight
                        }

                        // Date
                        Text {
                            text: modelData.dateText
                            color: theme.primary.dim_foreground
                            font {
                                pixelSize: sizes.fontSize?.large || 20
                                family: "ComicShannsMono Nerd Font"
                            }
                            Layout.alignment: Qt.AlignHCenter
                        }

                        // Weather icon
                        Text {
                            text: modelData.icon
                            font.pixelSize: sizes.weatherPanel?.forecastCardIconSize || 32
                            Layout.alignment: Qt.AlignHCenter
                        }

                        // Temperature range
                        RowLayout {
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 4

                            Text {
                                text: `${modelData.minTemp}°`
                                color: theme.normal.cyan
                                font {
                                    pixelSize: sizes.fontSize?.xlarge || 24
                                    bold: true
                                    family: "ComicShannsMono Nerd Font"
                                }
                            }

                            Text {
                                text: "/"
                                color: theme.primary.dim_foreground
                                font.pixelSize: sizes.fontSize?.xlarge || 24
                            }

                            Text {
                                text: `${modelData.maxTemp}°`
                                color: theme.normal.red
                                font {
                                    pixelSize: sizes.fontSize?.xlarge || 24
                                    family: "ComicShannsMono Nerd Font"
                                }
                            }
                        }



                        Item { Layout.fillHeight: true }
                    }
                }
            }
        }
    }
}

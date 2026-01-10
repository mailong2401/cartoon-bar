import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: configSection

    required property var theme
    required property var sizes
    required property string apiKey
    required property string location
    required property bool isSearchingLocation
    required property var locationSearchResults
    required property int currentLocationIndex
    required property bool isUserSearching
    required property string errorMessage

    signal apiKeyEdited(string newKey)
    signal locationTextEdited(string newText)
    signal searchLocationRequested(string query)
    signal locationSelected(string locationName)
    signal locationFocusStatusChanged(bool hasFocus)

    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.preferredWidth: parent.width * 0.4
    radius: sizes.sectionRadius || 16
    color: Qt.rgba(theme.normal.black.r, theme.normal.black.g, theme.normal.black.b, 0.05)
    border.color: Qt.rgba(theme.normal.black.r, theme.normal.black.g, theme.normal.black.b, 0.1)
    border.width: 1

    ScrollView {
        anchors.fill: parent
        anchors.margins: 1
        clip: true
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

        ColumnLayout {
            width: parent.parent.width - 2
            spacing: 20

            // API Key Section
            ColumnLayout {
                Layout.fillWidth: true
                spacing: sizes.sectionSpacing || 12

                Text {
                    text: "🔑 API Key (weatherapi.com)"
                    color: theme.primary.foreground
                    font {
                        pixelSize: sizes.labelFontSize || 16
                        family: "ComicShannsMono Nerd Font"
                        bold: true
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: sizes.inputHeight || 44
                    radius: sizes.inputRadius || 10
                    color: theme.primary.dim_background
                    border.color: apiKeyInput.activeFocus ? theme.normal.blue : Qt.rgba(theme.normal.black.r, theme.normal.black.g, theme.normal.black.b, 0.2)
                    border.width: 1

                    TextField {
                        id: apiKeyInput
                        anchors.fill: parent
                        anchors.margins: 5
                        text: configSection.apiKey
                        palette.text: theme.primary.foreground
                        font {
                            pixelSize: sizes.inputFontSize || 14
                            family: "ComicShannsMono Nerd Font"
                        }
                        background: Rectangle {
                            color: "transparent"
                        }
                        verticalAlignment: TextInput.AlignVCenter
                        selectByMouse: true
                        clip: true
                        placeholderText: "Nhập API key của bạn..."
                        palette.placeholderText: theme.primary.dim_foreground

                        onTextChanged: {
                            configSection.apiKeyEdited(text)
                        }
                    }
                }

                Text {
                    text: "📝 Nhận API key miễn phí tại: weatherapi.com\n💡 API key sẽ tự động lưu và kiểm tra khi bạn nhập"
                    color: theme.primary.dim_foreground
                    font {
                        pixelSize: sizes.hintFontSize || 11
                        family: "ComicShannsMono Nerd Font"
                        italic: true
                    }
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }
            }

            // Location Section
            ColumnLayout {
                Layout.fillWidth: true
                spacing: sizes.sectionSpacing || 12

                Text {
                    text: "📍 Địa điểm"
                    color: theme.primary.foreground
                    font {
                        pixelSize: sizes.labelFontSize || 16
                        family: "ComicShannsMono Nerd Font"
                        bold: true
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: sizes.inputSpacing || 10

                    Rectangle {
                        Layout.fillWidth: true
                        height: sizes.inputHeight || 44
                        radius: sizes.inputRadius || 10
                        color: theme.primary.dim_background
                        border.color: locationInput.activeFocus ? theme.normal.blue : Qt.rgba(theme.normal.black.r, theme.normal.black.g, theme.normal.black.b, 0.2)
                        border.width: 1

                        TextField {
                            id: locationInput
                            anchors.fill: parent
                            anchors.margins: 5
                            text: configSection.location
                            color: theme.primary.foreground
                            font {
                                pixelSize: sizes.inputFontSize || 14
                                family: "ComicShannsMono Nerd Font"
                            }
                            palette.text: theme.primary.foreground
                            background: Rectangle {
                                color: "transparent"
                            }
                            verticalAlignment: TextInput.AlignVCenter
                            selectByMouse: true
                            clip: true
                            placeholderText: "Tìm kiếm thành phố..."
                            palette.placeholderText: theme.primary.dim_foreground

                            onActiveFocusChanged: {
                                configSection.locationFocusStatusChanged(activeFocus)
                            }

                            onTextChanged: {
                                configSection.locationTextEdited(text)
                            }
                        }
                    }

                    Rectangle {
                        width: sizes.buttonWidth || 100
                        height: sizes.inputHeight || 44
                        radius: sizes.buttonRadius || 10

                        gradient: Gradient {
                            GradientStop { position: 0.0; color: saveLocMouseArea.containsMouse ?
                                                         Qt.lighter(theme.normal.green, 1.1) : theme.normal.green }
                            GradientStop { position: 1.0; color: saveLocMouseArea.containsMouse ?
                                                         theme.normal.green : Qt.darker(theme.normal.green, 1.1) }
                        }

                        border.color: Qt.darker(theme.normal.green, 1.2)
                        border.width: 1

                        Text {
                            text: configSection.isSearchingLocation ? "⏳" : "🔍"
                            color: theme.primary.background
                            font {
                                pixelSize: sizes.buttonFontSize || 14
                                family: "ComicShannsMono Nerd Font"
                                bold: true
                            }
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            id: saveLocMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            enabled: !configSection.isSearchingLocation
                            onClicked: configSection.searchLocationRequested(locationInput.text)
                        }
                    }
                }

                // Location search results
                ListView {
                    id: locationResultsList
                    visible: configSection.isUserSearching && configSection.locationSearchResults.length > 0
                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.min(count * (sizes.searchResultItemHeight || 52), (sizes.searchResultMaxHeight || 208))
                    clip: true
                    spacing: sizes.searchResultSpacing || 4
                    model: configSection.locationSearchResults
                    currentIndex: configSection.currentLocationIndex

                    delegate: Rectangle {
                        width: ListView.view.width
                        height: sizes.searchResultItemHeight || 50
                        radius: sizes.searchResultRadius || 10

                        gradient: Gradient {
                            GradientStop {
                                position: 0.0;
                                color: (ListView.isCurrentItem || locationResultMouseArea.containsMouse) ?
                                       Qt.rgba(theme.normal.blue.r, theme.normal.blue.g, theme.normal.blue.b, 0.15) :
                                       "transparent"
                            }
                            GradientStop {
                                position: 1.0;
                                color: (ListView.isCurrentItem || locationResultMouseArea.containsMouse) ?
                                       Qt.rgba(theme.normal.blue.r, theme.normal.blue.g, theme.normal.blue.b, 0.05) :
                                       "transparent"
                            }
                        }

                        border.color: (ListView.isCurrentItem || locationResultMouseArea.containsMouse) ?
                                      Qt.rgba(theme.normal.blue.r, theme.normal.blue.g, theme.normal.blue.b, 0.3) :
                                      "transparent"
                        border.width: 1

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: sizes.searchResultMargins || 12
                            spacing: sizes.searchResultMargins || 12

                            Text {
                                text: "📍"
                                font.pixelSize: sizes.searchResultIconSize || 18
                                color: theme.normal.blue
                                Layout.alignment: Qt.AlignVCenter
                            }

                            Column {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                                spacing: 2

                                Text {
                                    text: modelData.name
                                    color: theme.primary.foreground
                                    font {
                                        pixelSize: sizes.searchResultNameFontSize || 14
                                        family: "ComicShannsMono Nerd Font"
                                        bold: true
                                    }
                                    width: parent.width
                                    elide: Text.ElideRight
                                }

                                Text {
                                    text: `${modelData.region}, ${modelData.country}`
                                    color: theme.primary.dim_foreground
                                    font {
                                        pixelSize: sizes.searchResultDetailFontSize || 12
                                        family: "ComicShannsMono Nerd Font"
                                    }
                                    width: parent.width
                                    elide: Text.ElideRight
                                }
                            }
                        }

                        MouseArea {
                            id: locationResultMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onPressed: {
                                // Stop hide timer khi user click vào result
                                hideResultsTimer.stop()
                            }
                            onClicked: {
                                locationInput.text = `${modelData.name},${modelData.country}`
                                configSection.locationSelected(locationInput.text)
                            }
                        }
                    }
                }
            }

            // Error message (nếu có)
            Rectangle {
                visible: configSection.errorMessage !== ""
                Layout.fillWidth: true
                Layout.preferredHeight: configSection.errorMessage !== "" ? (sizes.errorHeight || 60) : 0
                radius: sizes.errorRadius || 12

                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(theme.normal.red.r, theme.normal.red.g, theme.normal.red.b, 0.1) }
                    GradientStop { position: 1.0; color: Qt.rgba(theme.normal.red.r, theme.normal.red.g, theme.normal.red.b, 0.05) }
                }

                border.color: Qt.rgba(theme.normal.red.r, theme.normal.red.g, theme.normal.red.b, 0.3)
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: sizes.errorMargins || 12
                    spacing: sizes.errorMargins || 12

                    Text {
                        text: "⚠️"
                        font.pixelSize: sizes.errorIconSize || 18
                        color: theme.normal.red
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Text {
                        text: configSection.errorMessage
                        color: theme.normal.red
                        font {
                            pixelSize: sizes.errorFontSize || 13
                            family: "ComicShannsMono Nerd Font"
                        }
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                    }
                }
            }
        }
    }
}

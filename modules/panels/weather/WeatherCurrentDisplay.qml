import QtQuick
import QtQuick.Layouts
import "." as Com

RowLayout {
    id: currentDisplay

    required property var theme
    property var sizes: currentSizes.weatherPanel || {}
    required property string temperature
    required property string condition
    required property string icon
    required property string feelsLike
    required property string humidity
    required property string windSpeed
    required property string pressure
    required property string visibility
    required property string uvIndex
    required property bool hasData

    spacing: 20

    // Main weather card - LEFT
    Rectangle {
        visible: currentDisplay.hasData
        Layout.preferredWidth: sizes.weatherCardWidth || 200
        Layout.fillHeight: true
        radius: sizes.weatherCardRadius || 16

        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(theme.normal.blue.r, theme.normal.blue.g, theme.normal.blue.b, 0.15) }
            GradientStop { position: 0.5; color: Qt.rgba(theme.normal.blue.r, theme.normal.blue.g, theme.normal.blue.b, 0.08) }
            GradientStop { position: 1.0; color: Qt.rgba(theme.normal.blue.r, theme.normal.blue.g, theme.normal.blue.b, 0.15) }
        }

        border.color: Qt.rgba(theme.normal.blue.r, theme.normal.blue.g, theme.normal.blue.b, 0.4)
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: sizes.weatherInfoSpacing || 15

            Text {
                text: currentDisplay.icon
                font.pixelSize: sizes.weatherIconSize || 40
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: currentDisplay.temperature
                color: theme.primary.foreground
                font {
                    pixelSize: sizes.temperatureFontSize || 48
                    bold: true
                    family: "ComicShannsMono Nerd Font"
                }
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: currentDisplay.condition
                color: theme.primary.foreground
                font {
                    pixelSize: sizes.conditionFontSize || 18
                    family: "ComicShannsMono Nerd Font"
                }
                Layout.alignment: Qt.AlignHCenter
                horizontalAlignment: Text.AlignHCenter
            }

            Item { Layout.fillHeight: true }
        }
    }

    // Weather details grid - 3x2 layout - RIGHT
    GridLayout {
        visible: currentDisplay.hasData
        Layout.fillWidth: true
        Layout.fillHeight: true
        columns: 3
        columnSpacing: sizes.detailGridColumnSpacing || 5
        rowSpacing: sizes.detailGridRowSpacing || 5

        // Humidity
        Com.WeatherDetailCard {
            Layout.fillWidth: true
            Layout.fillHeight: true
            image: "../../../assets/weather/humidity.png"
            value: currentDisplay.humidity
        }

        // Wind Speed
        Com.WeatherDetailCard {
            Layout.fillWidth: true
            Layout.fillHeight: true
            image: currentConfig.theme === "light"
        ? "../../../assets/weather/wind_light.png"
        : "../../../assets/weather/wind_dark.png"
            value: currentDisplay.windSpeed
        }

        // Pressure
        Com.WeatherDetailCard {
            Layout.fillWidth: true
            Layout.fillHeight: true
            image: "../../../assets/weather/pressure.png"
            value: currentDisplay.pressure
        }

        // Visibility
        Com.WeatherDetailCard {
            Layout.fillWidth: true
            Layout.fillHeight: true
            image: "../../../assets/weather/visibility.png"
            value: currentDisplay.visibility
        }

        // UV Index
        Com.WeatherDetailCard {
            Layout.fillWidth: true
            Layout.fillHeight: true
            image: currentConfig.theme === "light"
        ? "../../../assets/weather/uv_light.png"
        : "../../../assets/weather/uv_dark.png"
            value: currentDisplay.uvIndex
        }

        // Feels Like
        Com.WeatherDetailCard {
            Layout.fillWidth: true
            Layout.fillHeight: true
            image: currentConfig.theme === "light"
        ? "../../../assets/weather/feels_like_light.png"
        : "../../../assets/weather/feels_like_dark.png"
            value: currentDisplay.feelsLike
        }
    }
}

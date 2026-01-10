import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "../../../services" as Services
import "." as Com

PanelWindow {
    id: weatherPanel

    property var sizes: currentSizes.weatherPanel || {}
    property var theme: currentTheme
    property var lang: currentLanguage

    Services.JsonEditor {
        id: panelConfig
        filePath: Qt.resolvedUrl("../../../config/configs/" + currentConfigProfile + ".json")
        Component.onCompleted: {
            panelConfig.load(panelConfig.filePath)
            weatherPanel.apiKey = panelConfig.get("weatherApiKey", "")
            weatherPanel.location = panelConfig.get("weatherLocation", "Ho Chi Minh,VN")
            if (weatherPanel.apiKey !== "") {
                weatherPanel.updateWeather()
            }
        }
    }

    implicitWidth: sizes.width || 1000
    implicitHeight: sizes.height || 550
    focusable: true

    property string apiKey: ""
    property string location: "Ho Chi Minh,VN"
    property string temperature: ""
    property string condition: ""
    property string icon: "⛅"
    property string humidity: ""
    property string feelsLike: ""
    property string windSpeed: ""
    property string pressure: ""
    property string visibility: ""
    property string uvIndex: ""
    property var forecastDays: []
    property bool isLoading: false
    property string errorMessage: ""
    property bool isSearchingLocation: false
    property var locationSearchResults: []
    property int currentLocationIndex: 0
    property bool isUserSearching: false

    // Timer auto-validate API key
    property Timer apiKeyValidateTimer: Timer {
        interval: 500
        repeat: false
        onTriggered: {
            if (weatherPanel.apiKey !== panelConfig.get("weatherApiKey", "")) {
                saveAndValidateApiKey(weatherPanel.apiKey)
            }
        }
    }

    // Timer debounce location search
    property Timer searchDebounceTimer: Timer {
        interval: 300
        repeat: false
        onTriggered: {
            if (weatherPanel.location.length >= 2 && weatherPanel.isUserSearching) {
                searchLocation(weatherPanel.location)
            }
        }
    }

    // Timer ẩn location results
    Timer {
        id: hideResultsTimer
        interval: 200
        repeat: false
        onTriggered: {
            weatherPanel.locationSearchResults = []
            weatherPanel.isUserSearching = false
        }
    }

    anchors {
        top: currentConfig.mainPanelPos === "top"
        bottom: currentConfig.mainPanelPos === "bottom"
    }

    margins {
        top: currentConfig.mainPanelPos === "top" ? (sizes.marginTop || 10) : 0
        bottom: currentConfig.mainPanelPos === "bottom" ? (sizes.marginBottom || 10) : 0
        left: sizes.marginLeft || 400
    }

    exclusiveZone: 0
    color: "transparent"

    // Process tìm kiếm địa điểm
    Process {
        id: searchLocationProcess
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                weatherPanel.isSearchingLocation = false
                weatherPanel.locationSearchResults = []
                if (text && text.length > 0) {
                    try {
                        const data = JSON.parse(text)
                        if (!data.error) {
                            weatherPanel.locationSearchResults = data
                            if (data.length > 0) {
                                weatherPanel.currentLocationIndex = 0
                            }
                        }
                    } catch(e) {}
                }
            }
        }
    }

    // Process lấy weather forecast
    Process {
        id: weatherProcess
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                weatherPanel.isLoading = false
                if (text && text.length > 0) {
                    try {
                        const data = JSON.parse(text)
                        if (data.error) {
                            weatherPanel.errorMessage = data.error.message
                        } else {
                            weatherPanel.processWeatherData(data)
                            weatherPanel.errorMessage = ""
                        }
                    } catch(e) {
                        weatherPanel.errorMessage = "Không thể phân tích dữ liệu thời tiết"
                    }
                } else if (weatherPanel.apiKey === "") {
                    weatherPanel.errorMessage = "Vui lòng nhập API key"
                }
            }
        }
    }

    function processWeatherData(data) {
        if (data.current) {
            temperature = `${Math.round(data.current.temp_c)}°C`
            condition = data.current.condition.text
            humidity = `${data.current.humidity}%`
            feelsLike = `${Math.round(data.current.feelslike_c)}°C`
            windSpeed = `${data.current.wind_kph} km/h`
            pressure = `${data.current.pressure_mb} mb`
            visibility = `${data.current.vis_km} km`
            uvIndex = data.current.uv.toString()
            icon = getWeatherIcon(data.current.condition.code, data.current.is_day)
        }

        if (data.forecast && data.forecast.forecastday) {
            const forecast = []
            for (let i = 0; i < data.forecast.forecastday.length; i++) {
                const day = data.forecast.forecastday[i]
                forecast.push({
                    date: day.date,
                    dateText: formatDate(day.date),
                    dayName: getDayName(day.date),
                    maxTemp: Math.round(day.day.maxtemp_c),
                    minTemp: Math.round(day.day.mintemp_c),
                    condition: day.day.condition.text,
                    icon: getWeatherIcon(day.day.condition.code, true),
                    rainChance: day.day.daily_chance_of_rain
                })
            }
            forecastDays = forecast
        }
    }

    function formatDate(dateStr) {
        const date = new Date(dateStr)
        return `${date.getDate()}/${date.getMonth() + 1}`
    }

    function getDayName(dateStr) {
        const date = new Date(dateStr)
        const today = new Date()
        const tomorrow = new Date(today)
        tomorrow.setDate(tomorrow.getDate() + 1)

        if (date.toDateString() === today.toDateString()) return "Hôm nay"
        if (date.toDateString() === tomorrow.toDateString()) return "Ngày mai"

        const weekdays = lang?.calendar?.weekdays
        const days = weekdays ? [
            weekdays.sunday || "CN", weekdays.monday || "T2", weekdays.tuesday || "T3",
            weekdays.wednesday || "T4", weekdays.thursday || "T5",
            weekdays.friday || "T6", weekdays.saturday || "T7"
        ] : ["CN", "T2", "T3", "T4", "T5", "T6", "T7"]
        return days[date.getDay()]
    }

    function getWeatherIcon(code, isDay) {
        const iconMap = {
            "1000": isDay ? "☀️" : "🌙", "1003": isDay ? "⛅" : "☁️", "1006": "☁️",
            "1009": "🌫️", "1030": "🌫️", "1063": "🌦️", "1066": "🌨️", "1087": "⛈️",
            "1183": "🌧️", "1186": "🌧️", "1273": "⛈️", "1276": "⛈️", "1279": "⛈️", "1282": "⛈️"
        }
        return iconMap[code.toString()] || "🌈"
    }

    function saveAndValidateApiKey(key) {
        if (key === "") {
            errorMessage = "Vui lòng nhập API key"
            return
        }
        panelConfig.set("weatherApiKey", key)
        weatherPanel.apiKey = key
        updateWeather()
    }

    function searchLocation(query) {
        if (query === "" || apiKey === "") {
            locationSearchResults = []
            isSearchingLocation = false
            return
        }
        try { searchLocationProcess.running = false } catch(e) {}
        isSearchingLocation = true
        const url = `https://api.weatherapi.com/v1/search.json?key=${apiKey}&q=${encodeURIComponent(query)}`
        searchLocationProcess.command = ["curl", "-s", url]
        searchLocationProcess.running = true
    }

    function selectLocation(locationName) {
        panelConfig.set("weatherLocation", locationName)
        location = locationName
        locationSearchResults = []
        currentLocationIndex = 0
        isUserSearching = false
        updateWeather()
    }

    function updateWeather() {
        if (apiKey === "") {
            errorMessage = "Vui lòng nhập API key"
            return
        }
        isLoading = true
        errorMessage = ""
        const url = `https://api.weatherapi.com/v1/forecast.json?key=${apiKey}&q=${encodeURIComponent(location)}&days=3&lang=vi`
        weatherProcess.command = ["curl", "-s", url]
        weatherProcess.running = true
    }

    // Main UI
    Rectangle {
        anchors.fill: parent
        radius: sizes.radius || 20
        border.color: theme.normal.black
        border.width: sizes.borderWidth || 3

        gradient: Gradient {
            GradientStop { position: 0.0; color: theme.primary.background }
            GradientStop { position: 1.0; color: Qt.darker(theme.primary.background, 1.1) }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: sizes.margins || 20
            spacing: sizes.spacing || 20

            // Header
            Com.WeatherHeader {
                theme: weatherPanel.theme
                sizes: weatherPanel.sizes
                isLoading: weatherPanel.isLoading
                onRefreshClicked: weatherPanel.updateWeather()
            }

            // Main content - 2 columns
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: sizes.contentSpacing || 20

                // Left: Config
                Com.WeatherConfigSection {
                    theme: weatherPanel.theme
                    sizes: weatherPanel.sizes
                    apiKey: weatherPanel.apiKey
                    location: weatherPanel.location
                    isSearchingLocation: weatherPanel.isSearchingLocation
                    locationSearchResults: weatherPanel.locationSearchResults
                    currentLocationIndex: weatherPanel.currentLocationIndex
                    isUserSearching: weatherPanel.isUserSearching
                    errorMessage: weatherPanel.errorMessage

                    onApiKeyEdited: function(newKey) {
                        weatherPanel.apiKey = newKey
                        weatherPanel.apiKeyValidateTimer.restart()
                    }

                    onLocationTextEdited: function(newText) {
                        weatherPanel.location = newText
                        weatherPanel.searchDebounceTimer.stop()
                        if (newText.length >= 2) {
                            weatherPanel.searchDebounceTimer.restart()
                        } else {
                            weatherPanel.locationSearchResults = []
                            weatherPanel.currentLocationIndex = 0
                        }
                    }

                    onLocationFocusStatusChanged: function(hasFocus) {
                        if (hasFocus) {
                            weatherPanel.isUserSearching = true
                        } else {
                            hideResultsTimer.restart()
                        }
                    }

                    onSearchLocationRequested: function(query) {
                        weatherPanel.searchLocation(query)
                    }

                    onLocationSelected: function(locationName) {
                        weatherPanel.selectLocation(locationName)
                    }
                }

                // Right: Weather Display
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width * 0.6
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

                            // Current weather
                            Com.WeatherCurrentDisplay {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Layout.preferredHeight: sizes.weatherCardWidth
                                theme: weatherPanel.theme
                                temperature: weatherPanel.temperature
                                condition: weatherPanel.condition
                                icon: weatherPanel.icon
                                feelsLike: weatherPanel.feelsLike
                                humidity: weatherPanel.humidity
                                windSpeed: weatherPanel.windSpeed
                                pressure: weatherPanel.pressure
                                visibility: weatherPanel.visibility
                                uvIndex: weatherPanel.uvIndex
                                hasData: weatherPanel.temperature !== "" && weatherPanel.errorMessage === ""
                            }

                            // 7-day forecast
                            Com.WeatherForecastList {
                                Layout.preferredHeight: 200
                                theme: weatherPanel.theme
                                forecastDays: weatherPanel.forecastDays
                            }
                        }
                    }
                }
            }
        }
    }

    // Keyboard shortcuts
    Shortcut {
        sequence: "Up"
        enabled: locationSearchResults.length > 0
        onActivated: {
            if (currentLocationIndex > 0) currentLocationIndex--
            else currentLocationIndex = locationSearchResults.length - 1
        }
    }

    Shortcut {
        sequence: "Down"
        enabled: locationSearchResults.length > 0
        onActivated: {
            if (currentLocationIndex < locationSearchResults.length - 1) currentLocationIndex++
            else currentLocationIndex = 0
        }
    }

    Shortcut {
        sequence: "Return"
        enabled: locationSearchResults.length > 0
        onActivated: {
            var item = locationSearchResults[currentLocationIndex]
            if (item) selectLocation(`${item.name},${item.country}`)
        }
    }
}

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "." as Components
import "./weather" as Com

PanelWindow {
    id: weatherPanel

    property var sizes: currentSizes.weatherPanel || {}
    property var theme: currentTheme
    property var lang: currentLanguage

    Components.JsonEditor {
        id: panelConfig
        filePath: Qt.resolvedUrl("../configs/" + currentConfigProfile + ".json")
        Component.onCompleted: {
            panelConfig.load(panelConfig.filePath)
        }
    }

    implicitWidth: sizes.width || 1000
    implicitHeight: sizes.height || 700
    focusable: true
    property string apiKey: panelConfig.get("weatherApiKey", "")
    property string location: panelConfig.get("weatherLocation", "Ho Chi Minh,VN")

    // Weather data
    property string temperature: ""
    property string condition: ""
    property string icon: "⛅"
    property string humidity: ""
    property string feelsLike: ""
    property string windSpeed: ""
    property string pressure: ""
    property string visibility: ""
    property string uvIndex: ""
    property bool isLoading: false
    property string errorMessage: ""
    property bool isValidatingKey: false
    property bool isSearchingLocation: false
    property var locationSearchResults: []
    
    // Navigation properties
    property int currentLocationIndex: 0

    // Debounce timer cho location search
    property Timer searchDebounceTimer: Timer {
        interval: 300
        repeat: false
        onTriggered: {
            if (locationInput.text.length >= 2) {
                searchLocation(locationInput.text)
            }
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

    // Process kiểm tra API key
    Process {
        id: validateKeyProcess
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                weatherPanel.isValidatingKey = false
                if (text && text.length > 0) {
                    try {
                        const data = JSON.parse(text)
                        if (data.error) {
                            weatherPanel.errorMessage = `API key không hợp lệ: ${data.error.message}`
                        } else {
                            weatherPanel.errorMessage = ""
                            // Save API key nếu hợp lệ
                            panelConfig.set("weatherApiKey", apiKeyInput.text)
                            weatherPanel.apiKey = apiKeyInput.text
                            weatherPanel.updateWeather()
                        }
                    } catch(e) {
                        weatherPanel.errorMessage = "Lỗi kiểm tra API key"
                    }
                }
            }
        }
    }

    // Process tìm kiếm địa điểm
    Process {
        id: searchLocationProcess
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                weatherPanel.isSearchingLocation = false
                var oldResults = weatherPanel.locationSearchResults
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

    // Process lấy weather
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
    }

    function getWeatherIcon(code, isDay) {
        const iconMap = {
            "1000": isDay ? "☀️" : "🌙",
            "1003": isDay ? "⛅" : "☁️",
            "1006": "☁️",
            "1009": "🌫️",
            "1030": "🌫️",
            "1063": "🌦️",
            "1066": "🌨️",
            "1087": "⛈️",
            "1183": "🌧️",
            "1186": "🌧️",
            "1273": "⛈️",
            "1276": "⛈️",
            "1279": "⛈️",
            "1282": "⛈️"
        }
        return iconMap[code.toString()] || "🌈"
    }

    function validateApiKey(key) {
        if (key === "") {
            errorMessage = "Vui lòng nhập API key"
            return
        }

        isValidatingKey = true
        errorMessage = ""
        const url = `https://api.weatherapi.com/v1/current.json?key=${key}&q=auto:ip`
        validateKeyProcess.command = ["curl", "-s", url]
        validateKeyProcess.running = true
    }

    function searchLocation(query) {
        if (query === "" || apiKey === "") {
            locationSearchResults = []
            isSearchingLocation = false
            return
        }

        try {
            searchLocationProcess.running = false
        } catch(e) {}

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
        updateWeather()
    }

    function updateWeather() {
        if (apiKey === "") {
            errorMessage = "Vui lòng nhập API key"
            return
        }

        isLoading = true
        errorMessage = ""
        const url = `https://api.weatherapi.com/v1/current.json?key=${apiKey}&q=${encodeURIComponent(location)}&lang=vi`
        weatherProcess.command = ["curl", "-s", url]
        weatherProcess.running = true
    }

    // Gradient background
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

            // Header với hiệu ứng glassmorphism
            Rectangle {
                id: headerCard
                Layout.fillWidth: true
                height: sizes.headerHeight || 70
                radius: sizes.headerRadius || 16
                
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(theme.normal.blue.r, theme.normal.blue.g, theme.normal.blue.b, 0.15) }
                    GradientStop { position: 1.0; color: Qt.rgba(theme.normal.blue.r, theme.normal.blue.g, theme.normal.blue.b, 0.05) }
                }
                border.color: Qt.rgba(theme.normal.blue.r, theme.normal.blue.g, theme.normal.blue.b, 0.3)
                border.width: 1
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: sizes.headerMargins || 16
                    spacing: sizes.headerSpacing || 16

                    Text {
                        text: "🌤️"
                        font.pixelSize: sizes.headerIconSize || 32
                    }

                    Text {
                        text: "Thời Tiết"
                        color: theme.primary.foreground
                        font {
                            pixelSize: sizes.headerTitleFontSize || 28
                            bold: true
                            family: "ComicShannsMono Nerd Font"
                        }
                        Layout.fillWidth: true
                    }

                    // Refresh button với hiệu ứng hover
                    Rectangle {
                        width: sizes.refreshButtonSize || 44
                        height: sizes.refreshButtonSize || 44
                        radius: sizes.refreshButtonRadius || 10
                        color: refreshMouseArea.containsMouse ? 
                               Qt.lighter(theme.normal.blue, 1.2) : 
                               Qt.rgba(theme.normal.blue.r, theme.normal.blue.g, theme.normal.blue.b, 0.2)
                        border.color: theme.normal.blue
                        border.width: 2

                        Text {
                            text: weatherPanel.isLoading ? "⏳" : "🔄"
                            font.pixelSize: sizes.refreshIconSize || 20
                            anchors.centerIn: parent
                            color: theme.primary.foreground
                        }

                        MouseArea {
                            id: refreshMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: updateWeather()
                        }
                    }
                }
            }

            // Main Content Area - 2 cột
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: sizes.contentSpacing || 20

                // Cột trái - Configuration
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width * 0.45  // 45% width
                    radius: sizes.sectionRadius || 16
                    color: Qt.rgba(theme.normal.black.r, theme.normal.black.g, theme.normal.black.b, 0.05)
                    border.color: Qt.rgba(theme.normal.black.r, theme.normal.black.g, theme.normal.black.b, 0.1)
                    border.width: 1

                    ScrollView {
                        anchors.fill: parent
                        anchors.margins: 1
                        clip: true

                        ColumnLayout {
                            width: parent.width
                            spacing: 20
                            anchors.margins: 20

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

                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: sizes.inputSpacing || 10

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
                                            text: weatherPanel.apiKey
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
                                        }
                                    }

                                    // Validate button với hiệu ứng gradient
                                    Rectangle {
                                        width: sizes.buttonWidth || 100
                                        height: sizes.inputHeight || 44
                                        radius: sizes.buttonRadius || 10
                                        
                                        gradient: Gradient {
                                            GradientStop { position: 0.0; color: saveApiMouseArea.containsMouse ? 
                                                                         Qt.lighter(theme.normal.blue, 1.1) : theme.normal.blue }
                                            GradientStop { position: 1.0; color: saveApiMouseArea.containsMouse ? 
                                                                         theme.normal.blue : Qt.darker(theme.normal.blue, 1.1) }
                                        }
                                        
                                        border.color: Qt.darker(theme.normal.blue, 1.2)
                                        border.width: 1

                                        Text {
                                            text: weatherPanel.isValidatingKey ? "⏳" : "Kiểm tra"
                                            color: theme.primary.background
                                            font {
                                                pixelSize: sizes.buttonFontSize || 14
                                                family: "ComicShannsMono Nerd Font"
                                                bold: true
                                            }
                                            anchors.centerIn: parent
                                        }

                                        MouseArea {
                                            id: saveApiMouseArea
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            enabled: !weatherPanel.isValidatingKey
                                            onClicked: validateApiKey(apiKeyInput.text)
                                        }
                                    }
                                }

                                Text {
                                    text: "📝 Nhận API key miễn phí tại: weatherapi.com"
                                    color: theme.primary.dim_foreground
                                    font {
                                        pixelSize: sizes.hintFontSize || 12
                                        family: "ComicShannsMono Nerd Font"
                                        italic: true
                                    }
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
                                            text: weatherPanel.location
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
                                            
                                            onTextChanged: {
                                                weatherPanel.searchDebounceTimer.stop()
                                                if (text.length >= 2) {
                                                    weatherPanel.searchDebounceTimer.restart()
                                                } else {
                                                    weatherPanel.locationSearchResults = []
                                                    weatherPanel.currentLocationIndex = 0
                                                }
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
                                            text: weatherPanel.isSearchingLocation ? "⏳" : "🔍"
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
                                            enabled: !weatherPanel.isSearchingLocation
                                            onClicked: searchLocation(locationInput.text)
                                        }
                                    }
                                }

                                // Location search results
                                ListView {
                                    id: locationResultsList
                                    visible: weatherPanel.locationSearchResults.length > 0
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: Math.min(count * (sizes.searchResultItemHeight || 52), (sizes.searchResultMaxHeight || 208))
                                    clip: true
                                    spacing: sizes.searchResultSpacing || 4
                                    model: weatherPanel.locationSearchResults
                                    currentIndex: weatherPanel.currentLocationIndex

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
                                            onEntered: {
                                                weatherPanel.currentLocationIndex = index
                                            }
                                            onClicked: {
                                                locationInput.text = `${modelData.name},${modelData.country}`
                                                selectLocation(locationInput.text)
                                            }
                                        }
                                    }
                                }
                            }

                            // Error message (nếu có)
                            Rectangle {
                                visible: weatherPanel.errorMessage !== ""
                                Layout.fillWidth: true
                                height: visible ? (sizes.errorHeight || 60) : 0
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
                                        text: weatherPanel.errorMessage
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

                // Cột phải - Weather Display
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width
                    radius: sizes.sectionRadius || 16
                    color: Qt.rgba(theme.normal.black.r, theme.normal.black.g, theme.normal.black.b, 0.05)
                    border.color: Qt.rgba(theme.normal.black.r, theme.normal.black.g, theme.normal.black.b, 0.1)
                    border.width: 1

                    ScrollView {
                        anchors.fill: parent
                        anchors.margins: 1
                        clip: true

                        ColumnLayout {
                            width: parent.width
                            spacing: 20
                            anchors.margins: 20

                            // Main weather card - hiển thị lớn hơn
                            Rectangle {
                                visible: weatherPanel.temperature !== "" && weatherPanel.errorMessage === ""
                                Layout.fillWidth: true
                                height: sizes.weatherCardHeight || 180
                                radius: sizes.weatherCardRadius || 16
                                
                                gradient: Gradient {
                                    GradientStop { position: 0.0; color: Qt.rgba(theme.normal.blue.r, theme.normal.blue.g, theme.normal.blue.b, 0.15) }
                                    GradientStop { position: 0.5; color: Qt.rgba(theme.normal.blue.r, theme.normal.blue.g, theme.normal.blue.b, 0.08) }
                                    GradientStop { position: 1.0; color: Qt.rgba(theme.normal.blue.r, theme.normal.blue.g, theme.normal.blue.b, 0.15) }
                                }
                                
                                border.color: Qt.rgba(theme.normal.blue.r, theme.normal.blue.g, theme.normal.blue.b, 0.4)
                                border.width: 1

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 2
                                    spacing: sizes.weatherCardSpacing || 24

                                    Text {
                                        text: weatherPanel.icon
                                        font.pixelSize: sizes.weatherIconSize || 80
                                        Layout.alignment: Qt.AlignVCenter
                                    }

                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: sizes.weatherInfoSpacing || 10

                                        Text {
                                            text: weatherPanel.temperature
                                            color: theme.primary.foreground
                                            font {
                                                pixelSize: sizes.temperatureFontSize || 48
                                                bold: true
                                                family: "ComicShannsMono Nerd Font"
                                            }
                                        }

                                        Text {
                                            text: weatherPanel.condition
                                            color: theme.primary.foreground
                                            font {
                                                pixelSize: sizes.conditionFontSize || 18
                                                family: "ComicShannsMono Nerd Font"
                                            }
                                        }

                                        Text {
                                            text: `🌡️ Cảm giác như ${weatherPanel.feelsLike}`
                                            color: theme.primary.dim_foreground
                                            font {
                                                pixelSize: sizes.feelsLikeFontSize || 15
                                                family: "ComicShannsMono Nerd Font"
                                            }
                                        }
                                    }
                                }
                            }

                            // Weather details grid - 3x2 layout
                            GridLayout {
                                visible: weatherPanel.temperature !== "" && weatherPanel.errorMessage === ""
                                Layout.fillWidth: true
                                columns: 3
                                columnSpacing: sizes.detailGridColumnSpacing || 30
                                rowSpacing: sizes.detailGridRowSpacing || 15

                                // Humidity
                                Com.WeatherDetailCard {
                                    Layout.preferredWidth: sizes.detailCardWidth || 150
                                    Layout.preferredHeight: sizes.detailCardHeight || 100
                                    icon: "💧"
                                    title: "Độ ẩm"
                                    value: weatherPanel.humidity
                                    color: theme.normal.blue
                                }

                                // Wind Speed
                                Com.WeatherDetailCard {
                                    Layout.preferredWidth: sizes.detailCardWidth || 150
                                    Layout.preferredHeight: sizes.detailCardHeight || 100
                                    icon: "🌬️"
                                    title: "Gió"
                                    value: weatherPanel.windSpeed
                                    color: theme.normal.cyan
                                }

                                // Pressure
                                Com.WeatherDetailCard {
                                    Layout.preferredWidth: sizes.detailCardWidth || 150
                                    Layout.preferredHeight: sizes.detailCardHeight || 100
                                    icon: "📊"
                                    title: "Áp suất"
                                    value: weatherPanel.pressure
                                    color: theme.normal.magenta
                                }

                                // Visibility
                                Com.WeatherDetailCard {
                                    Layout.preferredWidth: sizes.detailCardWidth || 150
                                    Layout.preferredHeight: sizes.detailCardHeight || 100
                                    icon: "👁️"
                                    title: "Tầm nhìn"
                                    value: weatherPanel.visibility
                                    color: theme.normal.yellow
                                }

                                // UV Index
                                Com.WeatherDetailCard {
                                    Layout.preferredWidth: sizes.detailCardWidth || 150
                                    Layout.preferredHeight: sizes.detailCardHeight || 100
                                    icon: "☀️"
                                    title: "Chỉ số UV"
                                    value: weatherPanel.uvIndex
                                    color: theme.normal.red
                                }

                                // Feels Like
                                Com.WeatherDetailCard {
                                    Layout.preferredWidth: sizes.detailCardWidth || 150
                                    Layout.preferredHeight: sizes.detailCardHeight || 100
                                    icon: "🌡️"
                                    title: "Cảm giác"
                                    value: weatherPanel.feelsLike
                                    color: theme.normal.green
                                }
                            }

                            // Thêm section cho dự báo thời tiết (có thể mở rộng sau)
                            Rectangle {
                                Layout.fillWidth: true
                                height: sizes.forecastHeight || 120
                                radius: sizes.sectionRadius || 16
                                color: Qt.rgba(theme.normal.black.r, theme.normal.black.g, theme.normal.black.b, 0.05)
                                border.color: Qt.rgba(theme.normal.black.r, theme.normal.black.g, theme.normal.black.b, 0.1)
                                border.width: 1

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: sizes.forecastMargins || 16
                                    spacing: sizes.forecastSpacing || 8

                                    Text {
                                        text: "📅 Dự báo thời tiết"
                                        color: theme.primary.foreground
                                        font {
                                            pixelSize: sizes.forecastTitleFontSize || 16
                                            bold: true
                                            family: "ComicShannsMono Nerd Font"
                                        }
                                    }

                                    Text {
                                        text: "Chức năng dự báo sẽ có trong phiên bản tiếp theo..."
                                        color: theme.primary.dim_foreground
                                        font {
                                            pixelSize: sizes.forecastTextFontSize || 13
                                            family: "ComicShannsMono Nerd Font"
                                        }
                                        wrapMode: Text.WordWrap
                                        Layout.fillWidth: true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Keyboard shortcuts for location search results navigation
    Shortcut {
        sequence: "Up"
        enabled: locationResultsList.visible
        onActivated: {
            if (weatherPanel.currentLocationIndex > 0) {
                weatherPanel.currentLocationIndex--
            } else {
                weatherPanel.currentLocationIndex = locationResultsList.count - 1
            }
        }
    }
    
    Shortcut {
        sequence: "Down"
        enabled: locationResultsList.visible
        onActivated: {
            if (weatherPanel.currentLocationIndex < locationResultsList.count - 1) {
                weatherPanel.currentLocationIndex++
            } else {
                weatherPanel.currentLocationIndex = 0
            }
        }
    }
    
    Shortcut {
        sequence: "Return"
        enabled: locationResultsList.visible
        onActivated: {
            var item = weatherPanel.locationSearchResults[weatherPanel.currentLocationIndex]
            if (item) {
                locationInput.text = `${item.name},${item.country}`
                selectLocation(locationInput.text)
            }
        }
    }

    Component.onCompleted: {
        if (apiKey !== "") {
            updateWeather()
        }
    }
}
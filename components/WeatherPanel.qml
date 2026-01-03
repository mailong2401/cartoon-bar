import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "." as Components

PanelWindow {
    id: weatherPanel

    Components.JsonEditor {
        id: panelConfig
        filePath: Qt.resolvedUrl("../themes/sizes/" + currentSizeProfile + ".json")
        Component.onCompleted: {
            panelConfig.load(panelConfig.filePath)
        }
    }

    implicitWidth: 480
    implicitHeight: 600

    property var theme: currentTheme
    property var lang: currentLanguage
    property string apiKey: panelConfig.get("weatherApiKey", "")
    property string location: panelConfig.get("weatherLocation", "Ho Chi Minh,VN")
    focusable: true

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
        top: currentSizes.mainPanelPos === "top"
        bottom: currentSizes.mainPanelPos === "bottom"
    }

    margins {
        top: currentSizes.mainPanelPos === "top" ? 10 : 0
        bottom: currentSizes.mainPanelPos === "bottom" ? 10 : 0
        left: 400
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
                console.log("=== Location Search Response ===")
                console.log("Raw text:", text)

                // Luôn clear array trước
                var oldResults = weatherPanel.locationSearchResults
                weatherPanel.locationSearchResults = []

                if (text && text.length > 0) {
                    try {
                        const data = JSON.parse(text)
                        console.log("Parsed data:", JSON.stringify(data))
                        if (data.error) {
                            console.log("Error from API:", data.error.message)
                        } else {
                            console.log("Number of results:", data.length)
                            // Assign dữ liệu mới
                            weatherPanel.locationSearchResults = data
                            console.log("locationSearchResults.length:", weatherPanel.locationSearchResults.length)
                            // Reset navigation index khi có kết quả mới
                            if (data.length > 0) {
                                weatherPanel.currentLocationIndex = 0
                            }
                        }
                    } catch(e) {
                        console.log("Parse error:", e)
                    }
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
            "1186": "🌧️"
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
        console.log("=== searchLocation called ===")
        console.log("Query:", query)
        console.log("API Key:", apiKey ? "exists" : "empty")

        if (query === "" || apiKey === "") {
            locationSearchResults = []
            isSearchingLocation = false
            console.log("Cleared results - empty query or no API key")
            return
        }

        // Stop previous search nếu đang chạy
        try {
            searchLocationProcess.running = false
        } catch(e) {}

        isSearchingLocation = true
        const url = `https://api.weatherapi.com/v1/search.json?key=${apiKey}&q=${encodeURIComponent(query)}`
        console.log("Search URL:", url)
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

                Text {
                    text: "☁️"
                    font.pixelSize: 32
                }

                Text {
                    text: "Thời Tiết"
                    color: theme.primary.foreground
                    font {
                        pixelSize: 28
                        bold: true
                        family: "ComicShannsMono Nerd Font"
                    }
                    Layout.fillWidth: true
                }

                // Refresh button
                Rectangle {
                    width: 40
                    height: 40
                    radius: 8
                    color: refreshMouseArea.containsMouse ? theme.button.background_select : theme.button.background
                    border.color: theme.button.border
                    border.width: 2

                    Text {
                        text: weatherPanel.isLoading ? "⏳" : "🔄"
                        font.pixelSize: 20
                        anchors.centerIn: parent
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

            // Divider
            Rectangle {
                Layout.fillWidth: true
                height: 2
                color: theme.normal.black
                radius: 1
            }

            // API Key Input
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: "API Key (weatherapi.com)"
                    color: theme.primary.foreground
                    font {
                        pixelSize: 14
                        family: "ComicShannsMono Nerd Font"
                        bold: true
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Rectangle {
                        Layout.fillWidth: true
                        height: 40
                        color: theme.primary.dim_background
                        radius: 8
                        border.color: apiKeyInput.activeFocus ? theme.normal.blue : theme.button.border
                        border.width: 2

                        TextInput {
                            id: apiKeyInput
                            anchors.fill: parent
                            anchors.margins: 10
                            text: weatherPanel.apiKey
                            color: theme.primary.foreground
                            font {
                                pixelSize: 13
                                family: "ComicShannsMono Nerd Font"
                            }
                            verticalAlignment: TextInput.AlignVCenter
                            selectByMouse: true
                            clip: true
                        }
                    }

                    Rectangle {
                        width: 100
                        height: 40
                        radius: 8
                        color: saveApiMouseArea.containsMouse ? theme.normal.blue : theme.button.background
                        border.color: theme.button.border
                        border.width: 2

                        Text {
                            text: weatherPanel.isValidatingKey ? "⏳" : "Kiểm tra"
                            color: saveApiMouseArea.containsMouse ? theme.primary.background : theme.primary.foreground
                            font {
                                pixelSize: 14
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
                    text: "Nhận API key miễn phí tại: weatherapi.com"
                    color: theme.primary.dim_foreground
                    font {
                        pixelSize: 11
                        family: "ComicShannsMono Nerd Font"
                        italic: true
                    }
                }
            }

            // Location Input
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: "Địa điểm"
                    color: theme.primary.foreground
                    font {
                        pixelSize: 14
                        family: "ComicShannsMono Nerd Font"
                        bold: true
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Rectangle {
                        Layout.fillWidth: true
                        height: 40
                        color: theme.primary.dim_background
                        radius: 8
                        border.color: locationInput.activeFocus ? theme.normal.blue : theme.button.border
                        border.width: 2

                        TextInput {
                            id: locationInput
                            anchors.fill: parent
                            anchors.margins: 10
                            text: weatherPanel.location
                            color: theme.primary.foreground
                            font {
                                pixelSize: 13
                                family: "ComicShannsMono Nerd Font"
                            }
                            verticalAlignment: TextInput.AlignVCenter
                            selectByMouse: true
                            clip: true
                            onTextChanged: {
                                console.log("=== TextInput changed ===")
                                console.log("Text:", text)
                                console.log("Text length:", text.length)

                                // Stop timer cũ
                                weatherPanel.searchDebounceTimer.stop()

                                if (text.length >= 2) {
                                    console.log("Starting debounce timer...")
                                    // Restart timer - chỉ gọi API sau khi user ngừng gõ 300ms
                                    weatherPanel.searchDebounceTimer.restart()
                                } else {
                                    console.log("Text too short, clearing results")
                                    // Clear results ngay lập tức khi text ngắn
                                    weatherPanel.locationSearchResults = []
                                    weatherPanel.currentLocationIndex = 0
                                }
                            }
                        }
                    }

                    Rectangle {
                        width: 100
                        height: 40
                        radius: 8
                        color: saveLocMouseArea.containsMouse ? theme.normal.blue : theme.button.background
                        border.color: theme.button.border
                        border.width: 2

                        Text {
                            text: weatherPanel.isSearchingLocation ? "⏳" : "Tìm kiếm"
                            color: saveLocMouseArea.containsMouse ? theme.primary.background : theme.primary.foreground
                            font {
                                pixelSize: 14
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
                    Layout.preferredHeight: Math.min(count * 50, 200)
                    clip: true
                    spacing: 0
                    model: weatherPanel.locationSearchResults
                    currentIndex: weatherPanel.currentLocationIndex

                    onVisibleChanged: {
                        console.log("=== Results ListView visible changed ===")
                        console.log("Visible:", visible)
                        console.log("Results array length:", weatherPanel.locationSearchResults.length)
                        console.log("ListView count:", count)
                    }

                    onCountChanged: {
                        console.log("=== ListView count changed ===")
                        console.log("New count:", count)
                    }

                    delegate: Rectangle {
                        width: ListView.view.width
                        height: 50
                        color: (ListView.isCurrentItem || locationResultMouseArea.containsMouse) 
                               ? theme.button.background_select 
                               : "transparent"
                        border.color: (ListView.isCurrentItem || locationResultMouseArea.containsMouse) 
                                      ? theme.button.border_select 
                                      : "transparent"
                        border.width: 1
                        radius: 8

                        Component.onCompleted: {
                            console.log("Created item for:", modelData.name, modelData.country)
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 15
                            spacing: 2

                            Text {
                                text: modelData.name + ", " + modelData.region
                                color: theme.primary.foreground
                                font {
                                    pixelSize: 14
                                    family: "ComicShannsMono Nerd Font"
                                    bold: true
                                }
                            }

                            Text {
                                text: modelData.country
                                color: theme.primary.dim_foreground
                                font {
                                    pixelSize: 12
                                    family: "ComicShannsMono Nerd Font"
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
                                locationInput.text = modelData.name + "," + modelData.country
                                selectLocation(locationInput.text)
                            }
                        }
                    }
                }
            }

            // Divider
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: theme.normal.black
                opacity: 0.3
            }

            // Weather Display
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                ColumnLayout {
                    width: parent.width
                    spacing: 15

                    // Error message
                    Rectangle {
                        visible: weatherPanel.errorMessage !== ""
                        Layout.fillWidth: true
                        height: 50
                        color: theme.normal.red + "20"
                        radius: 8
                        border.color: theme.normal.red
                        border.width: 2

                        Text {
                            text: weatherPanel.errorMessage
                            color: theme.normal.red
                            font {
                                pixelSize: 13
                                family: "ComicShannsMono Nerd Font"
                            }
                            anchors.centerIn: parent
                            wrapMode: Text.WordWrap
                        }
                    }

                    // Main weather info
                    Rectangle {
                        visible: weatherPanel.temperature !== "" && weatherPanel.errorMessage === ""
                        Layout.fillWidth: true
                        height: 120
                        color: theme.primary.dim_background
                        radius: 10
                        border.color: theme.normal.blue
                        border.width: 2

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 20
                            spacing: 20

                            Text {
                                text: weatherPanel.icon
                                font.pixelSize: 64
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 5

                                Text {
                                    text: weatherPanel.temperature
                                    color: theme.primary.foreground
                                    font {
                                        pixelSize: 36
                                        bold: true
                                        family: "ComicShannsMono Nerd Font"
                                    }
                                }

                                Text {
                                    text: weatherPanel.condition
                                    color: theme.primary.dim_foreground
                                    font {
                                        pixelSize: 16
                                        family: "ComicShannsMono Nerd Font"
                                    }
                                }

                                Text {
                                    text: `Cảm giác như ${weatherPanel.feelsLike}`
                                    color: theme.primary.dim_foreground
                                    font {
                                        pixelSize: 13
                                        family: "ComicShannsMono Nerd Font"
                                    }
                                }
                            }
                        }
                    }

                    // Weather details grid
                    Grid {
                        visible: weatherPanel.temperature !== "" && weatherPanel.errorMessage === ""
                        Layout.fillWidth: true
                        columns: 2
                        columnSpacing: 12
                        rowSpacing: 12

                        // Humidity
                        Rectangle {
                            width: 200
                            height: 80
                            color: theme.primary.dim_background
                            radius: 8
                            border.color: theme.button.border
                            border.width: 2

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 5

                                Text {
                                    text: "💧 Độ ẩm"
                                    color: theme.primary.dim_foreground
                                    font {
                                        pixelSize: 12
                                        family: "ComicShannsMono Nerd Font"
                                    }
                                    Layout.alignment: Qt.AlignHCenter
                                }

                                Text {
                                    text: weatherPanel.humidity
                                    color: theme.primary.foreground
                                    font {
                                        pixelSize: 20
                                        bold: true
                                        family: "ComicShannsMono Nerd Font"
                                    }
                                    Layout.alignment: Qt.AlignHCenter
                                }
                            }
                        }

                        // Wind Speed
                        Rectangle {
                            width: 200
                            height: 80
                            color: theme.primary.dim_background
                            radius: 8
                            border.color: theme.button.border
                            border.width: 2

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 5

                                Text {
                                    text: "🌬️ Gió"
                                    color: theme.primary.dim_foreground
                                    font {
                                        pixelSize: 12
                                        family: "ComicShannsMono Nerd Font"
                                    }
                                    Layout.alignment: Qt.AlignHCenter
                                }

                                Text {
                                    text: weatherPanel.windSpeed
                                    color: theme.primary.foreground
                                    font {
                                        pixelSize: 20
                                        bold: true
                                        family: "ComicShannsMono Nerd Font"
                                    }
                                    Layout.alignment: Qt.AlignHCenter
                                }
                            }
                        }

                        // Pressure
                        Rectangle {
                            width: 200
                            height: 80
                            color: theme.primary.dim_background
                            radius: 8
                            border.color: theme.button.border
                            border.width: 2

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 5

                                Text {
                                    text: "🌡️ Áp suất"
                                    color: theme.primary.dim_foreground
                                    font {
                                        pixelSize: 12
                                        family: "ComicShannsMono Nerd Font"
                                    }
                                    Layout.alignment: Qt.AlignHCenter
                                }

                                Text {
                                    text: weatherPanel.pressure
                                    color: theme.primary.foreground
                                    font {
                                        pixelSize: 20
                                        bold: true
                                        family: "ComicShannsMono Nerd Font"
                                    }
                                    Layout.alignment: Qt.AlignHCenter
                                }
                            }
                        }

                        // Visibility
                        Rectangle {
                            width: 200
                            height: 80
                            color: theme.primary.dim_background
                            radius: 8
                            border.color: theme.button.border
                            border.width: 2

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 5

                                Text {
                                    text: "👁️ Tầm nhìn"
                                    color: theme.primary.dim_foreground
                                    font {
                                        pixelSize: 12
                                        family: "ComicShannsMono Nerd Font"
                                    }
                                    Layout.alignment: Qt.AlignHCenter
                                }

                                Text {
                                    text: weatherPanel.visibility
                                    color: theme.primary.foreground
                                    font {
                                        pixelSize: 20
                                        bold: true
                                        family: "ComicShannsMono Nerd Font"
                                    }
                                    Layout.alignment: Qt.AlignHCenter
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
                locationInput.text = item.name + "," + item.country
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
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "./WeatherTime/" as WeatherTime

Rectangle {
    id: root
    color: theme.primary.background
    radius: currentSizes.radius?.normal || 10
    border.color: theme.normal.black

    border.width: 3

property var lang: currentLanguage
    property string currentDate: ""
    property string currentTime: ""
    property string temperature: "..."
    property string condition: "Đang tải"
    property string icon: "⏳"
    property string humidity: ""
    property string feelsLike: ""
    property bool panelVisible: false
    property bool flagPanelVisible: false
    property bool weatherPanelVisible: false
    property string selectedFlag: currentConfig.countryFlag
    property string weatherApiKey: currentConfig.weatherApiKey
    property string weatherLocation: currentConfig.weatherLocation || "Ho Chi Minh,VN"

    property var theme : currentTheme


    // SystemClock để lấy thời gian thực
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
        onDateChanged: {
            updateDateTime()
        }
    }

    Loader {
        id: launcherPanelLoader
        source: "./WeatherTime/WtDetailPanel.qml"
        active: panelVisible
        onLoaded: {
            item.visible = Qt.binding(function() { return panelVisible })
        }
    }

    // Flag Selection Panel
    Loader {
        id: flagPanelLoader
        source: "./FlagSelectionPanel.qml"
        active: flagPanelVisible
        onLoaded: {
            item.visible = Qt.binding(function() { return flagPanelVisible })
            item.selectedFlag = Qt.binding(function() { return root.selectedFlag })
        }
    }

    // Weather Panel
    Loader {
        id: weatherPanelLoader
        source: "./WeatherPanel.qml"
        active: weatherPanelVisible
        onLoaded: {
            item.visible = Qt.binding(function() { return weatherPanelVisible })
        }
    }

    // Process lấy weather
    Process {
        id: weatherProcess
        command: ["curl", "-s", `https://api.weatherapi.com/v1/current.json?key=${root.weatherApiKey}&q=${root.weatherLocation.replace(/ /g, '%20')}&lang=${currentConfig.lang}`]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {

                if (text && text.length > 0 && root.weatherApiKey !== "") {
                    const parsed = JSON.parse(text)
                    root.processWeatherData(parsed)
                } else if (root.weatherApiKey === "") {
                    root.temperature = "No API"
                    root.condition = "Chưa có API key"
                } else {
                    root.temperature = "Lỗi"
                    root.condition = "Không có dữ liệu"
                }
            }
        }
    }

    function processWeatherData(data) {
        if (data.current) {
            root.temperature = `${Math.round(data.current.temp_c)}°C`
            root.condition = data.current.condition.text
            root.humidity = `${data.current.humidity}%`
            root.feelsLike = `${Math.round(data.current.feelslike_c)}°C`
            root.icon = root.getWeatherIcon(data.current.condition.code, data.current.is_day)
        }
    }

    function getWeatherIcon(code, isDay) {
        const iconMap = {
            "1000": isDay ? "☀️" : "🌙",      // Clear
            "1003": isDay ? "⛅" : "☁️",      // Partly cloudy
            "1006": "☁️",                     // Cloudy
            "1009": "🌫️",                     // Overcast
            "1030": "🌫️",                     // Mist
            "1063": "🌦️",                     // Patchy rain
            "1066": "🌨️",                     // Patchy snow
            "1069": "🌨️",                     // Patchy sleet
            "1072": "🌧️",                     // Patchy freezing drizzle
            "1087": "⛈️",                     // Thundery outbreaks
            "1114": "🌨️",                     // Blowing snow
            "1117": "❄️",                     // Blizzard
            "1135": "🌫️",                     // Fog
            "1147": "🌫️",                     // Freezing fog
            "1150": "🌧️",                     // Patchy light drizzle
            "1153": "🌧️",                     // Light drizzle
            "1168": "🌧️",                     // Freezing drizzle
            "1171": "🌧️",                     // Heavy freezing drizzle
            "1180": "🌦️",                     // Patchy light rain
            "1183": "🌧️",                     // Light rain
            "1186": "🌧️",                     // Moderate rain
            "1189": "🌧️",                     // Heavy rain
            "1192": "🌧️",                     // Heavy rain
            "1195": "🌧️",                     // Heavy rain
            "1198": "🌧️",                     // Light freezing rain
            "1201": "🌧️",                     // Moderate/heavy freezing rain
            "1204": "🌨️",                     // Light sleet
            "1207": "🌨️",                     // Moderate/heavy sleet
            "1210": "🌨️",                     // Patchy light snow
            "1213": "🌨️",                     // Light snow
            "1216": "🌨️",                     // Patchy moderate snow
            "1219": "🌨️",                     // Moderate snow
            "1222": "🌨️",                     // Patchy heavy snow
            "1225": "🌨️",                     // Heavy snow
            "1237": "🌨️",                     // Ice pellets
            "1240": "🌦️",                     // Light rain shower
            "1243": "🌧️",                     // Moderate/heavy rain shower
            "1246": "🌧️",                     // Torrential rain shower
            "1249": "🌨️",                     // Light sleet showers
            "1252": "🌨️",                     // Moderate/heavy sleet showers
            "1255": "🌨️",                     // Light snow showers
            "1258": "🌨️",                     // Moderate/heavy snow showers
            "1261": "🌨️",                     // Light showers of ice pellets
            "1264": "🌨️",                     // Moderate/heavy showers of ice pellets
            "1273": "⛈️",                     // Patchy light rain with thunder
            "1276": "⛈️",                     // Moderate/heavy rain with thunder
            "1279": "⛈️",                     // Patchy light snow with thunder
            "1282": "⛈️",                     // Moderate/heavy snow with thunder
        }
        return iconMap[code.toString()] || "🌈"
    }

    function updateWeather() {
        if (root.weatherApiKey === "" || root.weatherApiKey === undefined) {
            root.temperature = "No API"
            root.condition = "Chưa có key"
            return
        }
        if (!weatherProcess.running) {
            weatherProcess.running = true
        }
    }

    function updateDateTime() {
        const now = clock.date
        const weekdayData = lang?.calendar?.weekdays
        const weekdays = weekdayData ? [
            weekdayData.sunday || "CN",
            weekdayData.monday || "T2",
            weekdayData.tuesday || "T3",
            weekdayData.wednesday || "T4",
            weekdayData.thursday || "T5",
            weekdayData.friday || "T6",
            weekdayData.saturday || "T7"
        ] : ["CN", "T2", "T3", "T4", "T5", "T6", "T7"]

        const monthData = lang?.dateFormat?.month
        const months = monthData ? [
            monthData.january || "Th1",
            monthData.february || "Th2",
            monthData.march || "Th3",
            monthData.april || "Th4",
            monthData.may || "Th5",
            monthData.june || "Th6",
            monthData.july || "Th7",
            monthData.august || "Th8",
            monthData.september || "Th9",
            monthData.october || "Th10",
            monthData.november || "Th11",
            monthData.december || "Th12"
        ] : ["Th1", "Th2", "Th3", "Th4", "Th5", "Th6", "Th7", "Th8", "Th9", "Th10", "Th11", "Th12"]

        root.currentDate = `${weekdays[now.getDay()]}, ${now.getDate()} ${months[now.getMonth()]} ${now.getFullYear()}`
        root.currentTime = Qt.formatTime(now, "HH:mm")
    }

    RowLayout {
        anchors.centerIn: parent
        spacing: currentSizes.spacing?.normal || 8

        // Phần datetime
        Rectangle {
            id: timeContainer
            Layout.preferredWidth: currentSizes.timespaceLayout?.timeContainer || 190
            Layout.fillHeight: true
            color: "transparent"

            ColumnLayout {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 0

                Text {
                    text: root.currentTime
                    color: root.theme.primary.foreground
                    font {
                        pixelSize: currentSizes.fontSize?.medium || 16
                        bold: true
                        family: "ComicShannsMono Nerd Font"
                    }
                }

                Text {
                    text: root.currentDate
                    color: root.theme.primary.dim_foreground
                    font.pixelSize: currentSizes.fontSize?.normal || 13
                    font.family: "ComicShannsMono Nerd Font"
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    root.panelVisible = !root.panelVisible
                    if (root.panelVisible) {
                        root.flagPanelVisible = false
                        root.weatherPanelVisible = false
                    }
                }
                
                // Hiệu ứng hover
                onEntered: {
                    timeContainer.scale = 1.04
                }
                onExited: {
                    timeContainer.scale = 1.0
                }
            }
            
            Behavior on scale { NumberAnimation { duration: 100 } }
        }

        // Phần weather - ĐÃ SỬA: Thêm icon và condition
        Rectangle {
            id: weatherContainer
            Layout.preferredWidth: currentSizes.timespaceLayout?.weatherContainer || 120
            Layout.fillHeight: true
            color: "transparent"


                
                
                
                ColumnLayout {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 1

                    RowLayout {
                        spacing: currentSizes.spacing?.normal || 8
                        Text {
                            text: root.temperature || "Đang tải..."
                            color: root.theme.primary.foreground
                            Layout.alignment: Qt.AlignVCenter
                            font {
                                pixelSize: currentSizes.fontSize?.medium || 16
                                bold: true
                                family: "ComicShannsMono Nerd Font"
                            }
                        }
                        Text {
                            text: root.icon
                            font.pixelSize: currentSizes.fontSize?.xlarge || 24
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }



                    Text {
                        text: root.condition || "..."
                        color: root.theme.primary.dim_foreground
                        font {
                            pixelSize: currentSizes.fontSize?.small || 11
                            family: "ComicShannsMono Nerd Font"
                        }
                        elide: Text.ElideRight
                        maximumLineCount: 1
                        Layout.preferredWidth: 80
                    }
                }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    root.weatherPanelVisible = !root.weatherPanelVisible
                    if (root.weatherPanelVisible) {
                        root.panelVisible = false
                        root.flagPanelVisible = false
                    }
                }
                
                onEntered: {
                    weatherContainer.scale = 1.04
                }
                onExited: {
                    weatherContainer.scale = 1.0
                }
            }
            
            Behavior on scale { NumberAnimation { duration: 100 } }
        }

        // Flag Selector
        Rectangle {
            id: flagContainer
            Layout.preferredWidth: currentSizes.timespaceLayout?.flagContainer || 60
            Layout.preferredHeight: currentSizes.timespaceLayout?.flagContainer || 60
            color: "transparent"

            Image {
                source: root.selectedFlag ? `../../assets/flags/${root.selectedFlag}.png` : ""
                width: currentSizes.iconSize?.large || 50
                height: currentSizes.iconSize?.large || 50
                fillMode: Image.PreserveAspectFit
                smooth: true
                anchors.centerIn: parent
                visible: root.selectedFlag !== ""
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    root.flagPanelVisible = !root.flagPanelVisible
                    if (root.flagPanelVisible) {
                        root.panelVisible = false
                        root.weatherPanelVisible = false
                    }
                }

                onEntered: {
                    flagContainer.scale = 1.1
                }
                onExited: {
                    flagContainer.scale = 1.0
                }
            }

            Behavior on scale { NumberAnimation { duration: 100 } }
        }
    }

    // Timer cho weather (giữ nguyên)
    Timer {
        interval: 50000 // 5 phút
        running: true
        repeat: true
        onTriggered: root.updateWeather()
    }
    Timer {
        id: initialLoadTimer
        interval: 100
        running: true
        repeat: false
        onTriggered: root.updateWeather()
    }

    Component.onCompleted: {
        root.updateDateTime() // Khởi tạo thời gian ban đầu
        root.updateWeather()
    }
}

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Rectangle {
    id: root
    color: "#F5EEE6"
    radius: 8

    property string currentDate: ""
    property string currentTime: ""
    property string temperature: ""
    property string condition: ""
    property string icon: "⛅"
    property string humidity: ""
    property string feelsLike: ""


    // Process lấy weather
    Process {
        id: weatherProcess
        command: ["curl", "-s", `http://api.weatherapi.com/v1/current.json?key=21e0f911c7de4308916165005251210&q=Ho%20Chi%20Minh,VN&aqi=no`]
        running: false
        
        stdout: StdioCollector {
            onStreamFinished: {
                if (text) {
                    try {
                        const data = JSON.parse(text)
                        root.processWeatherData(data)
                    } catch(e) {
                        console.error("Weather API parse error:", e)
                        root.temperature = "Lỗi"
                        root.condition = "Không thể tải"
                    }
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
            console.log("🌤️ Weather updated:", root.temperature, root.condition)
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
        console.log("🔄 Updating weather...")
        if (!weatherProcess.running) {
            weatherProcess.running = true
        }
    }

    function updateDateTime() {
        const now = new Date()
        const weekdays = ["Chủ Nhật", "Thứ Hai", "Thứ Ba", "Thứ Tư", "Thứ Năm", "Thứ Sáu", "Thứ Bảy"]
        const months = ["Tháng 1", "Tháng 2", "Tháng 3", "Tháng 4", "Tháng 5", "Tháng 6", 
                       "Tháng 7", "Tháng 8", "Tháng 9", "Tháng 10", "Tháng 11", "Tháng 12"]
        
        root.currentDate = `${weekdays[now.getDay()]}, ${now.getDate()} ${months[now.getMonth()]} ${now.getFullYear()}`
        root.currentTime = Qt.formatTime(now, "HH:mm:ss")
    }

    Row {
        anchors.centerIn: parent
        spacing: 24

        // Phần datetime
        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 0
            
            Text { 
                text: root.currentTime 
                color: "#000" 
                font { 
                    pixelSize: 16 
                    bold: true 
                    family: "ComicShannsMono Nerd Font"
                }
            }
            
            Text { 
                text: root.currentDate 
                color: "#666" 
                font.pixelSize: 13
                font.family: "ComicShannsMono Nerd Font"
            }
        }

        // Phần weather
            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 1
                
                Text {
                    text: root.temperature || "Đang tải..."
                    color: "#000"
                    font { 
                        pixelSize: 14 
                        bold: true 
                    }
                }
                
                Text {
                    text: root.condition || "Thời tiết"
                    color: "#666"
                    font.pixelSize: 10
                }
            }


        // Cờ Vietnam
        Image {
            source: "./assets/vietnam.png"
            width: 40
            height: 40
            fillMode: Image.PreserveAspectFit
            smooth: true
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    // Timers
    Timer { 
        interval: 1000 
        running: true 
        repeat: true 
        onTriggered: root.updateDateTime() 
    }
    
    
    Timer {
        interval: 300000 // 5 phút
        running: true
        repeat: true
        onTriggered: root.updateWeather()
    }

    Component.onCompleted: {
        root.updateDateTime()
        root.updateWeather()
    }
}

import QtQuick 2.15

Rectangle {
    id: clockPanel
    width: 300
    height: 50
    color: "#F5EEE6"
    radius: 8

    property string currentDate: ""
    property string currentTime: ""
    property string temperature: "--"
    property string description: ""

    Row {
        anchors.centerIn: parent
        spacing: 10

        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2
            Text {
                text: currentTime
                color: "#000000"
                font.pixelSize: 18
            }
            Text {
                text: currentDate
                color: "#000000"
                font.pixelSize: 14
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: temperature + "°C, " + description
            color: "#000000"
            font.pixelSize: 16
        }
        Image {
            source: "./assets/vietnam.svg"
            width: 56
            height: 56
            fillMode: Image.PreserveAspectFit  // giữ tỉ lệ ảnh
            smooth: true

        }

    }

    function updateDateTime() {
        const now = new Date()
        const weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

        const weekday = weekdays[now.getDay()]
        const month = months[now.getMonth()]
        const year = now.getFullYear()
        const day = now.getDate()

        currentDate = `${weekday}, ${month} ${day}, ${year}`
        currentTime = Qt.formatTime(now, "HH:mm")
    }

    function fetchWeather() {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", "https://api.openweathermap.org/data/2.5/weather?q=Hanoi&appid=YOUR_API_KEY&units=metric")
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                var response = JSON.parse(xhr.responseText)
                temperature = Math.round(response.main.temp)
                description = response.weather[0].description
            }
        }
        xhr.send()
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: updateDateTime()
    }

    Timer {
        interval: 10 * 60 * 1000  // 10 phút
        running: true
        repeat: true
        onTriggered: fetchWeather()
    }

    Component.onCompleted: {
        updateDateTime()
        fetchWeather()
    }
}


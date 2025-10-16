import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: calendar
    width: 400
    height: 400
    color: "transparent"
    radius: 10
    
    property date currentDate: new Date()
    property int currentMonth: currentDate.getMonth()
    property int currentYear: currentDate.getFullYear()
    property date selectedDate: new Date()
    
    signal dateSelected(date selectedDate)
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 15
        
        // Header
        RowLayout {
            Layout.fillWidth: true
            
            Button {
                text: "◀"
                onClicked: previousMonth()
                flat: true
                contentItem: Text {
                    text: parent.text
                    color: "#4f4f5b"
                    font.family: "ComicShannsMono Nerd Font"
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: "transparent"
                }
            }
            
            Label {
                text: Qt.formatDate(calendar.currentDate, "MMMM yyyy")
                font.bold: true
                font.pixelSize: 24
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                color: "#4f4f5b"
                font.family: "ComicShannsMono Nerd Font"
            }
            
            Button {
                text: "▶"
                onClicked: nextMonth()
                flat: true
                contentItem: Text {
                    text: parent.text
                    color: "#4f4f5b"
                    font.family: "ComicShannsMono Nerd Font"
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: "transparent"
                }
            }
        }
        
        // Calendar grid với Flickable để cuộn
        Flickable {
            id: flickable
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentWidth: calendarGrid.width
            contentHeight: calendarGrid.height
            clip: true
            
            GridLayout {
                id: calendarGrid
                width: flickable.width
                columns: 7
                rowSpacing: 8
                columnSpacing: 8
                
                // Week day headers
                Repeater {
                    model: ["CN", "T2", "T3", "T4", "T5", "T6", "T7"]
                    Label {
                        text: modelData
                        font.bold: true
                        color: "#4f4f5b"
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30
                        font.pixelSize: 19
                        font.family: "ComicShannsMono Nerd Font"
                    }
                }
                
                // Days
                Repeater {
                    id: daysRepeater
                    model: getDaysInMonth(currentMonth, currentYear)
                    
                    Rectangle {
                        id: dayRect
                        Layout.preferredWidth: 40
                        Layout.preferredHeight: 40
                        color: {
                            if (modelData.isToday && modelData.isCurrentMonth) 
                                return "#4f4f5b"
                            else if (modelData.fullDate.toDateString() === selectedDate.toDateString())
                                return "#B6AE9F"
                            else
                                return "transparent"
                        }
                        radius: 20
                        border.color: modelData.isCurrentMonth ? "#444444" : "transparent"
                        
                        Label {
                            text: modelData.day
                            anchors.centerIn: parent
                            color: {
                                if (!modelData.isCurrentMonth) 
                                    return "#666666"
                                else if (modelData.isToday)
                                    return "white"
                                else
                                    return "#4f4f5b"
                            }
                            font {
                              bold: modelData.isToday
                              pixelSize: 19
                              family: "ComicShannsMono Nerd Font"
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (modelData.isCurrentMonth) {
                                    selectedDate = modelData.fullDate
                                    calendar.dateSelected(selectedDate)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    function getDaysInMonth(month, year) {
        var days = []
        var firstDay = new Date(year, month, 1)
        var lastDay = new Date(year, month + 1, 0)
        var startingDay = firstDay.getDay()
        
        // Ngày từ tháng trước
        var prevMonthLastDay = new Date(year, month, 0).getDate()
        for (var i = 0; i < startingDay; i++) {
            days.push({
                day: prevMonthLastDay - startingDay + i + 1,
                isCurrentMonth: false,
                isToday: false,
                fullDate: new Date(year, month - 1, prevMonthLastDay - startingDay + i + 1)
            })
        }
        
        // Ngày của tháng hiện tại
        var today = new Date()
        for (var j = 1; j <= lastDay.getDate(); j++) {
            var isToday = today.getDate() === j && 
                         today.getMonth() === month && 
                         today.getFullYear() === year
            days.push({
                day: j,
                isCurrentMonth: true,
                isToday: isToday,
                fullDate: new Date(year, month, j)
            })
        }
        
        // Ngày từ tháng sau
        var totalCells = 42
        var nextMonthDay = 1
        while (days.length < totalCells) {
            days.push({
                day: nextMonthDay,
                isCurrentMonth: false,
                isToday: false,
                fullDate: new Date(year, month + 1, nextMonthDay)
            })
            nextMonthDay++
        }
        
        return days
    }
    
    function previousMonth() {
        currentDate = new Date(currentYear, currentMonth - 1, 1)
        currentMonth = currentDate.getMonth()
        currentYear = currentDate.getFullYear()
        daysRepeater.model = getDaysInMonth(currentMonth, currentYear)
    }
    
    function nextMonth() {
        currentDate = new Date(currentYear, currentMonth + 1, 1)
        currentMonth = currentDate.getMonth()
        currentYear = currentDate.getFullYear()
        daysRepeater.model = getDaysInMonth(currentMonth, currentYear)
    }
    
    function goToToday() {
        currentDate = new Date()
        currentMonth = currentDate.getMonth()
        currentYear = currentDate.getFullYear()
        selectedDate = new Date()
        daysRepeater.model = getDaysInMonth(currentMonth, currentYear)
    }
    
    Component.onCompleted: {
        daysRepeater.model = getDaysInMonth(currentMonth, currentYear)
    }
}

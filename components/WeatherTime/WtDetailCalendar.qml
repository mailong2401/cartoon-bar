import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: calendar
    width: currentSizes.wtDetailPanel?.calendar?.width || 400
    height: currentSizes.wtDetailPanel?.calendar?.height || 400
    color: "transparent"
    radius: currentSizes.wtDetailPanel?.calendar?.radius || 10
    
    property date currentDate: new Date()
    property int currentMonth: currentDate.getMonth()
    property int currentYear: currentDate.getFullYear()
    property date selectedDate: new Date()
    
    property var theme : currentTheme
    property var lang : currentLanguage

    property var weekdayLabels: {
        const w = lang?.calendar?.weekdays
        return w ? [
            w.sunday || "CN",
            w.monday || "T2",
            w.tuesday || "T3",
            w.wednesday || "T4",
            w.thursday || "T5",
            w.friday || "T6",
            w.saturday || "T7"
        ] : ["CN", "T2", "T3", "T4", "T5", "T6", "T7"]
    }

    property var monthLabels: {
        const m = lang?.dateFormat?.month
        return m ? [
            m.january || "Tháng 1",
            m.february || "Tháng 2",
            m.march || "Tháng 3",
            m.april || "Tháng 4",
            m.may || "Tháng 5",
            m.june || "Tháng 6",
            m.july || "Tháng 7",
            m.august || "Tháng 8",
            m.september || "Tháng 9",
            m.october || "Tháng 10",
            m.november || "Tháng 11",
            m.december || "Tháng 12"
        ] : ["Tháng 1", "Tháng 2", "Tháng 3", "Tháng 4", "Tháng 5", "Tháng 6", "Tháng 7", "Tháng 8", "Tháng 9", "Tháng 10", "Tháng 11", "Tháng 12"]
    }

    signal dateSelected(date selectedDate)
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: currentSizes.wtDetailPanel?.calendar?.margins || 10
        spacing: currentSizes.wtDetailPanel?.calendar?.spacing || 15
        
        // Header
        RowLayout {
            Layout.fillWidth: true
            
            Button {
                text: "◀"
                onClicked: previousMonth()
                flat: true
                contentItem: Text {
                    text: parent.text
                    color: theme.primary.foreground
                    font.family: "ComicShannsMono Nerd Font"
                    font.pixelSize: currentSizes.wtDetailPanel?.calendar?.navButtonFontSize || 20
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: "transparent"
                }
            }

            Label {
                text: monthLabels[currentMonth] + " " + currentYear
                font.bold: true
                font.pixelSize: currentSizes.wtDetailPanel?.calendar?.monthLabelFontSize || 24
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                color: theme.primary.foreground
                font.family: "ComicShannsMono Nerd Font"
            }

            Button {
                text: "▶"
                onClicked: nextMonth()
                flat: true
                contentItem: Text {
                    text: parent.text
                    color: theme.primary.foreground
                    font.family: "ComicShannsMono Nerd Font"
                    font.pixelSize: currentSizes.wtDetailPanel?.calendar?.navButtonFontSize || 20
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
                rowSpacing: currentSizes.wtDetailPanel?.calendar?.gridRowSpacing || 8
                columnSpacing: currentSizes.wtDetailPanel?.calendar?.gridColumnSpacing || 8

                // Week day headers
                Repeater {
                    model: weekdayLabels
                    Label {
                        text: modelData
                        font.bold: true
                        color: theme.primary.foreground
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                        Layout.preferredHeight: currentSizes.wtDetailPanel?.calendar?.weekdayHeight || 30
                        font.pixelSize: currentSizes.wtDetailPanel?.calendar?.weekdayFontSize || 19
                        font.family: "ComicShannsMono Nerd Font"
                    }
                }

                // Days
                Repeater {
                    id: daysRepeater
                    model: getDaysInMonth(currentMonth, currentYear)

                    Rectangle {
                        id: dayRect
                        Layout.preferredWidth: currentSizes.wtDetailPanel?.calendar?.dayCellSize || 40
                        Layout.preferredHeight: currentSizes.wtDetailPanel?.calendar?.dayCellSize || 40
                        color: {
                            if (modelData.isToday && modelData.isCurrentMonth)
                                return theme.button.background
                            else if (modelData.fullDate.toDateString() === selectedDate.toDateString())
                                return theme.button.background_select
                            else
                                return "transparent"
                        }
                        radius: currentSizes.wtDetailPanel?.calendar?.dayCellRadius || 20
                        border.color: modelData.isCurrentMonth ? theme.button.border : "transparent"

                        Label {
                            text: modelData.day
                            anchors.centerIn: parent
                            color: {
                                if (!modelData.isCurrentMonth)
                                    return theme.primary.dim_foreground
                                else if (modelData.isToday)
                                    return "white"
                                else
                                    return theme.primary.foreground
                            }
                            font {
                              bold: modelData.isToday
                              pixelSize: currentSizes.wtDetailPanel?.calendar?.dayFontSize || 19
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

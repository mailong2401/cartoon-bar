import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import QtQuick.Controls

PanelWindow {
    id: root
    WlrLayershell.exclusiveZone: 0   // không chiếm không gian ứng dụng

    anchors {
        top: true
        bottom: true 
        left: true
        right: true
    }

    margins {
        top: 20
        bottom: 20
        left: 20
        right: 20
    }
    
    property string currentHour: ""
    property string currentMin: ""
    property string currentDay: ""
    property string currentDate: ""
    property var lang: currentLanguage

    
    implicitWidth: content.implicitWidth + 40
    implicitHeight: content.implicitHeight + 40

    WlrLayershell.layer: WlrLayer.Bottom

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
        onDateChanged: {
            updateDateTime()
        }
    }
    
    function updateDateTime() {
        const now = new Date()
        const weekdays = [
  lang.dateFormat.day.sunday,
  lang.dateFormat.day.monday,
  lang.dateFormat.day.tuesday,
  lang.dateFormat.day.wednesday,
  lang.dateFormat.day.thursday,
  lang.dateFormat.day.friday,
  lang.dateFormat.day.saturday
]

const months = [
  lang.dateFormat.month.january,
  lang.dateFormat.month.february,
  lang.dateFormat.month.march,
  lang.dateFormat.month.april,
  lang.dateFormat.month.may,
  lang.dateFormat.month.june,
  lang.dateFormat.month.july,
  lang.dateFormat.month.august,
  lang.dateFormat.month.september,
  lang.dateFormat.month.october,
  lang.dateFormat.month.november,
  lang.dateFormat.month.december
]

        
        root.currentDay = `${weekdays[now.getDay()]}`
        root.currentHour = Qt.formatTime(now, "HH")
        root.currentMin = Qt.formatTime(now, "mm")
        root.currentDate = `${now.getDate()} ${months[now.getMonth()]} ${now.getFullYear()}`
    }
    
    color: "transparent"
    
    Rectangle {
        id: clockContainer
        anchors.fill: parent
        radius: 10
        color: "transparent"
        
        RowLayout {
            id: content
            anchors.centerIn: parent
            spacing: 33
                    
            // Phần hiển thị thời gian (giờ và phút)
            ColumnLayout {
                spacing: 5
                Text {
                    id: timeHour
                    text: root.currentHour
                    color: "#ffffff"
                    font { 
                        pixelSize: 124 
                        bold: true 
                        family: "ComicShannsMono Nerd Font"
                    }
                }
                
                Text {
                    id: timeMin
                    text: root.currentMin
                    color: "#ffffff"
                    font { 
                        pixelSize: 124 
                        bold: true 
                        family: "ComicShannsMono Nerd Font"
                    }
                }
            }

            Rectangle {
                Layout.preferredWidth: 10
                Layout.preferredHeight: Math.max(timeHour.implicitHeight, timeMin.implicitHeight) * 2
                color: "#ffffff"
                radius: 10
            }
            
            // Phần hiển thị ngày tháng
            ColumnLayout {
                spacing: 5
                Text {
                    id: dayText
                    text: root.currentDay
                    color: "#ffffff"
                    font { 
                        pixelSize: 124 
                        bold: true 
                        family: "ComicShannsMono Nerd Font"
                    }
                }
                Text {
                    id: dateText
                    text: root.currentDate
                    color: "#ffffff"
                    font { 
                        pixelSize: 64 
                        bold: true 
                        family: "ComicShannsMono Nerd Font"
                    }
                }
            }
        }
    }
    
    Component.onCompleted: {
        root.updateDateTime() // Khởi tạo thời gian ban đầu
    }
}

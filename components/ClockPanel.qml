import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import QtQuick.Controls

PanelWindow {
    id: root

    Connections {
        target: GlobalSettings
        onClockPanelVisibilityChanged: {
            visible = isVisible
        }
    }

    property int marginTop: 0
    property int marginBottom: 0
    property int marginLeft: 0
    property int marginRight: 0

    property bool anchorsTop: false
    property bool anchorsBottom: false
    property bool anchorsRight: false
    property bool anchorsLeft: false

    
    anchors {
        top: anchorsTop
        bottom: anchorsBottom
        left: anchorsLeft
        right: anchorsRight
    }

    margins {
        top: marginTop
        bottom: marginBottom
        left: marginLeft
        right: marginRight
    }
    
    property string currentHour: ""
    property string currentMin: ""
    property string currentDay: ""
    property string currentDate: ""
    
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
        const weekdays = ["Chủ nhật", "Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7"]
        const months = ["Tháng 1", "Tháng 2", "Tháng 3", "Tháng 4", "Tháng 5", "Tháng 6", 
                      "Tháng 7", "Tháng 8", "Tháng 9", "Tháng 10", "Tháng 11", "Tháng 12"]
        
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

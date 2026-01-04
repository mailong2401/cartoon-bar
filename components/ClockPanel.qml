import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import QtQuick.Controls

PanelWindow {
    id: root
    WlrLayershell.exclusiveZone: 0   // không chiếm không gian ứng dụng

    property var sizes: currentSizes.clockPanel || {}
    property string currentHour: ""
    property string currentMin: ""
    property string currentDay: ""
    property string currentDate: ""
    property var lang: currentLanguage

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    margins {
        top: sizes.anchorMargin || 20
        bottom: sizes.anchorMargin || 20
        left: sizes.anchorMargin || 20
        right: sizes.anchorMargin || 20
    }

    implicitWidth: content.implicitWidth + (sizes.contentPadding || 40)
    implicitHeight: content.implicitHeight + (sizes.contentPadding || 40)

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
        const dayData = lang?.dateFormat?.day
        const weekdays = dayData ? [
            dayData.sunday || "CN",
            dayData.monday || "T2",
            dayData.tuesday || "T3",
            dayData.wednesday || "T4",
            dayData.thursday || "T5",
            dayData.friday || "T6",
            dayData.saturday || "T7"
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

        root.currentDay = `${weekdays[now.getDay()]}`
        root.currentHour = Qt.formatTime(now, "HH")
        root.currentMin = Qt.formatTime(now, "mm")
        root.currentDate = `${now.getDate()} ${months[now.getMonth()]} ${now.getFullYear()}`
    }
    
    color: "transparent"
    
    Rectangle {
        id: clockContainer
        anchors.fill: parent
        radius: sizes.containerRadius || 10
        color: "transparent"

        RowLayout {
            id: content
            anchors.centerIn: parent
            spacing: sizes.contentSpacing || 33

            // Phần hiển thị thời gian (giờ và phút)
            ColumnLayout {
                spacing: sizes.columnSpacing || 5
                Text {
                    id: timeHour
                    text: root.currentHour
                    color: "#ffffff"
                    font {
                        pixelSize: sizes.timeFontSize || 124
                        bold: true
                        family: "ComicShannsMono Nerd Font"
                    }
                }

                Text {
                    id: timeMin
                    text: root.currentMin
                    color: "#ffffff"
                    font {
                        pixelSize: sizes.timeFontSize || 124
                        bold: true
                        family: "ComicShannsMono Nerd Font"
                    }
                }
            }

            Rectangle {
                Layout.preferredWidth: sizes.dividerWidth || 10
                Layout.preferredHeight: Math.max(timeHour.implicitHeight, timeMin.implicitHeight) * 2
                color: "#ffffff"
                radius: sizes.dividerRadius || 10
            }

            // Phần hiển thị ngày tháng
            ColumnLayout {
                spacing: sizes.columnSpacing || 5
                Text {
                    id: dayText
                    text: root.currentDay
                    color: "#ffffff"
                    font {
                        pixelSize: sizes.dayFontSize || 124
                        bold: true
                        family: "ComicShannsMono Nerd Font"
                    }
                }
                Text {
                    id: dateText
                    text: root.currentDate
                    color: "#ffffff"
                    font {
                        pixelSize: sizes.dateFontSize || 64
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

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    Layout.preferredWidth: 210
    Layout.fillHeight: true
    radius: 12
    color: theme.primary.dim_background
    border.color: theme.normal.black
    border.width: 2

    property var theme


    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        // Tiêu đề Menu
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            border.color: theme.button.border
            border.width: 3
            radius: 8
            color: theme.button.background
            
            Text {
                anchors.centerIn: parent
                text: "Menu"
                color: theme.primary.foreground
                font.pixelSize: 18
                font.family: "ComicShannsMono Nerd Font"
            }
          }
          // Cài đặt
        Rectangle {
            id: settingsButton
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            radius: 8
            color: mouseAreaSettings.containsMouse ? theme.button.background_select : theme.button.background
            border.color: mouseAreaSettings.containsPress ? theme.button.border_select : theme.button.border
            border.width: 3
            
            scale: mouseAreaSettings.containsPress ? 0.98 : 1.0
            Behavior on scale { NumberAnimation { duration: 100 } }
            Behavior on color { ColorAnimation { duration: 200 } }
            Behavior on border.color { ColorAnimation { duration: 100 } }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                
                Image {
                    source: "../../assets/system/setting.png"
                    Layout.preferredHeight: 28
                    Layout.preferredWidth: 28
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    
                    rotation: mouseAreaSettings.containsMouse ? 360 : 0
                    Behavior on rotation { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }
                }

                Text {
                    text: "Cài đặt"
                    color: mouseAreaSettings.containsMouse ? theme.primary.bright_foreground : theme.primary.foreground
                    font.pixelSize: 16
                    font.family: "ComicShannsMono Nerd Font"
                    
                    scale: mouseAreaSettings.containsMouse ? 1.05 : 1.0
                    Behavior on scale { NumberAnimation { duration: 200 } }
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Item { Layout.fillWidth: true }
            }

            MouseArea {
                id: mouseAreaSettings
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    console.log("Cài đặt được nhấn")
                    // Thêm code để mở cài đặt ở đây
                }
            }
        }

        // Chế độ ngủ
        Rectangle {
            id: sleepButton
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            radius: 8
            color: mouseAreaSleep.containsMouse ? theme.button.background_select : theme.button.background
            border.color: mouseAreaSleep.containsPress ? theme.button.border_select : theme.button.border
            border.width: 3
            
            // Hiệu ứng scale khi hover
            scale: mouseAreaSleep.containsPress ? 0.98 : 1.0
            Behavior on scale { NumberAnimation { duration: 100 } }
            
            // Hiệu ứng màu khi hover
            Behavior on color { ColorAnimation { duration: 200 } }
            Behavior on border.color { ColorAnimation { duration: 100 } }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                
                Image {
                    source: "../../assets/system/sys-sleep.png"
                    Layout.preferredHeight: 28
                    Layout.preferredWidth: 28
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    
                    // Hiệu ứng icon khi hover
                    rotation: mouseAreaSleep.containsMouse ? 5 : 0
                    Behavior on rotation { NumberAnimation { duration: 200 } }
                }

                Text {
                    text: "Chế độ ngủ"
                    color: mouseAreaSleep.containsMouse ? theme.primary.bright_foreground : theme.primary.foreground
                    font.pixelSize: 16
                    font.family: "ComicShannsMono Nerd Font"
                    
                    // Hiệu ứng text khi hover
                    scale: mouseAreaSleep.containsMouse ? 1.05 : 1.0
                    Behavior on scale { NumberAnimation { duration: 200 } }
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Item { Layout.fillWidth: true }
            }

            MouseArea {
                id: mouseAreaSleep
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                
                onClicked: {
                    console.log("Chế độ ngủ được nhấn")
                    // Thêm code để thực hiện chế độ ngủ ở đây
                }
            }
        }

        // Khóa màn hình
        Rectangle {
            id: lockButton
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            radius: 8
            color: mouseAreaLock.containsMouse ? theme.button.background_select : theme.button.background
            border.color: mouseAreaLock.containsPress ? theme.button.border_select : theme.button.border
            border.width: 3
            
            scale: mouseAreaLock.containsPress ? 0.98 : 1.0
            Behavior on scale { NumberAnimation { duration: 100 } }
            Behavior on color { ColorAnimation { duration: 200 } }
            Behavior on border.color { ColorAnimation { duration: 100 } }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                
                Image {
                    source: "../../assets/system/sys-lock.png"
                    Layout.preferredHeight: 28
                    Layout.preferredWidth: 28
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    
                    rotation: mouseAreaLock.containsMouse ? 5 : 0
                    Behavior on rotation { NumberAnimation { duration: 200 } }
                }

                Text {
                    text: "Khóa màn hình"
                    color: mouseAreaLock.containsMouse ? theme.primary.bright_foreground : theme.primary.foreground
                    font.pixelSize: 16
                    font.family: "ComicShannsMono Nerd Font"
                    
                    scale: mouseAreaLock.containsMouse ? 1.05 : 1.0
                    Behavior on scale { NumberAnimation { duration: 200 } }
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Item { Layout.fillWidth: true }
            }

            MouseArea {
                id: mouseAreaLock
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                
                onClicked: {
                    console.log("Khóa màn hình được nhấn")
                    // Thêm code để khóa màn hình ở đây
                }
            }
        }

        

        // Đăng xuất
        Rectangle {
            id: logoutButton
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            radius: 8
            color: mouseAreaLogout.containsMouse ? theme.button.background_select : theme.button.background
            border.color: mouseAreaLogout.containsPress ? theme.button.border_select : theme.button.border
            border.width: 3
            
            scale: mouseAreaLogout.containsPress ? 0.98 : 1.0
            Behavior on scale { NumberAnimation { duration: 100 } }
            Behavior on color { ColorAnimation { duration: 200 } }
            Behavior on border.color { ColorAnimation { duration: 100 } }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                
                Image {
                    source: "../../assets/system/sys-exit.png"
                    Layout.preferredHeight: 28
                    Layout.preferredWidth: 28
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    
                    rotation: mouseAreaLogout.containsMouse ? -5 : 0
                    Behavior on rotation { NumberAnimation { duration: 200 } }
                }

                Text {
                    text: "Đăng xuất"
                    color: mouseAreaLogout.containsMouse ? theme.primary.bright_foreground : theme.primary.foreground
                    font.pixelSize: 16
                    font.family: "ComicShannsMono Nerd Font"
                    
                    scale: mouseAreaLogout.containsMouse ? 1.05 : 1.0
                    Behavior on scale { NumberAnimation { duration: 200 } }
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Item { Layout.fillWidth: true }
            }

            MouseArea {
                id: mouseAreaLogout
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                
                onClicked: {
                    console.log("Đăng xuất được nhấn")
                    // Thêm code để đăng xuất ở đây
                }
            }
        }

        // Khởi động lại
        Rectangle {
            id: restartButton
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            radius: 8
            color: mouseAreaRestart.containsMouse ? theme.button.background_select : theme.button.background
            border.color: mouseAreaRestart.containsPress ? theme.button.border_select : theme.button.border
            border.width: 3
            
            scale: mouseAreaRestart.containsPress ? 0.98 : 1.0
            Behavior on scale { NumberAnimation { duration: 100 } }
            Behavior on color { ColorAnimation { duration: 200 } }
            Behavior on border.color { ColorAnimation { duration: 100 } }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                
                Image {
                    source: "../../assets/system/sys-reboot.png"
                    Layout.preferredHeight: 28
                    Layout.preferredWidth: 28
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    
                    rotation: mouseAreaRestart.containsMouse ? 180 : 0
                    Behavior on rotation { NumberAnimation { duration: 400; easing.type: Easing.InOutCubic } }
                }

                Text {
                    text: "Khởi động lại"
                    color: mouseAreaRestart.containsMouse ? theme.primary.bright_foreground : theme.primary.foreground
                    font.pixelSize: 16
                    font.family: "ComicShannsMono Nerd Font"
                    
                    scale: mouseAreaRestart.containsMouse ? 1.05 : 1.0
                    Behavior on scale { NumberAnimation { duration: 200 } }
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Item { Layout.fillWidth: true }
            }

            MouseArea {
                id: mouseAreaRestart
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                
                onClicked: {
                    console.log("Khởi động lại được nhấn")
                    // Thêm code để khởi động lại ở đây
                }
            }
        }

        // Tắt máy
        Rectangle {
            id: shutdownButton
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            radius: 8
            color: mouseAreaShutdown.containsMouse ? theme.button.background_select : theme.button.background
            border.color: mouseAreaShutdown.containsPress ? theme.button.border_select : theme.button.border
            border.width: 3
            
            scale: mouseAreaShutdown.containsPress ? 0.98 : 1.0
            Behavior on scale { NumberAnimation { duration: 100 } }
            Behavior on color { ColorAnimation { duration: 200 } }
            Behavior on border.color { ColorAnimation { duration: 100 } }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                
                Image {
                    source: "../../assets/system/poweroff.png"
                    Layout.preferredHeight: 28
                    Layout.preferredWidth: 28
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    
                    scale: mouseAreaShutdown.containsMouse ? 1.1 : 1.0
                    Behavior on scale { NumberAnimation { duration: 200 } }
                }

                Text {
                    text: "Tắt máy"
                    color: mouseAreaShutdown.containsMouse ? theme.primary.bright_foreground : theme.primary.foreground
                    font.pixelSize: 16
                    font.family: "ComicShannsMono Nerd Font"
                    font.bold: mouseAreaShutdown.containsMouse
                    
                    scale: mouseAreaShutdown.containsMouse ? 1.05 : 1.0
                    Behavior on scale { NumberAnimation { duration: 200 } }
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Item { Layout.fillWidth: true }
            }

            MouseArea {
                id: mouseAreaShutdown
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                
                onClicked: {
                    console.log("Tắt máy được nhấn")
                    // Thêm code để tắt máy ở đây
                }
            }
        }

        Item { Layout.fillHeight: true }
    }
}

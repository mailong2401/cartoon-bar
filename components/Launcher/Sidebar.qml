import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    Layout.preferredWidth: 210
    Layout.fillHeight: true
    radius: 12
    color: "#E8D8C9"
    border.color: "#4f4f5b"
    border.width: 2

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        // Tiêu đề Menu
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            border.color: "#4f4f5b"
            border.width: 3
            radius: 8
            color: "#4f4f5b"
            
            Text {
                anchors.centerIn: parent
                text: "Menu"
                color: "#fff"
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
            color: mouseAreaSettings.containsMouse ? "#9c8f83" : "#b0a89e"
            border.color: mouseAreaSettings.containsPress ? "#333" : "#4f4f5b"
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
                    color: mouseAreaSettings.containsMouse ? "#111" : "#333"
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
            color: mouseAreaSleep.containsMouse ? "#9c8f83" : "#b0a89e"
            border.color: mouseAreaSleep.containsPress ? "#333" : "#4f4f5b"
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
                    color: mouseAreaSleep.containsMouse ? "#111" : "#333"
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
            color: mouseAreaLock.containsMouse ? "#9c8f83" : "#b0a89e"
            border.color: mouseAreaLock.containsPress ? "#333" : "#4f4f5b"
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
                    color: mouseAreaLock.containsMouse ? "#111" : "#333"
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
            color: mouseAreaLogout.containsMouse ? "#9c8f83" : "#b0a89e"
            border.color: mouseAreaLogout.containsPress ? "#333" : "#4f4f5b"
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
                    color: mouseAreaLogout.containsMouse ? "#111" : "#333"
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
            color: mouseAreaRestart.containsMouse ? "#9c8f83" : "#b0a89e"
            border.color: mouseAreaRestart.containsPress ? "#333" : "#4f4f5b"
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
                    color: mouseAreaRestart.containsMouse ? "#111" : "#333"
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
            color: mouseAreaShutdown.containsMouse ? "#ff6b6b" : "#b0a89e"
            border.color: mouseAreaShutdown.containsPress ? "#cc0000" : "#4f4f5b"
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
                    color: mouseAreaShutdown.containsMouse ? "#fff" : "#333"
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

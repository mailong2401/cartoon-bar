import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io


Rectangle {
    id: root
    Layout.preferredWidth: 210
    Layout.fillHeight: true
    radius: 12
    color: theme.primary.dim_background
    border.color: theme.normal.black
    border.width: 2

    property var theme : currentTheme
    property var lang : currentLanguage

    signal appLaunched()
    signal appSettings()

    Process { id: sleepProcess }
    Process { id: lockProcess }
    Process { id: logoutProcess }
    Process { id: restartProcess }
    Process { id: shutdownProcess }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        // Tiêu đề Menu
        Rectangle {
            id: launcherButton
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            radius: 8
            color: mouseAreaLauncher.containsMouse ? theme.button.background_select : theme.button.background
            border.color: mouseAreaLauncher.containsPress ? theme.button.border_select : theme.button.border
            border.width: 3
            
            scale: mouseAreaLauncher.containsPress ? 0.98 : 1.0
            Behavior on scale { NumberAnimation { duration: 100 } }
            Behavior on color { ColorAnimation { duration: 200 } }
            Behavior on border.color { ColorAnimation { duration: 100 } }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                
                Image {
                    source: "../../assets/dashboard.png"
                    Layout.preferredHeight: 28
                    Layout.preferredWidth: 28
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    
                    rotation: mouseAreaLauncher.containsMouse ? 0 : 90
                    Behavior on rotation { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }
                }

                Text {
                    text: lang.system.application
                    color: mouseAreaLauncher.containsMouse ? theme.primary.bright_foreground : theme.primary.foreground
                    font.pixelSize: 16
                    font.family: "ComicShannsMono Nerd Font"
                    font.bold: mouseAreaLauncher.containsMouse
                    
                    scale: mouseAreaLauncher.containsMouse ? 1.05 : 1.0
                    Behavior on scale { NumberAnimation { duration: 200 } }
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Item { Layout.fillWidth: true }

                // Indicator khi selected
                Rectangle {
                    Layout.preferredWidth: 4
                    Layout.preferredHeight: 20
                    radius: 2
                    color: theme.normal.green
                    visible: false // Sẽ được điều khiển bởi trạng thái selected
                    opacity: mouseAreaLauncher.containsMouse ? 1.0 : 0.8
                    
                    scale: false ? 1.0 : 0.0 // Thay false bằng điều kiện selected thực tế
                    Behavior on scale { 
                        NumberAnimation { 
                            duration: 300; 
                            easing.type: Easing.OutBack 
                        } 
                    }
                    Behavior on opacity { NumberAnimation { duration: 200 } }
                }
            }

            MouseArea {
                id: mouseAreaLauncher
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    console.log("Launcher được nhấn")
                    root.appLaunched()
                }
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
                    text: lang.settings.title
                    color: mouseAreaSettings.containsMouse ? theme.primary.bright_foreground : theme.primary.foreground
                    font.pixelSize: 16
                    font.family: "ComicShannsMono Nerd Font"
                    font.bold: mouseAreaSettings.containsMouse
                    
                    scale: mouseAreaSettings.containsMouse ? 1.05 : 1.0
                    Behavior on scale { NumberAnimation { duration: 200 } }
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Item { Layout.fillWidth: true }

                // Indicator khi selected
                Rectangle {
                    Layout.preferredWidth: 4
                    Layout.preferredHeight: 20
                    radius: 2
                    color: theme.accent.color
                    visible: false // Sẽ được điều khiển bởi trạng thái selected
                    opacity: mouseAreaSettings.containsMouse ? 1.0 : 0.8
                    
                    scale: false ? 1.0 : 0.0 // Thay false bằng điều kiện selected thực tế
                    Behavior on scale { 
                        NumberAnimation { 
                            duration: 300; 
                            easing.type: Easing.OutBack 
                        } 
                    }
                    Behavior on opacity { NumberAnimation { duration: 200 } }
                }
            }

            MouseArea {
                id: mouseAreaSettings
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    console.log("Cài đặt được nhấn")
                    root.appSettings()
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
            
            scale: mouseAreaSleep.containsPress ? 0.98 : 1.0
            Behavior on scale { NumberAnimation { duration: 100 } }
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
                    
                    rotation: mouseAreaSleep.containsMouse ? 5 : 0
                    Behavior on rotation { NumberAnimation { duration: 200 } }
                }

                Text {
                    text: lang.system.sleep
                    color: mouseAreaSleep.containsMouse ? theme.primary.bright_foreground : theme.primary.foreground
                    font.pixelSize: 16
                    font.family: "ComicShannsMono Nerd Font"
                    font.bold: mouseAreaSleep.containsMouse
                    
                    scale: mouseAreaSleep.containsMouse ? 1.05 : 1.0
                    Behavior on scale { NumberAnimation { duration: 200 } }
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Item { Layout.fillWidth: true }

                // Indicator khi selected
                Rectangle {
                    Layout.preferredWidth: 4
                    Layout.preferredHeight: 20
                    radius: 2
                    color: theme.accent.color
                    visible: false // Sẽ được điều khiển bởi trạng thái selected
                    opacity: mouseAreaSleep.containsMouse ? 1.0 : 0.8
                    
                    scale: false ? 1.0 : 0.0 // Thay false bằng điều kiện selected thực tế
                    Behavior on scale { 
                        NumberAnimation { 
                            duration: 300; 
                            easing.type: Easing.OutBack 
                        } 
                    }
                    Behavior on opacity { NumberAnimation { duration: 200 } }
                }
            }

            MouseArea {
                id: mouseAreaSleep
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                
                onClicked: {
                    console.log("Chế độ ngủ được nhấn")
                    sleepProcess.command = ["systemctl", "suspend"]
                    sleepProcess.startDetached()
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
                    text: lang.system.lock
                    color: mouseAreaLock.containsMouse ? theme.primary.bright_foreground : theme.primary.foreground
                    font.pixelSize: 16
                    font.family: "ComicShannsMono Nerd Font"
                    font.bold: mouseAreaLock.containsMouse
                    
                    scale: mouseAreaLock.containsMouse ? 1.05 : 1.0
                    Behavior on scale { NumberAnimation { duration: 200 } }
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Item { Layout.fillWidth: true }

                // Indicator khi selected
                Rectangle {
                    Layout.preferredWidth: 4
                    Layout.preferredHeight: 20
                    radius: 2
                    color: theme.accent.color
                    visible: false // Sẽ được điều khiển bởi trạng thái selected
                    opacity: mouseAreaLock.containsMouse ? 1.0 : 0.8
                    
                    scale: false ? 1.0 : 0.0 // Thay false bằng điều kiện selected thực tế
                    Behavior on scale { 
                        NumberAnimation { 
                            duration: 300; 
                            easing.type: Easing.OutBack 
                        } 
                    }
                    Behavior on opacity { NumberAnimation { duration: 200 } }
                }
            }

            MouseArea {
                id: mouseAreaLock
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                
                onClicked: {
                    console.log("Khóa màn hình được nhấn")
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
                    text: lang.system.logout
                    color: mouseAreaLogout.containsMouse ? theme.primary.bright_foreground : theme.primary.foreground
                    font.pixelSize: 16
                    font.family: "ComicShannsMono Nerd Font"
                    font.bold: mouseAreaLogout.containsMouse
                    
                    scale: mouseAreaLogout.containsMouse ? 1.05 : 1.0
                    Behavior on scale { NumberAnimation { duration: 200 } }
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Item { Layout.fillWidth: true }

                // Indicator khi selected
                Rectangle {
                    Layout.preferredWidth: 4
                    Layout.preferredHeight: 20
                    radius: 2
                    color: theme.accent.color
                    visible: false // Sẽ được điều khiển bởi trạng thái selected
                    opacity: mouseAreaLogout.containsMouse ? 1.0 : 0.8
                    
                    scale: false ? 1.0 : 0.0 // Thay false bằng điều kiện selected thực tế
                    Behavior on scale { 
                        NumberAnimation { 
                            duration: 300; 
                            easing.type: Easing.OutBack 
                        } 
                    }
                    Behavior on opacity { NumberAnimation { duration: 200 } }
                }
            }

            MouseArea {
                id: mouseAreaLogout
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                
                onClicked: {
                    logoutProcess.command = ["hyprctl", "dispatch", "exit"]
                    logoutProcess.startDetached()
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
                    text: lang.system.restart
                    color: mouseAreaRestart.containsMouse ? theme.primary.bright_foreground : theme.primary.foreground
                    font.pixelSize: 16
                    font.family: "ComicShannsMono Nerd Font"
                    font.bold: mouseAreaRestart.containsMouse
                    
                    scale: mouseAreaRestart.containsMouse ? 1.05 : 1.0
                    Behavior on scale { NumberAnimation { duration: 200 } }
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Item { Layout.fillWidth: true }

                // Indicator khi selected
                Rectangle {
                    Layout.preferredWidth: 4
                    Layout.preferredHeight: 20
                    radius: 2
                    color: theme.accent.color
                    visible: false // Sẽ được điều khiển bởi trạng thái selected
                    opacity: mouseAreaRestart.containsMouse ? 1.0 : 0.8
                    
                    scale: false ? 1.0 : 0.0 // Thay false bằng điều kiện selected thực tế
                    Behavior on scale { 
                        NumberAnimation { 
                            duration: 300; 
                            easing.type: Easing.OutBack 
                        } 
                    }
                    Behavior on opacity { NumberAnimation { duration: 200 } }
                }
            }

            MouseArea {
                id: mouseAreaRestart
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                
                onClicked: {
                    restartProcess.command = ["systemctl", "reboot"]
                    restartProcess.startDetached()
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
                    text: lang.system.shutdown
                    color: mouseAreaShutdown.containsMouse ? theme.primary.bright_foreground : theme.primary.foreground
                    font.pixelSize: 16
                    font.family: "ComicShannsMono Nerd Font"
                    font.bold: mouseAreaShutdown.containsMouse
                    
                    scale: mouseAreaShutdown.containsMouse ? 1.05 : 1.0
                    Behavior on scale { NumberAnimation { duration: 200 } }
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Item { Layout.fillWidth: true }

                // Indicator khi selected
                Rectangle {
                    Layout.preferredWidth: 4
                    Layout.preferredHeight: 20
                    radius: 2
                    color: theme.accent.color
                    visible: false // Sẽ được điều khiển bởi trạng thái selected
                    opacity: mouseAreaShutdown.containsMouse ? 1.0 : 0.8
                    
                    scale: false ? 1.0 : 0.0 // Thay false bằng điều kiện selected thực tế
                    Behavior on scale { 
                        NumberAnimation { 
                            duration: 300; 
                            easing.type: Easing.OutBack 
                        } 
                    }
                    Behavior on opacity { NumberAnimation { duration: 200 } }
                }
            }

            MouseArea {
                id: mouseAreaShutdown
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                
                onClicked: {
                    shutdownProcess.command = ["systemctl", "poweroff"]
                    shutdownProcess.startDetached()
                }
            }
        }

        Item { Layout.fillHeight: true }
    }
}

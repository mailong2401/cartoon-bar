import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io

Rectangle {
    id: root
    Layout.preferredWidth: currentSizes.launcherPanel?.sidebarWidth || 210
    Layout.fillHeight: true
    radius: currentSizes.launcherPanel?.sidebarItemRadius || currentSizes.radius?.normal || 12
    color: theme.primary.dim_background
    border.color: theme.normal.black
    border.width: 2

    property var theme : currentTheme
    property var lang : currentLanguage

    signal appLaunched()
    signal appSettings()

    signal confirmRequested(string action, string actionLabel)

    function showConfirmDialog(action, actionLabel) {
        // Emit signal để parent components xử lý
        confirmRequested(action, actionLabel)
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: currentSizes.launcherPanel?.sidebarMargins || 12
        spacing: currentSizes.launcherPanel?.sidebarItemSpacing || 10

        // Tiêu đề Menu
        Rectangle {
            id: launcherButton
            Layout.fillWidth: true
            Layout.preferredHeight: currentSizes.launcherPanel?.sidebarItemHeight || 60
            radius: currentSizes.launcherPanel?.sidebarItemRadius || currentSizes.radius?.small || 8
            color: mouseAreaLauncher.containsMouse ? theme.button.background_select : theme.button.background
            border.color: mouseAreaLauncher.containsPress ? theme.button.border_select : theme.button.border
            border.width: 3
            
            scale: mouseAreaLauncher.containsPress ? 0.98 : 1.0
            Behavior on scale { NumberAnimation { duration: 100 } }
            Behavior on color { ColorAnimation { duration: 200 } }
            Behavior on border.color { ColorAnimation { duration: 100 } }

            RowLayout {
                anchors.fill: parent
                anchors.margins: currentSizes.launcherPanel?.sidebarButtonMargins || 8
                
                Image {
                    source: "../../../assets/dashboard.png"
                    Layout.preferredHeight: currentSizes.launcherPanel?.sidebarIconSize || currentSizes.iconSize?.normal || 28
                    Layout.preferredWidth: currentSizes.launcherPanel?.sidebarIconSize || currentSizes.iconSize?.normal || 28
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    
                    rotation: mouseAreaLauncher.containsMouse ? 0 : 90
                    Behavior on rotation { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }
                }

                Text {
                    text: lang.system.application
                    color: mouseAreaLauncher.containsMouse ? theme.primary.bright_foreground : theme.primary.foreground
                    font.pixelSize: currentSizes.launcherPanel?.sidebarFontSize || currentSizes.fontSize?.medium || 16
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
                    root.appLaunched()
                }
            }
        }

        // Cài đặt
        Rectangle {
            id: settingsButton
            Layout.fillWidth: true
            Layout.preferredHeight: currentSizes.launcherPanel?.sidebarItemHeight || 60
            radius: currentSizes.launcherPanel?.sidebarItemRadius || currentSizes.radius?.small || 8
            color: mouseAreaSettings.containsMouse ? theme.button.background_select : theme.button.background
            border.color: mouseAreaSettings.containsPress ? theme.button.border_select : theme.button.border
            border.width: 3
            
            scale: mouseAreaSettings.containsPress ? 0.98 : 1.0
            Behavior on scale { NumberAnimation { duration: 100 } }
            Behavior on color { ColorAnimation { duration: 200 } }
            Behavior on border.color { ColorAnimation { duration: 100 } }

            RowLayout {
                anchors.fill: parent
                anchors.margins: currentSizes.launcherPanel?.sidebarButtonMargins || 8
                
                Image {
                    source: "../../../assets/system/setting.png"
                    Layout.preferredHeight: currentSizes.launcherPanel?.sidebarIconSize || currentSizes.iconSize?.normal || 28
                    Layout.preferredWidth: currentSizes.launcherPanel?.sidebarIconSize || currentSizes.iconSize?.normal || 28
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    
                    rotation: mouseAreaSettings.containsMouse ? 360 : 0
                    Behavior on rotation { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }
                }

                Text {
                    text: lang.settings.title
                    color: mouseAreaSettings.containsMouse ? theme.primary.bright_foreground : theme.primary.foreground
                    font.pixelSize: currentSizes.launcherPanel?.sidebarFontSize || currentSizes.fontSize?.medium || 16
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
                    color: theme.normal.blue
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
                    root.appSettings()
                }
            }
        }

        // Chế độ ngủ
        Rectangle {
            id: sleepButton
            Layout.fillWidth: true
            Layout.preferredHeight: currentSizes.launcherPanel?.sidebarItemHeight || 60
            radius: currentSizes.launcherPanel?.sidebarItemRadius || currentSizes.radius?.small || 8
            color: mouseAreaSleep.containsMouse ? theme.button.background_select : theme.button.background
            border.color: mouseAreaSleep.containsPress ? theme.button.border_select : theme.button.border
            border.width: 3
            
            scale: mouseAreaSleep.containsPress ? 0.98 : 1.0
            Behavior on scale { NumberAnimation { duration: 100 } }
            Behavior on color { ColorAnimation { duration: 200 } }
            Behavior on border.color { ColorAnimation { duration: 100 } }

            RowLayout {
                anchors.fill: parent
                anchors.margins: currentSizes.launcherPanel?.sidebarButtonMargins || 8
                
                Image {
                    source: "../../../assets/system/sys-sleep.png"
                    Layout.preferredHeight: currentSizes.launcherPanel?.sidebarIconSize || currentSizes.iconSize?.normal || 28
                    Layout.preferredWidth: currentSizes.launcherPanel?.sidebarIconSize || currentSizes.iconSize?.normal || 28
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    
                    rotation: mouseAreaSleep.containsMouse ? 5 : 0
                    Behavior on rotation { NumberAnimation { duration: 200 } }
                }

                Text {
                    text: lang.system.sleep
                    color: mouseAreaSleep.containsMouse ? theme.primary.bright_foreground : theme.primary.foreground
                    font.pixelSize: currentSizes.launcherPanel?.sidebarFontSize || currentSizes.fontSize?.medium || 16
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
                    color: theme.normal.blue
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
                    showConfirmDialog("sleep", lang?.confirm?.sleep || "chuyển sang chế độ ngủ")
                }
            }
        }

        // Khóa màn hình
        Rectangle {
            id: lockButton
            Layout.fillWidth: true
            Layout.preferredHeight: currentSizes.launcherPanel?.sidebarItemHeight || 60
            radius: currentSizes.launcherPanel?.sidebarItemRadius || currentSizes.radius?.small || 8
            color: mouseAreaLock.containsMouse ? theme.button.background_select : theme.button.background
            border.color: mouseAreaLock.containsPress ? theme.button.border_select : theme.button.border
            border.width: 3
            
            scale: mouseAreaLock.containsPress ? 0.98 : 1.0
            Behavior on scale { NumberAnimation { duration: 100 } }
            Behavior on color { ColorAnimation { duration: 200 } }
            Behavior on border.color { ColorAnimation { duration: 100 } }

            RowLayout {
                anchors.fill: parent
                anchors.margins: currentSizes.launcherPanel?.sidebarButtonMargins || 8
                
                Image {
                    source: "../../../assets/system/sys-lock.png"
                    Layout.preferredHeight: currentSizes.launcherPanel?.sidebarIconSize || currentSizes.iconSize?.normal || 28
                    Layout.preferredWidth: currentSizes.launcherPanel?.sidebarIconSize || currentSizes.iconSize?.normal || 28
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    
                    rotation: mouseAreaLock.containsMouse ? 5 : 0
                    Behavior on rotation { NumberAnimation { duration: 200 } }
                }

                Text {
                    text: lang.system.lock
                    color: mouseAreaLock.containsMouse ? theme.primary.bright_foreground : theme.primary.foreground
                    font.pixelSize: currentSizes.launcherPanel?.sidebarFontSize || currentSizes.fontSize?.medium || 16
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
                    color: theme.normal.blue
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
                    showConfirmDialog("lock", lang?.confirm?.lock || "khóa màn hình")
                }
            }
        }

        // Đăng xuất
        Rectangle {
            id: logoutButton
            Layout.fillWidth: true
            Layout.preferredHeight: currentSizes.launcherPanel?.sidebarItemHeight || 60
            radius: currentSizes.launcherPanel?.sidebarItemRadius || currentSizes.radius?.small || 8
            color: mouseAreaLogout.containsMouse ? theme.button.background_select : theme.button.background
            border.color: mouseAreaLogout.containsPress ? theme.button.border_select : theme.button.border
            border.width: 3
            
            scale: mouseAreaLogout.containsPress ? 0.98 : 1.0
            Behavior on scale { NumberAnimation { duration: 100 } }
            Behavior on color { ColorAnimation { duration: 200 } }
            Behavior on border.color { ColorAnimation { duration: 100 } }

            RowLayout {
                anchors.fill: parent
                anchors.margins: currentSizes.launcherPanel?.sidebarButtonMargins || 8
                
                Image {
                    source: "../../../assets/system/sys-exit.png"
                    Layout.preferredHeight: currentSizes.launcherPanel?.sidebarIconSize || currentSizes.iconSize?.normal || 28
                    Layout.preferredWidth: currentSizes.launcherPanel?.sidebarIconSize || currentSizes.iconSize?.normal || 28
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    
                    rotation: mouseAreaLogout.containsMouse ? -5 : 0
                    Behavior on rotation { NumberAnimation { duration: 200 } }
                }

                Text {
                    text: lang.system.logout
                    color: mouseAreaLogout.containsMouse ? theme.primary.bright_foreground : theme.primary.foreground
                    font.pixelSize: currentSizes.launcherPanel?.sidebarFontSize || currentSizes.fontSize?.medium || 16
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
                    color: theme.normal.blue
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
                    showConfirmDialog("logout", lang?.confirm?.logout || "đăng xuất")
                }
            }
        }

        // Khởi động lại
        Rectangle {
            id: restartButton
            Layout.fillWidth: true
            Layout.preferredHeight: currentSizes.launcherPanel?.sidebarItemHeight || 60
            radius: currentSizes.launcherPanel?.sidebarItemRadius || currentSizes.radius?.small || 8
            color: mouseAreaRestart.containsMouse ? theme.button.background_select : theme.button.background
            border.color: mouseAreaRestart.containsPress ? theme.button.border_select : theme.button.border
            border.width: 3
            
            scale: mouseAreaRestart.containsPress ? 0.98 : 1.0
            Behavior on scale { NumberAnimation { duration: 100 } }
            Behavior on color { ColorAnimation { duration: 200 } }
            Behavior on border.color { ColorAnimation { duration: 100 } }

            RowLayout {
                anchors.fill: parent
                anchors.margins: currentSizes.launcherPanel?.sidebarButtonMargins || 8
                
                Image {
                    source: "../../../assets/system/sys-reboot.png"
                    Layout.preferredHeight: currentSizes.launcherPanel?.sidebarIconSize || currentSizes.iconSize?.normal || 28
                    Layout.preferredWidth: currentSizes.launcherPanel?.sidebarIconSize || currentSizes.iconSize?.normal || 28
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    
                    rotation: mouseAreaRestart.containsMouse ? 180 : 0
                    Behavior on rotation { NumberAnimation { duration: 400; easing.type: Easing.InOutCubic } }
                }

                Text {
                    text: lang.system.restart
                    color: mouseAreaRestart.containsMouse ? theme.primary.bright_foreground : theme.primary.foreground
                    font.pixelSize: currentSizes.launcherPanel?.sidebarFontSize || currentSizes.fontSize?.medium || 16
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
                    color: theme.normal.blue
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
                    showConfirmDialog("restart", lang?.confirm?.restart || "khởi động lại")
                }
            }
        }

        // Tắt máy
        Rectangle {
            id: shutdownButton
            Layout.fillWidth: true
            Layout.preferredHeight: currentSizes.launcherPanel?.sidebarItemHeight || 60
            radius: currentSizes.launcherPanel?.sidebarItemRadius || currentSizes.radius?.small || 8
            color: mouseAreaShutdown.containsMouse ? theme.button.background_select : theme.button.background
            border.color: mouseAreaShutdown.containsPress ? theme.button.border_select : theme.button.border
            border.width: 3
            
            scale: mouseAreaShutdown.containsPress ? 0.98 : 1.0
            Behavior on scale { NumberAnimation { duration: 100 } }
            Behavior on color { ColorAnimation { duration: 200 } }
            Behavior on border.color { ColorAnimation { duration: 100 } }

            RowLayout {
                anchors.fill: parent
                anchors.margins: currentSizes.launcherPanel?.sidebarButtonMargins || 8
                
                Image {
                    source: "../../../assets/system/poweroff.png"
                    Layout.preferredHeight: currentSizes.launcherPanel?.sidebarIconSize || currentSizes.iconSize?.normal || 28
                    Layout.preferredWidth: currentSizes.launcherPanel?.sidebarIconSize || currentSizes.iconSize?.normal || 28
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    
                    scale: mouseAreaShutdown.containsMouse ? 1.1 : 1.0
                    Behavior on scale { NumberAnimation { duration: 200 } }
                }

                Text {
                    text: lang.system.shutdown
                    color: mouseAreaShutdown.containsMouse ? theme.primary.bright_foreground : theme.primary.foreground
                    font.pixelSize: currentSizes.launcherPanel?.sidebarFontSize || currentSizes.fontSize?.medium || 16
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
                    color: theme.normal.blue
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
                    showConfirmDialog("shutdown", lang?.confirm?.shutdown || "tắt máy")
                }
            }
        }

        Item { Layout.fillHeight: true }
    }
}
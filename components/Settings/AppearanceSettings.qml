// components/Settings/AppearanceSettings.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "."
import ".." as Components

Item {
    property var theme: currentTheme
    property var lang: currentLanguage
    property var panelConfig  // Received from parent SettingsPanel
    id: root

    // Hàm helper để set position
    function setClockPosition(position) {
        panelConfig.set("clockPanelPosition", position)
    }

    // Component cho position button
    Component {
        id: positionButton

        Rectangle {
            property string position: ""
            property var anchorConfig: ({})

            width: currentSizes.appearanceSettings?.positionButtonWidth || 60
            height: currentSizes.appearanceSettings?.positionButtonHeight || 60
            radius: currentSizes.appearanceSettings?.positionButtonRadius || currentSizes.radius?.normal || 12
            color: currentConfig.clockPanelPosition === position ? theme.normal.blue : (mouseArea.containsMouse ? theme.button.background_select : theme.button.background)
            border.color: currentConfig.clockPanelPosition === position ? theme.normal.blue : (mouseArea.containsPress ? theme.button.border_select : theme.button.border)
            border.width: 3

            Rectangle {
                width: currentSizes.appearanceSettings?.positionIndicatorWidth || 25
                height: currentSizes.appearanceSettings?.positionIndicatorHeight || 15
                radius: currentSizes.appearanceSettings?.positionIndicatorRadius || currentSizes.radius?.small || 6
                color: theme.primary.background

                anchors.top: anchorConfig.top ? parent.top : undefined
                anchors.bottom: anchorConfig.bottom ? parent.bottom : undefined
                anchors.left: anchorConfig.left ? parent.left : undefined
                anchors.right: anchorConfig.right ? parent.right : undefined
                anchors.horizontalCenter: anchorConfig.hCenter ? parent.horizontalCenter : undefined
                anchors.verticalCenter: anchorConfig.vCenter ? parent.verticalCenter : undefined

                anchors.topMargin: anchorConfig.top ? currentSizes.spacing?.normal : 0
                anchors.bottomMargin: anchorConfig.bottom ? currentSizes.spacing?.normal : 0
                anchors.leftMargin: anchorConfig.left ? currentSizes.spacing?.normal : 0
                anchors.rightMargin: anchorConfig.right ? currentSizes.spacing?.normal : 0
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.setClockPosition(parent.position)
            }
        }
    }

    ScrollView {
        anchors.fill: parent
        anchors.margins: currentSizes.appearanceSettings?.margin || 20
        clip: true

        ColumnLayout {
            width: parent.width
            spacing: currentSizes.appearanceSettings?.sectionSpacing || 20

            Text {
                text: lang.appearance?.title || "Giao diện"
                color: theme.primary.foreground
                font {
                    family: "ComicShannsMono Nerd Font"
                    pixelSize: currentSizes.appearanceSettings?.titleFontSize || currentSizes.fontSize?.xlarge || 24
                    bold: true
                }
                Layout.topMargin: currentSizes.spacing?.normal || 10
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: theme.primary.dim_foreground + "40"
            }

            // Theme Selection
            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: lang.appearance?.theme_label || "Chủ đề:"
                    color: theme.primary.foreground
                    font {
                        family: "ComicShannsMono Nerd Font"
                        pixelSize: currentSizes.fontSize?.medium || 16
                    }
                    Layout.preferredWidth: currentSizes.appearanceSettings?.themeSelectionpreferredWidth || 150
                }

                Row {
                    spacing: currentSizes.spacing?.large || 12

                    // Light Theme Card
                    Rectangle {
                        id: lightThemeCard
                        width: currentSizes.appearanceSettings?.themeCardWidth || 100
                        height: currentSizes.appearanceSettings?.themeCardHeight || 80
                        radius: currentSizes.radius?.normal || 12
                        color: "#f5eee6"
                        border.color: theme.type === "light" ? theme.normal.blue : theme.button.border
                        border.width: theme.type === "light" ? 3 : 2

                        Column {
                            anchors.centerIn: parent
                            spacing: 6

                            Rectangle {
                                width: currentSizes.panelWidth?.appIcons || 60
                                height: currentSizes.launcherPanel?.searchIconSize || 24
                                radius: currentSizes.radius?.small || 8
                                color: "#2b2530"
                            }

                            Rectangle {
                                width: currentSizes.panelWidth?.appIcons || 60
                                height: currentSizes.appearanceSettings?.rowSpacing || 10
                                radius: currentSizes.appearanceSettings.themeCardSelectedBorderWidth || 3
                                color: "#b0a89e"
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                themeLoader.changeTheme("light")
                                panelConfig.set("theme", "light")
                            }
                        }

                        Text {
                            text: lang.appearance?.theme_light || "Sáng"
                            color: "#2b2530"
                            font {
                                family: "ComicShannsMono Nerd Font"
                                pixelSize: 12
                                bold: true
                            }
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 8
                        }

                        // Checkmark for selected theme
                        Rectangle {
                            visible: theme.type === "light"
                            width: 20
                            height: 20
                            radius: 10
                            color: theme.normal.blue
                            anchors.top: parent.top
                            anchors.right: parent.right
                            anchors.margins: 5

                            Text {
                                text: "✓"
                                color: theme.primary.background
                                font.pixelSize: 12
                                font.bold: true
                                anchors.centerIn: parent
                            }
                        }
                    }

                    // Dark Theme Card
                    Rectangle {
                        id: darkThemeCard
                        width: currentSizes.appearanceSettings?.themeCardWidth || 100
                        height: currentSizes.appearanceSettings?.themeCardHeight || 80
                        radius: currentSizes.radius?.normal || 12
                        color: "#24273a"
                        border.color: theme.type === "dark" ? theme.normal.blue : theme.button.border
                        border.width: theme.type === "dark" ? 3 : 2

                        Column {
                            anchors.centerIn: parent
                            spacing: 6

                            Rectangle {
                                width: currentSizes.panelWidth?.appIcons || 60
                                height: currentSizes.launcherPanel?.searchIconSize || 24
                                radius: currentSizes.radius?.small || 8
                                color: "#cad3f5"
                            }

                            Rectangle {
                                width: currentSizes.panelWidth?.appIcons || 60
                                height: currentSizes.appearanceSettings?.rowSpacing || 10
                                radius: currentSizes.appearanceSettings.themeCardSelectedBorderWidth || 3
                                color: "#494d64"
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                themeLoader.changeTheme("dark")
                                panelConfig.set("theme", "dark")
                            }
                        }

                        Text {
                            text: lang.appearance?.theme_dark || "Tối"
                            color: "#cad3f5"
                            font {
                                family: "ComicShannsMono Nerd Font"
                                pixelSize: 12
                                bold: true
                            }
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 8
                        }

                        // Checkmark for selected theme
                        Rectangle {
                            visible: theme.type === "dark"
                            width: 20
                            height: 20
                            radius: 10
                            color: theme.normal.blue
                            anchors.top: parent.top
                            anchors.right: parent.right
                            anchors.margins: 5

                            Text {
                                text: "✓"
                                color: theme.primary.background
                                font.pixelSize: 12
                                font.bold: true
                                anchors.centerIn: parent
                            }
                        }
                    }
                }
            }

            // Panel Size Selection
            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 10

                Text {
                    text: lang.appearance?.panel_size_label || "Kích thước panel:"
                    color: theme.primary.foreground
                    font {
                        family: "ComicShannsMono Nerd Font"
                        pixelSize: currentSizes.fontSize?.medium || 16
                    }
                    Layout.preferredWidth: currentSizes.appearanceSettings?.themeSelectionpreferredWidth || 150
                }

                Column {
                    spacing: 10

                    // Row 1: 1280, 1366, 1440
                    Row {
                        spacing: 10

                        Rectangle {
                            width: currentSizes.appearanceSettings?.panelSizeButtonWidth || 90
                            height: currentSizes.appearanceSettings?.panelSizeButtonHeight || 50
                            radius: currentSizes.appearanceSettings?.panelSizeButtonRadius || 8
                            color: mouseArea1280.containsMouse ? theme.button.background_select : theme.button.background
                            border.color: mouseArea1280.containsPress ? theme.button.border_select : theme.button.border
                            border.width: 2

                            Column {
                                anchors.centerIn: parent
                                spacing: 2

                                Text {
                                    text: "1280"
                                    color: theme.primary.foreground
                                    font {
                                        family: "ComicShannsMono Nerd Font"
                                        pixelSize: currentSizes.fontSize?.medium || 16
                                        bold: true
                                    }
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "HD"
                                    color: theme.primary.foreground
                                    font {
                                        family: "ComicShannsMono Nerd Font"
                                        pixelSize: currentSizes.fontSize?.small || 12
                                    }
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }

                            MouseArea {
                                id: mouseArea1280
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    sizesLoader.changeSizeProfile("1280")
                                }
                            }
                        }

                        Rectangle {
                            width: currentSizes.appearanceSettings?.panelSizeButtonWidth || 90
                            height: currentSizes.appearanceSettings?.panelSizeButtonHeight || 50
                            radius: currentSizes.appearanceSettings?.panelSizeButtonRadius || 8
                            color: mouseArea1366.containsMouse ? theme.button.background_select : theme.button.background
                            border.color: mouseArea1366.containsPress ? theme.button.border_select : theme.button.border
                            border.width: 2

                            Column {
                                anchors.centerIn: parent
                                spacing: 2

                                Text {
                                    text: "1366"
                                    color: theme.primary.foreground
                                    font {
                                        family: "ComicShannsMono Nerd Font"
                                        pixelSize: currentSizes.fontSize?.medium || 16
                                        bold: true
                                    }
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "HD (WXGA)"
                                    color: theme.primary.foreground
                                    font {
                                        family: "ComicShannsMono Nerd Font"
                                        pixelSize: currentSizes.fontSize?.small || 12
                                    }
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }

                            MouseArea {
                                id: mouseArea1366
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    sizesLoader.changeSizeProfile("1366")
                                }
                            }
                        }

                        Rectangle {
                            width: currentSizes.appearanceSettings?.panelSizeButtonWidth || 90
                            height: currentSizes.appearanceSettings?.panelSizeButtonHeight || 50
                            radius: currentSizes.appearanceSettings?.panelSizeButtonRadius || 8
                            color: mouseArea1440.containsMouse ? theme.button.background_select : theme.button.background
                            border.color: mouseArea1440.containsPress ? theme.button.border_select : theme.button.border
                            border.width: 2

                            Column {
                                anchors.centerIn: parent
                                spacing: 2

                                Text {
                                    text: "1440"
                                    color: theme.primary.foreground
                                    font {
                                        family: "ComicShannsMono Nerd Font"
                                        pixelSize: currentSizes.fontSize?.medium || 16
                                        bold: true
                                    }
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "HD+ (WXGA+)"
                                    color: theme.primary.foreground
                                    font {
                                        family: "ComicShannsMono Nerd Font"
                                        pixelSize: currentSizes.fontSize?.small || 12
                                    }
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }

                            MouseArea {
                                id: mouseArea1440
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    sizesLoader.changeSizeProfile("1440")
                                }
                            }
                        }
                    }

                    // Row 2: 1600, 1680, 1920
                    Row {
                        spacing: 10

                        Rectangle {
                            width: currentSizes.appearanceSettings?.panelSizeButtonWidth || 90
                            height: currentSizes.appearanceSettings?.panelSizeButtonHeight || 50
                            radius: currentSizes.appearanceSettings?.panelSizeButtonRadius || 8
                            color: mouseArea1600.containsMouse ? theme.button.background_select : theme.button.background
                            border.color: mouseArea1600.containsPress ? theme.button.border_select : theme.button.border
                            border.width: 2

                            Column {
                                anchors.centerIn: parent
                                spacing: 2

                                Text {
                                    text: "1600"
                                    color: theme.primary.foreground
                                    font {
                                        family: "ComicShannsMono Nerd Font"
                                        pixelSize: currentSizes.fontSize?.medium || 16
                                        bold: true
                                    }
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "HD+"
                                    color: theme.primary.foreground
                                    font {
                                        family: "ComicShannsMono Nerd Font"
                                        pixelSize: currentSizes.fontSize?.small || 12
                                    }
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }

                            MouseArea {
                                id: mouseArea1600
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    sizesLoader.changeSizeProfile("1600")
                                }
                            }
                        }

                        Rectangle {
                            width: currentSizes.appearanceSettings?.panelSizeButtonWidth || 90
                            height: currentSizes.appearanceSettings?.panelSizeButtonHeight || 50
                            radius: currentSizes.appearanceSettings?.panelSizeButtonRadius || 8
                            color: mouseArea1680.containsMouse ? theme.button.background_select : theme.button.background
                            border.color: mouseArea1680.containsPress ? theme.button.border_select : theme.button.border
                            border.width: 2

                            Column {
                                anchors.centerIn: parent
                                spacing: 2

                                Text {
                                    text: "1680"
                                    color: theme.primary.foreground
                                    font {
                                        family: "ComicShannsMono Nerd Font"
                                        pixelSize: currentSizes.fontSize?.medium || 16
                                        bold: true
                                    }
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "WSXGA+"
                                    color: theme.primary.foreground
                                    font {
                                        family: "ComicShannsMono Nerd Font"
                                        pixelSize: currentSizes.fontSize?.small || 12
                                    }
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }

                            MouseArea {
                                id: mouseArea1680
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    sizesLoader.changeSizeProfile("1680")
                                }
                            }
                        }

                        Rectangle {
                            width: currentSizes.appearanceSettings?.panelSizeButtonWidth || 90
                            height: currentSizes.appearanceSettings?.panelSizeButtonHeight || 50
                            radius: currentSizes.appearanceSettings?.panelSizeButtonRadius || 8
                            color: mouseArea1920.containsMouse ? theme.button.background_select : theme.button.background
                            border.color: mouseArea1920.containsPress ? theme.button.border_select : theme.button.border
                            border.width: 2

                            Column {
                                anchors.centerIn: parent
                                spacing: 2

                                Text {
                                    text: "1920"
                                    color: theme.primary.foreground
                                    font {
                                        family: "ComicShannsMono Nerd Font"
                                        pixelSize: currentSizes.fontSize?.medium || 16
                                        bold: true
                                    }
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "Full HD"
                                    color: theme.primary.foreground
                                    font {
                                        family: "ComicShannsMono Nerd Font"
                                        pixelSize: currentSizes.fontSize?.small || 12
                                    }
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }

                            MouseArea {
                                id: mouseArea1920
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    sizesLoader.changeSizeProfile("1920")
                                }
                            }
                        }
                    }

                    // Row 3: 2560, 2880, 3440
                    Row {
                        spacing: 10

                        Rectangle {
                            width: currentSizes.appearanceSettings?.panelSizeButtonWidth || 90
                            height: currentSizes.appearanceSettings?.panelSizeButtonHeight || 50
                            radius: currentSizes.appearanceSettings?.panelSizeButtonRadius || 8
                            color: mouseArea2560.containsMouse ? theme.button.background_select : theme.button.background
                            border.color: mouseArea2560.containsPress ? theme.button.border_select : theme.button.border
                            border.width: 2

                            Column {
                                anchors.centerIn: parent
                                spacing: 2

                                Text {
                                    text: "2560"
                                    color: theme.primary.foreground
                                    font {
                                        family: "ComicShannsMono Nerd Font"
                                        pixelSize: currentSizes.fontSize?.medium || 16
                                        bold: true
                                    }
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "2K / QHD"
                                    color: theme.primary.foreground
                                    font {
                                        family: "ComicShannsMono Nerd Font"
                                        pixelSize: currentSizes.fontSize?.small || 12
                                    }
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }

                            MouseArea {
                                id: mouseArea2560
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    // Logic sẽ thêm sau
                                }
                            }
                        }

                        Rectangle {
                            width: currentSizes.appearanceSettings?.panelSizeButtonWidth || 90
                            height: currentSizes.appearanceSettings?.panelSizeButtonHeight || 50
                            radius: currentSizes.appearanceSettings?.panelSizeButtonRadius || 8
                            color: mouseArea2880.containsMouse ? theme.button.background_select : theme.button.background
                            border.color: mouseArea2880.containsPress ? theme.button.border_select : theme.button.border
                            border.width: 2

                            Column {
                                anchors.centerIn: parent
                                spacing: 2

                                Text {
                                    text: "2880"
                                    color: theme.primary.foreground
                                    font {
                                        family: "ComicShannsMono Nerd Font"
                                        pixelSize: currentSizes.fontSize?.medium || 16
                                        bold: true
                                    }
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "3K"
                                    color: theme.primary.foreground
                                    font {
                                        family: "ComicShannsMono Nerd Font"
                                        pixelSize: currentSizes.fontSize?.small || 12
                                    }
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }

                            MouseArea {
                                id: mouseArea2880
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    // Logic sẽ thêm sau
                                }
                            }
                        }

                        Rectangle {
                            width: currentSizes.appearanceSettings?.panelSizeButtonWidth || 90
                            height: currentSizes.appearanceSettings?.panelSizeButtonHeight || 50
                            radius: currentSizes.appearanceSettings?.panelSizeButtonRadius || 8
                            color: mouseArea3440.containsMouse ? theme.button.background_select : theme.button.background
                            border.color: mouseArea3440.containsPress ? theme.button.border_select : theme.button.border
                            border.width: 2

                            Column {
                                anchors.centerIn: parent
                                spacing: 2

                                Text {
                                    text: "3440"
                                    color: theme.primary.foreground
                                    font {
                                        family: "ComicShannsMono Nerd Font"
                                        pixelSize: currentSizes.fontSize?.medium || 16
                                        bold: true
                                    }
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "UW-QHD"
                                    color: theme.primary.foreground
                                    font {
                                        family: "ComicShannsMono Nerd Font"
                                        pixelSize: currentSizes.fontSize?.small || 12
                                    }
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }

                            MouseArea {
                                id: mouseArea3440
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    // Logic sẽ thêm sau
                                }
                            }
                        }
                    }

                    // Row 4: 3840
                    Row {
                        spacing: 10

                        Rectangle {
                            width: currentSizes.appearanceSettings?.panelSizeButtonWidth || 90
                            height: currentSizes.appearanceSettings?.panelSizeButtonHeight || 50
                            radius: currentSizes.appearanceSettings?.panelSizeButtonRadius || 8
                            color: mouseArea3840.containsMouse ? theme.button.background_select : theme.button.background
                            border.color: mouseArea3840.containsPress ? theme.button.border_select : theme.button.border
                            border.width: 2

                            Column {
                                anchors.centerIn: parent
                                spacing: 2

                                Text {
                                    text: "3840"
                                    color: theme.primary.foreground
                                    font {
                                        family: "ComicShannsMono Nerd Font"
                                        pixelSize: currentSizes.fontSize?.medium || 16
                                        bold: true
                                    }
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "4K / UHD"
                                    color: theme.primary.foreground 
                                    font {
                                        family: "ComicShannsMono Nerd Font"
                                        pixelSize: currentSizes.fontSize?.small || 12
                                    }
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }

                            MouseArea {
                                id: mouseArea3840
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    // Logic sẽ thêm sau
                                }
                            }
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Text {
                    text: lang.appearance?.clock_panel_label || "Bảng đồng hồ:"
                    color: theme.primary.foreground
                    font.family: "ComicShannsMono Nerd Font"
                    font.pixelSize: currentSizes.fontSize?.medium || 16
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                }

                Item { Layout.fillWidth: true }

                Switch {
                    id: autoStartSwitch
                    checked: currentConfig.clockPanelVisible || false
                    onToggled: {
                        panelConfig.set("clockPanelVisible", checked)
                        Qt.callLater(function() {
                            configLoader.loadConfig()
                        })
                    }
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignRight

                    background: Rectangle {
                        implicitWidth: currentSizes.appearanceSettings?.switchWidth || 48
                        implicitHeight: currentSizes.appearanceSettings?.switchHeight || 28
                        radius: currentSizes.appearanceSettings?.switchRadius || 14
                        color: autoStartSwitch.checked ? theme.normal.blue : theme.button.background
                        border.color: autoStartSwitch.checked ? theme.normal.blue : theme.button.border
                        border.width: 2
                    }

                    indicator: Rectangle {
                        x: autoStartSwitch.checked ? parent.background.width - width - 4 : 4
                        y: (parent.background.height - height) / 2
                        width: currentSizes.appearanceSettings?.switchIndicatorSize || 20
                        height: currentSizes.appearanceSettings?.switchIndicatorSize || 20
                        radius: currentSizes.appearanceSettings?.switchIndicatorSize / 2 || 10
                        color: theme.primary.background

                        Behavior on x {
                            NumberAnimation { duration: 150 }
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: lang.appearance?.panel_position_label || "Vị trí panel:"
                    color: theme.primary.foreground
                    font {
                        family: "ComicShannsMono Nerd Font"
                        pixelSize: currentSizes.fontSize?.medium || 16
                    }
                    Layout.preferredWidth: currentSizes.appearanceSettings?.themeSelectionpreferredWidth || 150
                }

                Row {
                    spacing: 15

                    Rectangle {
                        width: currentSizes.appearanceSettings?.themeCardHeight || 80
                        height: currentSizes.launcherPanel?.itemIconSize || 40
                        radius: currentSizes.radius?.small || 8
                        color: currentConfig.mainPanelPos === "top" ? theme.normal.blue : (mouseAreaTop.containsMouse ? theme.button.background_select : theme.button.background)
                        border.color: currentConfig.mainPanelPos === "top" ? theme.normal.blue : (mouseAreaTop.containsPress ? theme.button.border_select : theme.button.border)
                        border.width: 2

                        Text {
                            text: lang.appearance?.position_top || "Trên"
                            color: currentConfig.mainPanelPos === "top" ? theme.primary.background : theme.primary.foreground
                            font {
                                family: "ComicShannsMono Nerd Font"
                                pixelSize: currentSizes.fontSize?.normal || 14
                                bold: currentConfig.mainPanelPos === "top"
                            }
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            id: mouseAreaTop
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                panelConfig.set("mainPanelPos", "top")
                            }
                        }
                    }

                    Rectangle {
                        width: currentSizes.appearanceSettings?.themeCardHeight || 80
                        height: currentSizes.launcherPanel?.itemIconSize || 40
                        radius: currentSizes.radius?.small || 8
                        color: currentConfig.mainPanelPos === "bottom" ? theme.normal.blue : (mouseAreaBottom.containsMouse ? theme.button.background_select : theme.button.background)
                        border.color: currentConfig.mainPanelPos === "bottom" ? theme.normal.blue : (mouseAreaBottom.containsPress ? theme.button.border_select : theme.button.border)
                        border.width: 2

                        Text {
                            text: lang.appearance?.position_bottom || "Dưới"
                            color: currentConfig.mainPanelPos === "bottom" ? theme.primary.background : theme.primary.foreground
                            font {
                                family: "ComicShannsMono Nerd Font"
                                pixelSize: currentSizes.fontSize?.normal || 14
                                bold: currentConfig.mainPanelPos === "bottom"
                            }
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            id: mouseAreaBottom
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                panelConfig.set("mainPanelPos", "bottom")
                            }
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: lang.appearance?.clock_position_label || "Vị trí đồng hồ:"
                    color: theme.primary.foreground
                    font {
                        family: "ComicShannsMono Nerd Font"
                        pixelSize: currentSizes.fontSize?.medium || 16
                    }
                    Layout.preferredWidth: currentSizes.appearanceSettings?.themeSelectionpreferredWidth || 150
                }

                Column {
                    spacing: 15

                    Row {
                        spacing: 15

                        Loader {
                            sourceComponent: positionButton
                            onLoaded: {
                                item.position = "topLeft"
                                item.anchorConfig = { top: true, left: true }
                            }
                        }

                        Loader {
                            sourceComponent: positionButton
                            onLoaded: {
                                item.position = "top"
                                item.anchorConfig = { top: true, hCenter: true }
                            }
                        }

                        Loader {
                            sourceComponent: positionButton
                            onLoaded: {
                                item.position = "topRight"
                                item.anchorConfig = { top: true, right: true }
                            }
                        }
                    }

                    Row {
                        spacing: 15

                        Loader {
                            sourceComponent: positionButton
                            onLoaded: {
                                item.position = "left"
                                item.anchorConfig = { left: true, vCenter: true }
                            }
                        }

                        Loader {
                            sourceComponent: positionButton
                            onLoaded: {
                                item.position = "center"
                                item.anchorConfig = { hCenter: true, vCenter: true }
                            }
                        }

                        Loader {
                            sourceComponent: positionButton
                            onLoaded: {
                                item.position = "right"
                                item.anchorConfig = { right: true, vCenter: true }
                            }
                        }
                    }

                    Row {
                        spacing: 15

                        Loader {
                            sourceComponent: positionButton
                            onLoaded: {
                                item.position = "bottomLeft"
                                item.anchorConfig = { bottom: true, left: true }
                            }
                        }

                        Loader {
                            sourceComponent: positionButton
                            onLoaded: {
                                item.position = "bottom"
                                item.anchorConfig = { bottom: true, hCenter: true }
                            }
                        }

                        Loader {
                            sourceComponent: positionButton
                            onLoaded: {
                                item.position = "bottomRight"
                                item.anchorConfig = { bottom: true, right: true }
                            }
                        }
                    }
                }
            }

            Item { Layout.fillHeight: true }
        }
    }

    Component.onCompleted: {
        console.log("AppearanceSettings loaded with profile:", currentConfigProfile)
    }
}

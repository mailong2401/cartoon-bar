// components/Settings/AppearanceSettings.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "."
import ".." as Components

Item {
    property var theme: currentTheme
    property var lang: currentLanguage
    id: root

    // Hàm helper để set position
    function setClockPosition(position) {
        panelConfig.set("clockPanelPosition", position)
    }

    // Tạo JsonEditor riêng cho panel settings
    Components.JsonEditor {
        id: panelConfig
        filePath: Qt.resolvedUrl("../../themes/sizes/" + currentSizeProfile + ".json")
        Component.onCompleted: {
            panelConfig.load(panelConfig.filePath)
        }
    }

    // Component cho position button
    Component {
        id: positionButton

        Rectangle {
            property string position: ""
            property var anchorConfig: ({})

            width: 60
            height: 60
            radius: 12
            color: currentSizes.clockPanelPosition === position ? theme.normal.blue : (mouseArea.containsMouse ? theme.button.background_select : theme.button.background)
            border.color: currentSizes.clockPanelPosition === position ? theme.normal.blue : (mouseArea.containsPress ? theme.button.border_select : theme.button.border)
            border.width: 3

            Rectangle {
                width: 25
                height: 15
                radius: 6
                color: theme.primary.background

                anchors.top: anchorConfig.top ? parent.top : undefined
                anchors.bottom: anchorConfig.bottom ? parent.bottom : undefined
                anchors.left: anchorConfig.left ? parent.left : undefined
                anchors.right: anchorConfig.right ? parent.right : undefined
                anchors.horizontalCenter: anchorConfig.hCenter ? parent.horizontalCenter : undefined
                anchors.verticalCenter: anchorConfig.vCenter ? parent.verticalCenter : undefined

                anchors.topMargin: anchorConfig.top ? 10 : 0
                anchors.bottomMargin: anchorConfig.bottom ? 10 : 0
                anchors.leftMargin: anchorConfig.left ? 10 : 0
                anchors.rightMargin: anchorConfig.right ? 10 : 0
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
        anchors.margins: 20
        clip: true

        ColumnLayout {
            width: parent.width
            spacing: 20

            Text {
                text: lang.appearance?.title || "Giao diện"
                color: theme.primary.foreground
                font {
                    family: "ComicShannsMono Nerd Font"
                    pixelSize: 24
                    bold: true
                }
                Layout.topMargin: 10
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
                        pixelSize: 16
                    }
                    Layout.preferredWidth: 150
                }

                Row {
                    spacing: 15

                    // Light Theme Card
                    Rectangle {
                        id: lightThemeCard
                        width: 100
                        height: 80
                        radius: 12
                        color: "#f5eee6"
                        border.color: theme.type === "light" ? theme.normal.blue : theme.button.border
                        border.width: theme.type === "light" ? 3 : 2

                        Column {
                            anchors.centerIn: parent
                            spacing: 6

                            Rectangle {
                                width: 60
                                height: 24
                                radius: 6
                                color: "#2b2530"
                            }

                            Rectangle {
                                width: 60
                                height: 10
                                radius: 3
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
                        width: 100
                        height: 80
                        radius: 12
                        color: "#24273a"
                        border.color: theme.type === "dark" ? theme.normal.blue : theme.button.border
                        border.width: theme.type === "dark" ? 3 : 2

                        Column {
                            anchors.centerIn: parent
                            spacing: 6

                            Rectangle {
                                width: 60
                                height: 24
                                radius: 6
                                color: "#cad3f5"
                            }

                            Rectangle {
                                width: 60
                                height: 10
                                radius: 3
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

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Text {
                    text: lang.appearance?.clock_panel_label || "Bảng đồng hồ:"
                    color: theme.primary.foreground
                    font.family: "ComicShannsMono Nerd Font"
                    font.pixelSize: 18
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                }

                Item { Layout.fillWidth: true }

                Switch {
                    id: autoStartSwitch
                    checked: currentSizes.clockPanelVisible || false
                    onToggled: {
                        panelConfig.set("clockPanelVisible", checked)
                        Qt.callLater(function() {
                            sizeLoader.loadSizes()
                        })
                    }
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignRight

                    background: Rectangle {
                        implicitWidth: 48
                        implicitHeight: 28
                        radius: 14
                        color: autoStartSwitch.checked ? theme.normal.blue : theme.button.background
                        border.color: autoStartSwitch.checked ? theme.normal.blue : theme.button.border
                        border.width: 2
                    }

                    indicator: Rectangle {
                        x: autoStartSwitch.checked ? parent.background.width - width - 4 : 4
                        y: (parent.background.height - height) / 2
                        width: 20
                        height: 20
                        radius: 10
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
                        pixelSize: 16
                    }
                    Layout.preferredWidth: 150
                }

                Row {
                    spacing: 15

                    Rectangle {
                        width: 80
                        height: 40
                        radius: 8
                        color: currentSizes.mainPanelPos === "top" ? theme.normal.blue : (mouseAreaTop.containsMouse ? theme.button.background_select : theme.button.background)
                        border.color: currentSizes.mainPanelPos === "top" ? theme.normal.blue : (mouseAreaTop.containsPress ? theme.button.border_select : theme.button.border)
                        border.width: 2

                        Text {
                            text: lang.appearance?.position_top || "Trên"
                            color: currentSizes.mainPanelPos === "top" ? theme.primary.background : theme.primary.foreground
                            font {
                                family: "ComicShannsMono Nerd Font"
                                pixelSize: 14
                                bold: currentSizes.mainPanelPos === "top"
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
                        width: 80
                        height: 40
                        radius: 8
                        color: currentSizes.mainPanelPos === "bottom" ? theme.normal.blue : (mouseAreaBottom.containsMouse ? theme.button.background_select : theme.button.background)
                        border.color: currentSizes.mainPanelPos === "bottom" ? theme.normal.blue : (mouseAreaBottom.containsPress ? theme.button.border_select : theme.button.border)
                        border.width: 2

                        Text {
                            text: lang.appearance?.position_bottom || "Dưới"
                            color: currentSizes.mainPanelPos === "bottom" ? theme.primary.background : theme.primary.foreground
                            font {
                                family: "ComicShannsMono Nerd Font"
                                pixelSize: 14
                                bold: currentSizes.mainPanelPos === "bottom"
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
                        pixelSize: 16
                    }
                    Layout.preferredWidth: 150
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

            RowLayout {
                Layout.fillWidth: true
                spacing: 15

                Text {
                    text: lang.appearance?.panel_height_label || "Chiều cao panel:"
                    color: theme.primary.foreground
                    font {
                        family: "ComicShannsMono Nerd Font"
                        pixelSize: 16
                    }
                    Layout.preferredWidth: 150
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 5

                    Slider {
                        id: opacitySlider
                        Layout.fillWidth: true
                        value: 0.5
                        from: 0
                        to: 1.0

                        property bool isInitialized: false

                        Component.onCompleted: {
                            Qt.callLater(function() {
                                if (panelConfig && panelConfig.json && panelConfig.json.width_panel !== undefined) {
                                    value = panelConfig.json.width_panel / 100
                                }
                                isInitialized = true
                            })
                        }

                        onValueChanged: {
                            if (!isInitialized) return

                            var newValue = Math.round(value * 100)
                            if (panelConfig && panelConfig.json) {
                                panelConfig.set("width_panel", newValue)
                            }
                        }

                        background: Rectangle {
                            x: opacitySlider.leftPadding
                            y: opacitySlider.topPadding + opacitySlider.availableHeight / 2 - height / 2
                            implicitWidth: 200
                            implicitHeight: 6
                            width: opacitySlider.availableWidth
                            height: implicitHeight
                            radius: 3
                            color: theme.button.background

                            Rectangle {
                                width: opacitySlider.visualPosition * parent.width
                                height: parent.height
                                color: theme.normal.blue
                                radius: 3
                            }
                        }

                        handle: Rectangle {
                            x: opacitySlider.leftPadding + opacitySlider.visualPosition * (opacitySlider.availableWidth - width)
                            y: opacitySlider.topPadding + opacitySlider.availableHeight / 2 - height / 2
                            implicitWidth: 22
                            implicitHeight: 22
                            radius: 11
                            color: opacitySlider.pressed ? theme.normal.blue : theme.primary.background
                            border.color: theme.normal.blue
                            border.width: 3

                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                        }
                    }

                    Text {
                        text: Math.round(opacitySlider.value * 100) + "%"
                        color: theme.primary.dim_foreground
                        font {
                            family: "ComicShannsMono Nerd Font"
                            pixelSize: 14
                        }
                        Layout.alignment: Qt.AlignRight
                    }
                }
            }

            Item { Layout.fillHeight: true }
        }
    }

    Component.onCompleted: {
        console.log("AppearanceSettings loaded with profile:", currentSizeProfile)
    }
}

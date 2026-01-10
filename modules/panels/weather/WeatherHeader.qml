import QtQuick
import QtQuick.Layouts

Rectangle {
    id: headerCard

    required property var theme
    required property var sizes
    required property bool isLoading

    signal refreshClicked()

    Layout.fillWidth: true
    height: sizes.headerHeight || 70
    radius: sizes.headerRadius || 16

    gradient: Gradient {
        GradientStop { position: 0.0; color: Qt.rgba(theme.normal.blue.r, theme.normal.blue.g, theme.normal.blue.b, 0.15) }
        GradientStop { position: 1.0; color: Qt.rgba(theme.normal.blue.r, theme.normal.blue.g, theme.normal.blue.b, 0.05) }
    }
    border.color: Qt.rgba(theme.normal.blue.r, theme.normal.blue.g, theme.normal.blue.b, 0.3)
    border.width: 1

    RowLayout {
        anchors.fill: parent
        anchors.margins: sizes.headerMargins || 16
        spacing: sizes.headerSpacing || 16

        Text {
            text: "🌤️"
            font.pixelSize: sizes.headerIconSize || 32
        }

        Text {
            text: "Thời Tiết"
            color: theme.primary.foreground
            font {
                pixelSize: sizes.headerTitleFontSize || 28
                bold: true
                family: "ComicShannsMono Nerd Font"
            }
            Layout.fillWidth: true
        }

        // Refresh button với hiệu ứng hover
        Rectangle {
            width: sizes.refreshButtonSize || 44
            height: sizes.refreshButtonSize || 44
            radius: sizes.refreshButtonRadius || 10
            color: refreshMouseArea.containsMouse ?
                   Qt.lighter(theme.normal.blue, 1.2) :
                   Qt.rgba(theme.normal.blue.r, theme.normal.blue.g, theme.normal.blue.b, 0.2)
            border.color: theme.normal.blue
            border.width: 2

            Text {
                text: isLoading ? "⏳" : "🔄"
                font.pixelSize: sizes.refreshIconSize || 20
                anchors.centerIn: parent
                color: theme.primary.foreground
            }

            MouseArea {
                id: refreshMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: refreshClicked()
            }
        }
    }
}

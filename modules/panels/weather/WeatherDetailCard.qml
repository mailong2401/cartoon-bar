import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    required property var sizes

    property string icon: "💧"
    property string value: "Value"

    radius: sizes.weatherPanel?.detailCardRadius || 12
    color: Qt.rgba(theme.normal.black.r, theme.normal.black.g, theme.normal.black.b, 0.05)
    border.color: Qt.rgba(theme.normal.black.r, theme.normal.black.g, theme.normal.black.b, 0.1)
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: sizes.weatherPanel?.detailCardMargins || 15
        spacing: sizes.weatherPanel?.detailCardSpacing || 10

        Text {
            text: root.icon
            font.pixelSize: sizes.weatherPanel?.detailCardIconSize || 32
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: root.value
            color: theme.primary.foreground
            font {
                pixelSize: sizes.weatherPanel?.detailCardValueFontSize || 16
                bold: true
                family: "ComicShannsMono Nerd Font"
            }
            Layout.alignment: Qt.AlignHCenter
        }
    }
}

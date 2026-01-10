import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property var theme: currentTheme
    property var sizes: currentSizes.weatherPanel || {}

    property string image: ""
    property string value: "Value"

    radius: sizes.detailCardRadius || 12
    color: Qt.rgba(theme.normal.black.r, theme.normal.black.g, theme.normal.black.b, 0.05)
    border.color: Qt.rgba(theme.normal.black.r, theme.normal.black.g, theme.normal.black.b, 0.1)
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: sizes.detailCardMargins || 15
        spacing: sizes.detailCardSpacing || 10

        // Thay Text bằng Image
        Image {
            source: root.image
            sourceSize.width: sizes.detailCardIconSize || 32
            sourceSize.height: sizes.detailCardIconSize || 32
            fillMode: Image.PreserveAspectFit
            Layout.preferredWidth: sizes.detailCardIconSize || 32
            Layout.preferredHeight: sizes.detailCardIconSize || 32
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: root.value
            color: theme.primary.foreground
            font {
                pixelSize: sizes.detailCardValueFontSize || 16
                bold: true
                family: "ComicShannsMono Nerd Font"
            }
            Layout.alignment: Qt.AlignHCenter
        }
    }
}

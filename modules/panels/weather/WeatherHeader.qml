import QtQuick
import QtQuick.Layouts

Item {
    id: headerCard

    property var sizes: currentSizes || {}
    property var theme: currentTheme
    property var lang: currentLanguage

    Layout.fillWidth: true
    height: sizes.headerHeight || 70

    Text {
        text: lang?.weather?.title || "Thời Tiết"
        color: theme.primary.foreground
        font {
            pixelSize: sizes.header?.fontSize || 40
            bold: true
            family: "ComicShannsMono Nerd Font"
        }
        anchors.centerIn: parent
    }
}

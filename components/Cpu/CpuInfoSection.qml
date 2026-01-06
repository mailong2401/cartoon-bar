import QtQuick

Column {
    property var theme: currentTheme
    property var sizes: currentSizes.cpuDetailPanel

    spacing: sizes.infoSpacing || 6

    Text {
        width: parent.width
        color: theme.primary.foreground
        text: "Tên: 12th Gen Intel(R) Core(TM) i5-12450HX"
        font.pixelSize: sizes.infoFontSize || 18
        font.family: "ComicShannsMono Nerd Font"
    }

    Text {
        width: parent.width
        color: theme.primary.foreground
        text: "Nhà cung cấp: GenuineIntel"
        font.pixelSize: sizes.infoFontSize || 18
        font.family: "ComicShannsMono Nerd Font"
    }

    Text {
        width: parent.width
        color: theme.primary.foreground
        text: "Kiến trúc: x86_64"
        font.pixelSize: sizes.infoFontSize || 18
        font.family: "ComicShannsMono Nerd Font"
    }

    Text {
        width: parent.width
        color: theme.primary.foreground
        text: "Số socket: 1"
        font.pixelSize: sizes.infoFontSize || 18
        font.family: "ComicShannsMono Nerd Font"
    }
}

import QtQuick

Column {
    spacing: 6

    property var theme : currentTheme


    Text {
        width: parent.width
        color: theme.primary.foreground
        text: "Tên: 12th Gen Intel(R) Core(TM) i5-12450HX"
        font.pixelSize: 18
        font.family: "ComicShannsMono Nerd Font"
    }
    
    Text {
        width: parent.width
        color: theme.primary.foreground
        text: "Nhà cung cấp: GenuineIntel"
        font.pixelSize: 18
        font.family: "ComicShannsMono Nerd Font"
    }
    
    Text {
        width: parent.width
        color: theme.primary.foreground
        text: "Kiến trúc: x86_64"
        font.pixelSize: 18
        font.family: "ComicShannsMono Nerd Font"
    }
    
    Text {
        width: parent.width
        color: theme.primary.foreground
        text: "Số socket: 1"
        font.pixelSize: 18
        font.family: "ComicShannsMono Nerd Font"
    }
}

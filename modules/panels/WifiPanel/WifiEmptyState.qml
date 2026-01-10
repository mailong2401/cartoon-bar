import QtQuick
import QtQuick.Layouts

Rectangle {
    id: emptyState
    property var sizes
    property var theme
    property var lang
    
    color: "transparent"
    
    Column {
        anchors.centerIn: parent
        spacing: 16
        
        Rectangle {
            width: sizes.emptyStateIconSize || 80
            height: sizes.emptyStateIconSize || 80
            radius: sizes.emptyStateIconRadius || 16
            color: theme.normal.red
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                text: "📶"
                font.pixelSize: 40
                anchors.centerIn: parent
            }
        }
        
        Text {
            text: lang?.wifi?.disabled || "WiFi đang tắt"
            font.pixelSize: sizes.emptyStateTitleFontSize || 18
            color: theme.primary.foreground
            font.family: "ComicShannsMono Nerd Font"
        }
        
        Text {
            text: lang?.wifi?.turn_on || "Bật WiFi để xem mạng khả dụng"
            font.pixelSize: sizes.emptyStateSubtitleFontSize || 14
            color: theme.primary.dim_foreground
            font.family: "ComicShannsMono Nerd Font"
        }
    }
}

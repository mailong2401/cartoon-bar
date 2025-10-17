// components/Settings/NetworkSettings.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    property var theme
    
    ScrollView {
        anchors.fill: parent
        anchors.margins: 20
        clip: true
        
        ColumnLayout {
            width: parent.width
            spacing: 15
            
            Text {
                text: "Mạng"
                color: theme.primary.foreground
                font.pixelSize: 24
                font.bold: true
                Layout.topMargin: 10
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: theme.primary.dim_foreground + "40"
            }
            
            Text {
                text: "Cài đặt mạng sẽ được hiển thị ở đây"
                color: theme.primary.dim_foreground
                font.pixelSize: 14
                Layout.alignment: Qt.AlignCenter
                Layout.fillHeight: true
            }
        }
    }
}

import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    
    property string icon: "💧"
    property string title: "Title"
    property string value: "Value"
    property color color: theme.normal.blue
    
    radius: 12
    
    gradient: Gradient {
        GradientStop { position: 0.0; color: Qt.rgba(root.color.r, root.color.g, root.color.b, 0.1) }
        GradientStop { position: 0.5; color: Qt.rgba(root.color.r, root.color.g, root.color.b, 0.05) }
        GradientStop { position: 1.0; color: Qt.rgba(root.color.r, root.color.g, root.color.b, 0.1) }
    }
    
    border.color: Qt.rgba(root.color.r, root.color.g, root.color.b, 0.3)
    border.width: 1

    RowLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 15

        Rectangle {
            width: 50
            height: 50
            radius: 10
            color: Qt.rgba(root.color.r, root.color.g, root.color.b, 0.15)
            border.color: Qt.rgba(root.color.r, root.color.g, root.color.b, 0.3)
            border.width: 1

            Text {
                text: root.icon
                font.pixelSize: 24
                anchors.centerIn: parent
            }
        }

        ColumnLayout {
            spacing: 4
            Layout.fillWidth: true

            Text {
                text: root.title
                color: theme.primary.dim_foreground
                font {
                    pixelSize: 13
                    family: "ComicShannsMono Nerd Font"
                }
            }

            Text {
                text: root.value
                color: theme.primary.foreground
                font {
                    pixelSize: 18
                    bold: true
                    family: "ComicShannsMono Nerd Font"
                }
            }
        }
    }
}
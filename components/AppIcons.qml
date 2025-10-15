import QtQuick
import QtQuick.Layouts

Rectangle {
    width: 200
    height: 50
    color: "#F5EEE6"
    radius: 10
    border.color: "#4f4f5b"
    border.width: 3

    Row {
        anchors.centerIn: parent
        spacing: 15
        Repeater {
            model: [
                "../assets/dashboard.png",
            ]

            Image {
                source: modelData
                width: 40
                height: 40
                fillMode: Image.PreserveAspectFit
                smooth: true

                Behavior on scale {
                    NumberAnimation { duration: 120; easing.type: Easing.OutQuad }
                }

                MouseArea {
                  anchors.fill: parent
                  cursorShape: Qt.PointingHandCursor
                  hoverEnabled: true
                  onEntered: parent.scale = 1.2
                  onExited: parent.scale = 1.0
                }
            }
        }
    }
}

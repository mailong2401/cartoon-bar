import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ComboBox {
    id: customCombo
    property var theme : currentTheme
    property int popupWidth: width
    property int popupMaxHeight: 400
    property color popupBackground: theme.primary.background
    property color popupBorder: theme.button.border
    property color itemHoverColor: theme.button.background_select
    property color itemSelectedColor: theme.normal.blue + "40"
    
    // Style the main combo box
    background: Rectangle {
        color: theme.button.background
        border.color: customCombo.down ? theme.button.border_select : theme.button.border
        border.width: 2
        radius: 8
    }
    
    contentItem: Text {
        text: customCombo.displayText
        color: theme.primary.foreground
        font.pixelSize: 16
        font.family: "ComicShannsMono Nerd Font"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        elide: Text.ElideRight
        leftPadding: 15
        rightPadding: customCombo.indicator.width + customCombo.spacing
    }
    
    indicator: Canvas {
        id: arrowCanvas
        x: customCombo.width - width - 10
        y: customCombo.topPadding + (customCombo.availableHeight - height) / 2
        width: 12
        height: 8
        
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.strokeStyle = theme.primary.foreground
            ctx.lineWidth = 2
            ctx.beginPath()
            ctx.moveTo(0, 0)
            ctx.lineTo(width / 2, height)
            ctx.lineTo(width, 0)
            ctx.stroke()
        }
        
        Connections {
            target: customCombo
            function onPressedChanged() { arrowCanvas.requestPaint() }
        }
    }
    
    // Custom popup
    popup: Popup {
        id: comboPopup
        y: customCombo.height - 1
        width: Math.max(customCombo.popupWidth, customCombo.width)
        height: Math.min(listView.contentHeight + 20, customCombo.popupMaxHeight)
        padding: 0
        
        background: Rectangle {
            color: customCombo.popupBackground
            border.color: customCombo.popupBorder
            border.width: 2
            radius: 8
            layer.enabled: true
            layer.effect: DropShadow {
                color: "#40000000"
                radius: 16
                samples: 32
                verticalOffset: 4
            }
        }
        
        contentItem: ListView {
            id: listView
            clip: true
            model: customCombo.popup.visible ? customCombo.delegateModel : null
            currentIndex: customCombo.highlightedIndex
            boundsBehavior: Flickable.StopAtBounds
            
            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
                background: Rectangle {
                    color: theme.primary.dim_background
                    radius: 3
                }
                contentItem: Rectangle {
                    color: theme.normal.blue
                    radius: 3
                }
            }
        }
        
        enter: Transition {
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 150 }
            NumberAnimation { property: "scale"; from: 0.9; to: 1.0; duration: 150 }
        }
        
        exit: Transition {
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 100 }
        }
    }
    
    // Custom delegate for popup items
    delegate: ItemDelegate {
        id: delegateItem
        width: customCombo.popup.width
        height: 45
        
        background: Rectangle {
            color: delegateItem.highlighted ? customCombo.itemSelectedColor : 
                   delegateItem.hovered ? customCombo.itemHoverColor : "transparent"
            radius: 6
        }
        
        contentItem: Text {
            text: modelData
            color: theme.primary.foreground
            font.pixelSize: 16
            font.family: "ComicShannsMono Nerd Font"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            elide: Text.ElideRight
            leftPadding: 15
        }
        
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                customCombo.currentIndex = index
                customCombo.popup.close()
            }
        }
    }
}

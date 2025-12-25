import QtQuick
import QtQuick.Window
import Quickshell
import Quickshell.Services.Notifications

PanelWindow {
    id: root
    property var theme: currentTheme

    implicitWidth: 430
    anchors {
        top: true
    }
    margins {
        top: 10
    }
    exclusiveZone: 0
    visible: notificationModel.count > 0
    color: "transparent"

    // Tính toán chiều cao dựa trên số lượng thông báo
    property int maxNotifications: 4
    property int notificationHeight: 100
    property int notificationSpacing: 10
    property int containerMargin: 10

    // Tính toán: margin container (10*2) + notifications
    implicitHeight: containerMargin * 2 + notificationList.contentHeight

    Behavior on implicitHeight {
        NumberAnimation { duration: 10; easing.type: Easing.OutCubic }
    }
    
    // Container chính cho popup
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        
        // Hiệu ứng shadow
        layer.enabled: true

        
        // Danh sách notification
        ListView {
            id: notificationList
            anchors.fill: parent
            anchors.margins: 10
            spacing: notificationSpacing
            clip: true
            model: ListModel { id: notificationModel }
            interactive: false

            // Giới hạn chiều cao tối đa
            property int maxHeight: maxNotifications * (notificationHeight + notificationSpacing)
            height: Math.min(contentHeight, maxHeight)

            Behavior on height {
                NumberAnimation { duration: 10; easing.type: Easing.OutCubic }
            }

            delegate: Rectangle {
                id: notificationDelegate
                width: notificationList.width
                height: isExpanded ? contentColumn.implicitHeight + 24 : notificationHeight
                radius: 8
                color: {
                    switch(model.urgency) {
                        case NotificationUrgency.Critical: return theme.primary.dim_background
                        case NotificationUrgency.Normal: return theme.primary.dim_background
                        case NotificationUrgency.Low: return theme.primary.dim_background
                        default: return theme.button.background
                    }
                }
                border.color: Qt.darker(color, 1.1)
                border.width: 3

                property bool isExpanded: false
                property bool hasLongContent: false

                Behavior on height {
                    NumberAnimation { duration: 20; easing.type: Easing.OutCubic }
                }

                // Hiệu ứng mờ dần khi xóa
                opacity: 1
                Behavior on opacity {
                    NumberAnimation { duration: 200 }
                }

                // Timer tự động xóa
                Timer {
                    id: autoDismiss
                    interval: model.timeout > 0 ? model.timeout * 1000 : 10000
                    onTriggered: removeNotification()
                }

                Column {
                    id: contentColumn
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 6

                    // Header với app icon và tên
                    Row {
                        width: parent.width
                        spacing: 8
                        height: 24

                        Rectangle {
                            width: 24
                            height: 24
                            radius: 12
                            color: {
                                switch(model.urgency) {
                                    case NotificationUrgency.Critical: return theme.normal.red
                                    case NotificationUrgency.Normal: return theme.normal.blue
                                    case NotificationUrgency.Low: return theme.normal.green
                                    default: return theme.button.background
                                }
                            }

                            Text {
                                anchors.centerIn: parent
                                text: model.appName ? model.appName.charAt(0).toUpperCase() : "N"
                                font.bold: true
                                color: theme.primary.background
                                font.pixelSize: 12
                            }
                        }

                        Text {
                            text: model.appName || "Unknown App"
                            font.bold: true
                            color: theme.button.text
                            elide: Text.ElideRight
                            width: parent.width - (hasLongContent ? 104 : 80)
                            font.pixelSize: 12
                        }

                        // Expand button (only show if content is long)
                        MouseArea {
                            width: 24
                            height: 24
                            anchors.verticalCenter: parent.verticalCenter
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            visible: hasLongContent
                            onClicked: isExpanded = !isExpanded

                            Rectangle {
                                anchors.fill: parent
                                radius: 12
                                color: parent.containsMouse ? theme.button.background_select : "transparent"

                                Text {
                                    anchors.centerIn: parent
                                    text: isExpanded ? "▲" : "▼"
                                    font.pixelSize: 10
                                    color: parent.parent.containsMouse ? theme.primary.foreground : theme.primary.dim_foreground
                                    font.bold: true
                                }
                            }
                        }

                        // Close button
                        MouseArea {
                            width: 24
                            height: 24
                            anchors.verticalCenter: parent.verticalCenter
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: removeNotification()

                            Rectangle {
                                anchors.fill: parent
                                radius: 12
                                color: parent.containsMouse ? theme.normal.red : "transparent"

                                Text {
                                    anchors.centerIn: parent
                                    text: "×"
                                    font.pixelSize: 16
                                    color: parent.parent.containsMouse ? theme.primary.foreground : theme.primary.dim_foreground
                                    font.bold: true
                                }
                            }
                        }
                    }

                    // Tiêu đề
                    Text {
                        id: summaryText
                        width: parent.width
                        text: model.summary
                        font.bold: true
                        font.pixelSize: 14
                        wrapMode: Text.WordWrap
                        color: theme.primary.foreground
                        maximumLineCount: isExpanded ? 2 : 1
                        elide: Text.ElideRight
                    }

                    // Nội dung
                    Text {
                        id: bodyText
                        width: parent.width
                        text: model.body
                        font.pixelSize: 12
                        wrapMode: Text.WordWrap
                        color: theme.primary.foreground
                        maximumLineCount: isExpanded ? 5 : 2
                        elide: Text.ElideRight

                        onTruncatedChanged: {
                            if (!isExpanded) {
                                hasLongContent = truncated
                            }
                        }

                        Component.onCompleted: {
                            Qt.callLater(function() {
                                if (!isExpanded) {
                                    hasLongContent = truncated
                                }
                            })
                        }
                    }



                    // Actions (nếu có)
                    Flow {
                        width: parent.width
                        spacing: 5
                        visible: model.actions && model.actions.length > 0

                        Repeater {
                            model: model.actions || []

                            Rectangle {
                                height: 26
                                width: Math.min(actionText.width + 16, 120)
                                radius: 5
                                color: {
                                    switch(parent.parent.parent.model.urgency) {
                                        case NotificationUrgency.Critical: return theme.normal.red
                                        case NotificationUrgency.Normal: return theme.normal.blue
                                        case NotificationUrgency.Low: return theme.normal.green
                                        default: return theme.button.background
                                    }
                                }

                                Text {
                                    id: actionText
                                    anchors.centerIn: parent
                                    text: modelData.text || modelData.identifier
                                    color: theme.primary.foreground
                                    font.pixelSize: 10
                                    font.bold: true
                                    elide: Text.ElideRight
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        modelData.invoke()
                                        removeNotification()
                                    }
                                }
                            }
                        }
                    }
                }

                function removeNotification() {
                    notificationDelegate.opacity = 0
                    notificationTimer.start()
                }

                Timer {
                    id: notificationTimer
                    interval: 200
                    onTriggered: notificationModel.remove(index)
                }

                Component.onCompleted: {
                    autoDismiss.restart()
                }
            }
        }
    }
    
    NotificationServer {
        id: server
        actionsSupported: true
        imageSupported: true
        inlineReplySupported: true
        
        onNotification: function(notification) {
            notificationModel.insert(0, {
                id: notification.id,
                appName: notification.appName || "",
                summary: notification.summary,
                body: notification.body,
                urgency: notification.urgency,
                timeout: notification.expireTimeout,
                actions: notification.actions
            })
            
            // Giữ tối đa 4 notification
            if (notificationModel.count > maxNotifications) {
                // Xóa notification cũ nhất
                notificationModel.remove(maxNotifications)
            }
            
            // Giữ thông báo
            notification.tracked = true
        }
    }
    
}

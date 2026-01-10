import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Qt.labs.folderlistmodel

Item {
    id: systemSettings
    property var theme: currentTheme
    property var lang: currentLanguage

    property string homePath: ""
    property string wallpapersPath: ""
    property string wallpaperPath: ""
    property string currentWallpaper: ""

    // Process để lấy home directory
    Process {
        id: getHomeProcess
        command: ["bash", "-c", "echo $HOME"]
        running: true
        stdout: StdioCollector {
            id: homeOutput
            onTextChanged: {
                if (text) {
                    var path = text.trim()
                    systemSettings.homePath = path
                    systemSettings.wallpapersPath = "file://" + path + "/Pictures/Wallpapers/"
                }
            }
        }
    }

    // Process để set wallpaper
    Process {
        id: wallpaperProcess
        command: ["swww", "img", "", "--transition-type", "grow", "--transition-duration", "1"]

        stdout: StdioCollector {
            onTextChanged: { }
        }

        onRunningChanged: {
            if (!running) {
                currentWallpaper = wallpaperPath
                showNotification(lang?.wallpapers?.success_set || "Đã đặt hình nền thành công!")
                folderModel.update()
            }
        }
    }

    // Process để xóa file
    Process {
        id: deleteProcess
        command: ["rm", ""]

        stdout: StdioCollector {
            onTextChanged: { }
        }

        onRunningChanged: {
            if (!running) {
                showNotification(lang?.wallpapers?.success_delete || "Đã xóa ảnh thành công!")
                folderModel.update()
            }
        }
    }

    ScrollView {
        anchors.fill: parent
        anchors.margins: currentSizes.wallpaperSettings?.margin || 20
        clip: true

        ColumnLayout {
            width: parent.width - (2 * (currentSizes.wallpaperSettings?.margin || 20))
            spacing: currentSizes.wallpaperSettings?.columnSpacing || 20

            // Header
            Text {
                text: lang?.wallpapers?.title || "Quản lý hình ảnh"
                color: theme.primary.foreground
                font.pixelSize: currentSizes.wallpaperSettings?.titleFontSize || currentSizes.fontSize?.xlarge || 24
                font.family: "ComicShannsMono Nerd Font"
                font.bold: true
                Layout.topMargin: currentSizes.wallpaperSettings?.buttonFontSize || 10
            }

            Rectangle {
                Layout.fillWidth: true
                height: currentSizes.wallpaperSettings?.dividerHeight || 1
                color: theme.primary.dim_foreground + "40"
            }

            // Statistics
            RowLayout {
                Layout.fillWidth: true
                spacing: currentSizes.wallpaperSettings?.columnSpacing || 20

                Rectangle {
                    Layout.preferredWidth: currentSizes.wallpaperSettings?.statsWidth || 160
                    Layout.preferredHeight: currentSizes.wallpaperSettings?.statsHeight || 40
                    radius: currentSizes.wallpaperSettings?.statsRadius || 8
                    color: theme.button.background
                    border.color: theme.button.border
                    border.width: currentSizes.wallpaperSettings?.statsBorderWidth || 2

                    Row {
                        anchors.centerIn: parent
                        spacing: 4

                        Text {
                            text: lang?.wallpapers?.total_images || "Tổng số ảnh:"
                            font.family: "ComicShannsMono Nerd Font"
                            color: theme.primary.dim_foreground
                            font.pixelSize: currentSizes.wallpaperSettings?.statsLabelFontSize || 15
                        }

                        Text {
                            text: folderModel.count
                            color: theme.normal.blue
                            font.family: "ComicShannsMono Nerd Font"
                            font.pixelSize: currentSizes.wallpaperSettings?.statsValueFontSize || 18
                            font.bold: true
                        }
                    }
                }

                Text {
                    text: homePath ? (lang?.wallpapers?.path || "Đường dẫn:") + " " + homePath + "/Pictures/Wallpapers/" : (lang?.wallpapers?.loading || "Đang tải...")
                    font.family: "ComicShannsMono Nerd Font"
                    color: theme.primary.dim_foreground
                    font.pixelSize: currentSizes.wallpaperSettings?.pathFontSize || 16
                    Layout.fillWidth: true
                    elide: Text.ElideMiddle
                }
            }

            // Wallpapers Grid
            GridView {
                id: wallpapersGrid
                Layout.fillWidth: true
                Layout.preferredHeight: Math.max(
                    currentSizes.wallpaperSettings?.gridMinHeight || 400,
                    Math.ceil(folderModel.count / Math.floor((parent.width - (2 * (currentSizes.wallpaperSettings?.margin || 20))) / (currentSizes.wallpaperSettings?.gridCellWidth || 190))) *
                    (currentSizes.wallpaperSettings?.gridCellHeight || 200)
                )
                cellWidth: currentSizes.wallpaperSettings?.gridCellWidth || 190
                cellHeight: currentSizes.wallpaperSettings?.gridCellHeight || 200
                clip: true

                model: FolderListModel {
                    id: folderModel
                    folder: wallpapersPath
                    nameFilters: ["*.jpg","*.jpeg","*.png","*.bmp","*.webp"]
                    showDirs: false
                    sortField: FolderListModel.Name
                }

                delegate: Rectangle {
                    width: wallpapersGrid.cellWidth - (currentSizes.wallpaperSettings?.gridCellSpacing || 10)
                    height: wallpapersGrid.cellHeight - (currentSizes.wallpaperSettings?.gridCellSpacing || 10)
                    radius: currentSizes.wallpaperSettings?.itemRadius || 12
                    color: theme.button.background
                    border.color: theme.button.border
                    border.width: currentSizes.wallpaperSettings?.itemBorderWidth || 1

                    Column {
                        anchors.fill: parent
                        anchors.margins: currentSizes.wallpaperSettings?.itemPadding || 8
                        spacing: currentSizes.wallpaperSettings?.itemContentSpacing || 8

                        // Thumbnail
                        Rectangle {
                            width: parent.width
                            height: parent.height - (currentSizes.wallpaperSettings?.thumbnailHeightOffset || 70)
                            radius: currentSizes.radius?.small || 8
                            clip: true
                            color: "transparent"

                            Image {
                                anchors.fill: parent
                                source: filePath
                                fillMode: Image.PreserveAspectCrop
                                asynchronous: true
                            }

                            // Current Wallpaper Indicator
                            Rectangle {
                                visible: isCurrentWallpaper(filePath)
                                anchors.top: parent.top
                                anchors.right: parent.right
                                anchors.margins: currentSizes.wallpaperSettings?.currentIndicatorMargin || 5
                                width: currentSizes.wallpaperSettings?.currentIndicatorSize || 24
                                height: currentSizes.wallpaperSettings?.currentIndicatorSize || 24
                                radius: currentSizes.wallpaperSettings?.currentIndicatorRadius || 12
                                color: theme.normal.green

                                Text {
                                    text: "✓"
                                    color: theme.primary.background
                                    font.pixelSize: currentSizes.wallpaperSettings?.currentIndicatorFontSize || 12
                                    font.bold: true
                                    anchors.centerIn: parent
                                }
                            }
                        }

                        // File Info & Actions
                        Column {
                            width: parent.width
                            spacing: currentSizes.wallpaperSettings?.fileInfoSpacing || 6

                            Text {
                                text: fileName
                                color: theme.primary.foreground
                                font.pixelSize: currentSizes.wallpaperSettings?.fileNameFontSize || 11
                                elide: Text.ElideMiddle
                                width: parent.width
                            }

                            Row {
                                width: parent.width
                                spacing: currentSizes.spacing?.normal || 8
                                Text {
                                    text: Math.round(fileSize / 1024) + " KB"
                                    color: theme.primary.dim_foreground
                                    font.pixelSize: currentSizes.wallpaperSettings?.fileSizeFontSize || 9
                                }
                                Text {
                                    text: new Date(fileModified).toLocaleDateString(Qt.locale(), "dd/MM/yyyy")
                                    color: theme.primary.dim_foreground
                                    font.pixelSize: currentSizes.wallpaperSettings?.fileDateFontSize || 9
                                }
                            }

                            Row {
                                width: parent.width
                                spacing: currentSizes.wallpaperSettings?.actionsSpacing || 6

                                // Set Wallpaper
                                Rectangle {
                                    width: (parent.width - currentSizes.wallpaperSettings?.actionsSpacing || 6) / 2
                                    height: currentSizes.wallpaperSettings?.buttonHeight || 28
                                    radius: currentSizes.wallpaperSettings?.buttonRadius || 6
                                    color: isCurrentWallpaper(filePath) ? theme.normal.green : theme.normal.blue

                                    Text {
                                        anchors.centerIn: parent
                                        text: isCurrentWallpaper(filePath) ? (lang?.wallpapers?.already_set || "Đã đặt") : (lang?.wallpapers?.set_wallpaper || "Đặt nền")
                                        color: theme.primary.background
                                        font.pixelSize: currentSizes.wallpaperSettings?.buttonFontSize || 10
                                        font.bold: true
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: setWallpaper(filePath)
                                    }
                                }

                                // Delete Button
                                Rectangle {
                                    width: (parent.width - currentSizes.wallpaperSettings?.actionsSpacing || 6) / 2
                                    height: currentSizes.wallpaperSettings?.buttonHeight || 28
                                    radius: currentSizes.wallpaperSettings?.buttonRadius || 6
                                    color: theme.normal.red

                                    Text {
                                        anchors.centerIn: parent
                                        text: lang?.wallpapers?.delete || "Xóa"
                                        color: theme.primary.background
                                        font.pixelSize: currentSizes.wallpaperSettings?.buttonFontSize || 10
                                        font.bold: true
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: showDeleteDialog(fileName, filePath)
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // No images message
            Text {
                visible: folderModel.count === 0 && homePath
                text: lang?.wallpapers?.no_images || "Không tìm thấy ảnh nào trong thư mục ~/Pictures/Wallpapers"
                color: theme.primary.dim_foreground
                font.pixelSize: currentSizes.fontSize?.normal || 14
                Layout.alignment: Qt.AlignCenter
            }

            // Loading message
            Text {
                visible: !homePath
                text: lang?.wallpapers?.loading_info || "Đang tải thông tin..."
                color: theme.primary.dim_foreground
                font.pixelSize: currentSizes.fontSize?.normal || 14
                Layout.alignment: Qt.AlignCenter
            }
        }
    }

    // Delete dialog
    Rectangle {
        id: deleteDialog
        visible: false
        anchors.centerIn: parent
        width: currentSizes.wallpaperSettings?.dialogWidth || 300
        height: currentSizes.wallpaperSettings?.dialogHeight || 160
        radius: currentSizes.wallpaperSettings?.dialogRadius || 12
        color: theme.primary.background
        border.color: theme.normal.red
        border.width: currentSizes.wallpaperSettings?.dialogBorderWidth || 2
        z: 1000

        property string fileNameToDelete: ""
        property string filePathToDelete: ""

        Column {
            anchors.fill: parent
            anchors.margins: currentSizes.wallpaperSettings?.dialogPadding || 20
            spacing: currentSizes.wallpaperSettings?.dialogSpacing || 15

            Text {
                text: (lang?.wallpapers?.delete_confirm || "Xác nhận xóa") + "\n" + deleteDialog.fileNameToDelete
                color: theme.normal.red
                font.pixelSize: currentSizes.wallpaperSettings?.dialogTitleFontSize || 16
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
            }

            Row {
                spacing: currentSizes.wallpaperSettings?.dialogSpacing || 15
                anchors.horizontalCenter: parent.horizontalCenter

                // Cancel
                Rectangle {
                    width: currentSizes.wallpaperSettings?.dialogButtonWidth || 100
                    height: currentSizes.wallpaperSettings?.dialogButtonHeight || 35
                    radius: currentSizes.wallpaperSettings?.dialogButtonRadius || 6
                    color: theme.button.background
                    border.color: theme.button.border

                    Text {
                        anchors.centerIn: parent;
                        text: lang?.wallpapers?.cancel || "Hủy";
                        color: theme.primary.foreground
                        font.pixelSize: currentSizes.wallpaperSettings?.dialogButtonFontSize || 14
                    }

                    MouseArea {
                        anchors.fill: parent;
                        onClicked: deleteDialog.visible = false
                    }
                }

                // Confirm delete
                Rectangle {
                    width: currentSizes.wallpaperSettings?.dialogButtonWidth || 100
                    height: currentSizes.wallpaperSettings?.dialogButtonHeight || 35
                    radius: currentSizes.wallpaperSettings?.dialogButtonRadius || 6
                    color: theme.normal.red

                    Text {
                        anchors.centerIn: parent;
                        text: lang?.wallpapers?.delete || "Xóa";
                        color: theme.primary.background
                        font.pixelSize: currentSizes.wallpaperSettings?.dialogButtonFontSize || 14
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            deleteWallpaper(deleteDialog.filePathToDelete)
                            deleteDialog.visible = false
                        }
                    }
                }
            }
        }
    }

    // Notification
    Rectangle {
        id: successNotification
        visible: false
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: currentSizes.wallpaperSettings?.notificationTopMargin || 20
        width: currentSizes.wallpaperSettings?.notificationWidth || 250
        height: currentSizes.wallpaperSettings?.notificationHeight || 50
        radius: currentSizes.wallpaperSettings?.notificationRadius || 8
        color: theme.normal.green
        z: 1001

        Row {
            anchors.centerIn: parent;
            spacing: currentSizes.wallpaperSettings?.notificationSpacing || 10
            Text {
                text: "✓";
                color: theme.primary.background;
                font.bold: true;
                font.pixelSize: currentSizes.wallpaperSettings?.notificationFontSize || 16
            }
            Text {
                id: notificationText;
                color: theme.primary.background;
                text: "";
                font.bold: true;
                font.pixelSize: currentSizes.wallpaperSettings?.notificationFontSize || 16
            }
        }

        Timer {
            id: notificationTimer;
            interval: 3000;
            onTriggered: successNotification.visible = false
        }
    }

    function setWallpaper(filePath) {
        wallpaperPath = filePath.toString().replace("file://", "")

        wallpaperProcess.command = [
            "swww", "img", wallpaperPath,
            "--transition-type", "grow",
            "--transition-duration", "2"
        ]
        wallpaperProcess.running = true
    }

    function deleteWallpaper(filePath) {
        var actualPath = filePath.toString().replace("file://", "")

        deleteProcess.command = ["rm", actualPath]
        deleteProcess.running = true
    }

    function showDeleteDialog(fileName, filePath) {
        deleteDialog.fileNameToDelete = fileName
        deleteDialog.filePathToDelete = filePath
        deleteDialog.visible = true
    }

    function showNotification(message) {
        notificationText.text = message
        successNotification.visible = true
        notificationTimer.start()
    }

    function isCurrentWallpaper(filePath) {
        var actualPath = filePath.toString().replace("file://", "")
        return currentWallpaper === actualPath
    }

    Component.onCompleted: {
    }
}
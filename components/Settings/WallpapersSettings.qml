import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Qt.labs.folderlistmodel

Item {
    id: systemSettings
    property var theme: currentTheme
    
    property string homePath: ""
    property string wallpapersPath: ""
    property string wallpaperPath: ""
    property string currentWallpaper: ""
    width: 800
    height: 600

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
                    console.log("Home directory found:", path)
                    console.log("Wallpapers path:", systemSettings.wallpapersPath)
                }
            }
        }
    }

    // Process để set wallpaper
    Process {
        id: wallpaperProcess
        command: ["swww", "img", "", "--transition-type", "grow", "--transition-duration", "1"]

        stdout: StdioCollector {
            onTextChanged: if (text) console.log("swww output:", text)
        }

        onRunningChanged: {
            if (!running) {
                console.log("Wallpaper set successfully")
                currentWallpaper = wallpaperPath
                showNotification("Đã đặt hình nền thành công!")
                folderModel.update()
            }
        }
    }

    // Rest of your code remains the same...
    // Process để xóa file
    Process {
        id: deleteProcess
        command: ["rm", ""]

        stdout: StdioCollector {
            onTextChanged: if (text) console.log("rm output:", text)
        }

        onRunningChanged: {
            if (!running) {
                console.log("Wallpaper deleted successfully")
                showNotification("Đã xóa ảnh thành công!")
                folderModel.update()
            }
        }
    }

    ScrollView {
        anchors.fill: parent
        anchors.margins: 20
        clip: true

        ColumnLayout {
            width: 490
            spacing: 20

            // Header
            Text {
                text: "Quản lý hình ảnh"
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

            // Statistics
            RowLayout {
                Layout.fillWidth: true
                spacing: 20

                Rectangle {
                    Layout.preferredWidth: 160
                    Layout.preferredHeight: 40
                    radius: 8
                    color: theme.button.background
                    border.color: theme.button.border

                    Row {
                        anchors.centerIn: parent
                        spacing: 4

                        Text {
                            text: "Tổng số ảnh: "
                            font.family: "ComicShannsMono Nerd Font"
                            color: theme.primary.dim_foreground
                            font.pixelSize: 15
                        }

                        Text {
                            text: folderModel.count
                            color: theme.normal.blue
                            font.family: "ComicShannsMono Nerd Font"
                            font.pixelSize: 18
                            font.bold: true
                        }
                    }
                }

                Text {
                    text: homePath ? "Đường dẫn: " + homePath + "/Pictures/Wallpapers/" : "Đang tải..."
                    font.family: "ComicShannsMono Nerd Font"
                    color: theme.primary.dim_foreground
                    font.pixelSize: 16
                    Layout.fillWidth: true
                }
            }

            // Wallpapers Grid
            GridView {
                id: wallpapersGrid
                Layout.fillWidth: true
                Layout.preferredHeight: Math.max(400, Math.ceil(folderModel.count / 4) * 200)
                cellWidth: width / 4
                cellHeight: 200
                clip: true

                model: FolderListModel {
                    id: folderModel
                    folder: wallpapersPath
                    nameFilters: ["*.jpg","*.jpeg","*.png","*.bmp","*.webp"]
                    showDirs: false
                    sortField: FolderListModel.Name
                }

                delegate: Rectangle {
                    width: wallpapersGrid.cellWidth - 10
                    height: wallpapersGrid.cellHeight - 10
                    radius: 12
                    color: theme.button.background
                    border.color: theme.button.border
                    border.width: 1

                    Column {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 8

                        // Thumbnail
                        Rectangle {
                            width: parent.width
                            height: parent.height - 70
                            radius: 8
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
                                anchors.margins: 5
                                width: 24
                                height: 24
                                radius: 12
                                color: theme.normal.green

                                Text {
                                    text: "✓"
                                    color: theme.primary.background
                                    font.pixelSize: 12
                                    font.bold: true
                                    anchors.centerIn: parent
                                }
                            }
                        }

                        // File Info & Actions
                        Column {
                            width: parent.width
                            spacing: 6

                            Text {
                                text: fileName
                                color: theme.primary.foreground
                                font.pixelSize: 11
                                elide: Text.ElideMiddle
                                width: parent.width
                            }

                            Row {
                                width: parent.width
                                spacing: 8
                                Text {
                                    text: Math.round(fileSize / 1024) + " KB"
                                    color: theme.primary.dim_foreground
                                    font.pixelSize: 9
                                }
                                Text {
                                    text: new Date(fileModified).toLocaleDateString(Qt.locale(), "dd/MM/yyyy")
                                    color: theme.primary.dim_foreground
                                    font.pixelSize: 9
                                }
                            }

                            Row {
                                width: parent.width
                                spacing: 6

                                // Set Wallpaper
                                Rectangle {
                                    width: (parent.width - 6) / 2
                                    height: 28
                                    radius: 6
                                    color: isCurrentWallpaper(filePath) ? theme.normal.green : theme.normal.blue

                                    Text {
                                        anchors.centerIn: parent
                                        text: isCurrentWallpaper(filePath) ? "Đã đặt" : "Đặt nền"
                                        color: theme.primary.background
                                        font.pixelSize: 10
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
                                    width: (parent.width - 6) / 2
                                    height: 28
                                    radius: 6
                                    color: theme.normal.red

                                    Text {
                                        anchors.centerIn: parent
                                        text: "Xóa"
                                        color: theme.primary.background
                                        font.pixelSize: 10
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
                text: "Không tìm thấy ảnh nào trong thư mục ~/Pictures/Wallpapers"
                color: theme.primary.dim_foreground
                font.pixelSize: 14
                Layout.alignment: Qt.AlignCenter
            }

            // Loading message
            Text {
                visible: !homePath
                text: "Đang tải thông tin..."
                color: theme.primary.dim_foreground
                font.pixelSize: 14
                Layout.alignment: Qt.AlignCenter
            }
        }
    }

    // Delete dialog
    Rectangle {
        id: deleteDialog
        visible: false
        anchors.centerIn: parent
        width: 300
        height: 160
        radius: 12
        color: theme.primary.background
        border.color: theme.normal.red
        border.width: 2
        z: 1000

        property string fileNameToDelete: ""
        property string filePathToDelete: ""

        Column {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            Text {
                text: "Xác nhận xóa\n" + deleteDialog.fileNameToDelete
                color: theme.normal.red
                font.pixelSize: 16
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
            }

            Row {
                spacing: 15
                anchors.horizontalCenter: parent.horizontalCenter

                // Cancel
                Rectangle {
                    width: 100; height: 35; radius: 6
                    color: theme.button.background
                    border.color: theme.button.border

                    Text { 
                        anchors.centerIn: parent; 
                        text: "Hủy"; 
                        color: theme.primary.foreground 
                    }

                    MouseArea { 
                        anchors.fill: parent; 
                        onClicked: deleteDialog.visible = false 
                    }
                }

                // Confirm delete
                Rectangle {
                    width: 100; height: 35; radius: 6
                    color: theme.normal.red

                    Text { 
                        anchors.centerIn: parent; 
                        text: "Xóa"; 
                        color: theme.primary.background 
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
        anchors.topMargin: 20
        width: 250; height: 50
        radius: 8
        color: theme.normal.green
        z: 1001

        Row { 
            anchors.centerIn: parent; 
            spacing: 10
            Text { 
                text: "✓"; 
                color: theme.primary.background;
                font.bold: true;
            }
            Text { 
                id: notificationText; 
                color: theme.primary.background; 
                text: "";
                font.bold: true;
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
        console.log("Setting wallpaper:", wallpaperPath)

        wallpaperProcess.command = [
            "swww", "img", wallpaperPath,
            "--transition-type", "grow",
            "--transition-duration", "2"
        ]
        wallpaperProcess.running = true
    }

    function deleteWallpaper(filePath) {
        var actualPath = filePath.toString().replace("file://", "")
        console.log("Deleting wallpaper:", actualPath)

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
        console.log("SystemSettings component loaded")
        console.log("Trying to get HOME directory...")
    }
}

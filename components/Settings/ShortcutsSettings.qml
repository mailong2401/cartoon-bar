// components/Settings/ShortcutsSettings.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

Item {
    property var theme : currentTheme
    property var shortcutModel: ListModel {
        ListElement { name: "New File"; key: "Ctrl+N"; category: "File" }
        ListElement { name: "Save File"; key: "Ctrl+S"; category: "File" }
        ListElement { name: "Open File"; key: "Ctrl+O"; category: "File" }
        ListElement { name: "Undo"; key: "Ctrl+Z"; category: "Edit" }
        ListElement { name: "Redo"; key: "Ctrl+Y"; category: "Edit" }
        ListElement { name: "Copy"; key: "Ctrl+C"; category: "Edit" }
        ListElement { name: "Paste"; key: "Ctrl+V"; category: "Edit" }
        ListElement { name: "Find"; key: "Ctrl+F"; category: "Search" }
        ListElement { name: "Replace"; key: "Ctrl+H"; category: "Search" }
        ListElement { name: "Build Project"; key: "Ctrl+B"; category: "Build" }
        ListElement { name: "Run Project"; key: "Ctrl+R"; category: "Build" }
    }

    ScrollView {
        anchors.fill: parent
        anchors.margins: 20
        clip: true
        
        ColumnLayout {
            width: 400
            spacing: 20
            
            // Header
            Text {
                text: "Keyboard Shortcuts"
                color: theme.primary.foreground
                font.pixelSize: 28
                font.bold: true
                Layout.topMargin: 10
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: theme.primary.dim_foreground + "40"
            }

            // Search Box
            Rectangle {
                Layout.fillWidth: true
                height: 40
                color: theme.primary.dim_background
                radius: 8
                border.width: 1
                border.color: theme.normal.black

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 8

                    Image {
                        source: "qrc:/icons/search.svg"
                        Layout.preferredWidth: 20
                        Layout.preferredHeight: 20
                        Layout.leftMargin: 10
                    }

                    TextField {
                        id: searchField
                        Layout.fillWidth: true
                        placeholderText: "Search shortcuts..."
                        color: theme.primary.foreground
                        background: Rectangle {
                            color: "transparent"
                        }
                        placeholderTextColor: theme.primary.dim_foreground
                    }
                }
            }

            // Shortcuts List
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 15

                Repeater {
                    model: shortcutModel
                    
                    Rectangle {
                        Layout.fillWidth: true
                        height: 60
                        color: theme.primary.dim_background
                        radius: 8
                        border.width: 1
                        border.color: theme.normal.black

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 15

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 4

                                Text {
                                    text: name
                                    color: theme.primary.foreground
                                    font.pixelSize: 16
                                    font.bold: true
                                }

                                Text {
                                    text: category
                                    color: theme.primary.dim_foreground
                                    font.pixelSize: 12
                                }
                            }

                            // Current Key Binding
                            Rectangle {
                                Layout.preferredWidth: 100
                                Layout.preferredHeight: 35
                                color: theme.button.background
                                radius: 6
                                border.width: 1
                                border.color: theme.button.border

                                Text {
                                    anchors.centerIn: parent
                                    text: key
                                    color: theme.button.text
                                    font.pixelSize: 14
                                }
                            }

                            // Edit Button
                            Button {
                                Layout.preferredWidth: 80
                                Layout.preferredHeight: 35
                                text: "Edit"
                                background: Rectangle {
                                    color: parent.pressed ? theme.button.background_select : theme.button.background
                                    radius: 6
                                    border.width: 1
                                    border.color: parent.pressed ? theme.button.border_select : theme.button.border
                                }
                                contentItem: Text {
                                    text: parent.text
                                    color: theme.button.text
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }

                                onClicked: {
                                    editDialog.shortcutName = name
                                    editDialog.currentKey = key
                                    editDialog.open()
                                }
                            }
                        }
                    }
                }
            }

            // Reset Section
            Rectangle {
                Layout.fillWidth: true
                height: 80
                color: theme.primary.dim_background
                radius: 8
                border.width: 1
                border.color: theme.normal.black

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 15

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4

                        Text {
                            text: "Reset to Defaults"
                            color: theme.primary.foreground
                            font.pixelSize: 16
                            font.bold: true
                        }

                        Text {
                            text: "Restore all shortcuts to their default values"
                            color: theme.primary.dim_foreground
                            font.pixelSize: 12
                        }
                    }

                    Button {
                        Layout.preferredWidth: 120
                        Layout.preferredHeight: 40
                        text: "Reset All"
                        background: Rectangle {
                            color: parent.pressed ? theme.normal.red + "80" : theme.normal.red
                            radius: 6
                        }
                        contentItem: Text {
                            text: parent.text
                            color: theme.primary.background
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                        }

                        onClicked: resetConfirmation.open()
                    }
                }
            }
        }
    }

    // Edit Shortcut Dialog
    Dialog {
        id: editDialog
        property string shortcutName: ""
        property string currentKey: ""
        
        title: "Edit Shortcut - " + shortcutName
        modal: true
        standardButtons: Dialog.Ok | Dialog.Cancel
        
        background: Rectangle {
            color: theme.primary.background
            radius: 12
            border.width: 2
            border.color: theme.normal.black
        }
        
        ColumnLayout {
            width: parent ? parent.width : 400
            spacing: 15
            
            Text {
                text: "Press new key combination:"
                color: theme.primary.foreground
                font.pixelSize: 14
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 50
                color: theme.primary.dim_background
                radius: 6
                border.width: 2
                border.color: theme.normal.blue
                
                Text {
                    anchors.centerIn: parent
                    text: editDialog.currentKey
                    color: theme.primary.foreground
                    font.pixelSize: 16
                    font.bold: true
                }
            }
            
            Text {
                text: "Press Esc to cancel or Backspace to clear"
                color: theme.primary.dim_foreground
                font.pixelSize: 12
            }
        }
    }

    // Reset Confirmation Dialog
    MessageDialog {
        id: resetConfirmation
        title: "Reset Shortcuts"
        text: "Are you sure you want to reset all shortcuts to their default values?"
        buttons: MessageDialog.Yes | MessageDialog.No
    }
}

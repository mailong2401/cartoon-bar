// components/Settings/SettingsPanel.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "."
import ".." as Components


Rectangle {
    id: settingsPanel
    property var theme : currentTheme
    signal backRequested()

    radius: 12
    color: theme.primary.background
    // Shadow effect
    layer.enabled: true

    // Shared JsonEditor for all Settings
    Components.JsonEditor {
        id: sharedPanelConfig
        filePath: Qt.resolvedUrl("../../themes/sizes/" + currentSizeProfile + ".json")
        Component.onCompleted: {
            sharedPanelConfig.load(sharedPanelConfig.filePath)
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 20

        
        // Sidebar
        SidebarSettings {
            theme: settingsPanel.theme
            onCategoryChanged: function(index) {
                settingsStack.currentIndex = index
            }
            onBackRequested: function() {
                settingsPanel.backRequested()
            }
        }
        
        // Content Area
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: theme.primary.dim_background
            radius: 8
            border {
              color : theme.normal.black
              width: 2
            }
            
            StackLayout {
                id: settingsStack
                anchors.fill: parent
                currentIndex: 0
                
                // General Settings
                GeneralSettings {
                    panelConfig: sharedPanelConfig
                }

                // Appearance Settings
                AppearanceSettings {
                    panelConfig: sharedPanelConfig
                }

                // WallPapers Setetings
                WallpapersSettings{

                }
                
                // Network Settings
                NetworkSettings {
                }
                
                // Audio Settings
                AudioSettings {
                }
                
                // Performance Settings
                PerformanceSettings {
                }
                
                // Shortcuts Settings
                ShortcutsSettings {
                }
                
                
                // System Settings
                SystemSettings {
                }
            }
        }
    }
}

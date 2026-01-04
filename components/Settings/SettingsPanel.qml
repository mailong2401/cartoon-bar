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

    radius: currentSizes.settingsPanel?.panelRadius || currentSizes.radius?.normal || 12
    color: theme.primary.background
    // Shadow effect
    layer.enabled: true

    // Shared JsonEditor for all Settings
    Components.JsonEditor {
        id: sharedPanelConfig
        filePath: Qt.resolvedUrl("../../configs/" + currentConfigProfile + ".json")
        Component.onCompleted: {
            sharedPanelConfig.load(sharedPanelConfig.filePath)
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: currentSizes.settingsPanel?.contentSpacing || currentSizes.spacing?.large || 20

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
            radius: currentSizes.settingsPanel?.contentAreaRadius || currentSizes.radius?.small || 8
            border {
                color: theme.normal.black
                width: currentSizes.settingsPanel?.contentAreaBorderWidth || 2
            }
            
            StackLayout {
                id: settingsStack
                anchors.fill: parent
                anchors.margins: currentSizes.settingsPanel?.contentMargins || currentSizes.spacing?.normal || 8
                currentIndex: 0
                
                // General Settings
                GeneralSettings {
                    panelConfig: sharedPanelConfig
                }

                // Appearance Settings
                AppearanceSettings {
                    panelConfig: sharedPanelConfig
                }

                // Wallpapers Settings
                WallpapersSettings {
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
// components/Settings/SettingsPanel.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "."


Rectangle {
    id: settingsPanel
    property var theme : currentTheme
    signal backRequested()
    radius: 12
    color: theme.primary.background
    // Shadow effect
    layer.enabled: true

    RowLayout {
        anchors.fill: parent
        spacing: 20

        
        // Sidebar
        SidebarSettings {
            theme: settingsPanel.theme
            onCategoryChanged: settingsStack.currentIndex = index
            onBackRequested: settingsPanel.backRequested()
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
                }
                
                // Appearance Settings
                AppearanceSettings {
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

// components/Settings/SettingsPanel.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


Rectangle {
    id: settingsPanel
    property var theme
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
                    theme: settingsPanel.theme
                }
                
                // Appearance Settings
                AppearanceSettings {
                    theme: settingsPanel.theme
                }
                
                // Network Settings
                NetworkSettings {
                    theme: settingsPanel.theme
                }
                
                // Audio Settings
                AudioSettings {
                    theme: settingsPanel.theme
                }
                
                // Performance Settings
                PerformanceSettings {
                    theme: settingsPanel.theme
                }
                
                // Shortcuts Settings
                ShortcutsSettings {
                    theme: settingsPanel.theme
                }
                
                // Applications Settings
                ApplicationsSettings {
                    theme: settingsPanel.theme
                }
                
                // System Settings
                SystemSettings {
                    theme: settingsPanel.theme
                }
            }
        }
    }
}

// components/Settings/SettingsPanel.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "."


Rectangle {
    id: settingsPanel
    property var theme : currentTheme
    signal backRequested()
    signal toggleClockPanel()
    signal posClockPanel(string pos)

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
                }
                
                // Appearance Settings
                AppearanceSettings {
                  onToggleClockPanel: settingsPanel.toggleClockPanel()
                  onPosClockPanel: settingsPanel.posClockPanel(pos)
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

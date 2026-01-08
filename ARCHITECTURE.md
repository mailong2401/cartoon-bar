# 🏗️ Cartoon Bar - Project Architecture

This document describes the architecture, structure, and conventions of the Cartoon Bar QuickShell project.

---

## 📁 Directory Structure

```
cartoon-bar/
├── config/                 # Configuration system
│   ├── ConfigLoader.qml   # Main config loader
│   ├── ThemeLoader.qml    # Theme loader
│   ├── LanguageLoader.qml # Language loader
│   ├── SizesLoader.qml    # Size profiles loader
│   ├── configs/           # JSON config files
│   │   └── default.json   # Default configuration
│   ├── themes/            # Theme JSON files
│   │   ├── dark.json      # Catppuccin Mocha (dark theme)
│   │   ├── light.json     # Catppuccin Latte (light theme)
│   │   └── sizes/         # Size profiles for different resolutions
│   │       ├── 1280.json
│   │       ├── 1366.json
│   │       ├── 1440.json
│   │       ├── 1600.json
│   │       ├── 1680.json
│   │       ├── 1920.json  # Full HD (default)
│   │       ├── 2560.json
│   │       ├── 2880.json
│   │       ├── 3440.json
│   │       └── 3840.json  # 4K
│   └── languages/         # 30 language translation files
│       ├── en.json
│       ├── vi.json
│       ├── zh.json
│       └── ... (27 more)
│
├── modules/               # Feature modules
│   ├── panels/           # Panel components
│   │   ├── Bluetooth/   # Bluetooth management (refactored into 5 components)
│   │   │   ├── BluetoothPanel.qml
│   │   │   ├── BluetoothHeader.qml
│   │   │   ├── BluetoothStatusCard.qml
│   │   │   ├── BluetoothDeviceList.qml
│   │   │   └── BluetoothDeviceItem.qml
│   │   ├── Battery/     # Battery monitoring
│   │   │   ├── BatteryPanel.qml
│   │   │   └── BatteryDetailPanel.qml
│   │   ├── Cpu/         # CPU monitoring
│   │   │   ├── CpuDetailPanel.qml
│   │   │   ├── CpuCoresDisplay.qml
│   │   │   ├── CpuStatsOverview.qml
│   │   │   └── CpuUsageChart.qml
│   │   ├── Ram/         # RAM monitoring
│   │   │   ├── RamDetailPanel.qml
│   │   │   ├── RamDisplay.qml
│   │   │   └── RamTaskManager.qml
│   │   ├── Mixer/       # Audio mixer
│   │   │   └── MixerPanel.qml
│   │   ├── Launcher/    # Application launcher
│   │   │   ├── LauncherPanel.qml
│   │   │   └── LauncherList.qml
│   │   ├── WifiPanel/   # WiFi management
│   │   │   └── WifiPanel.qml
│   │   ├── WeatherTime/ # Calendar & time panel
│   │   │   ├── WtDetailPanel.qml
│   │   │   ├── WtDetailHeader.qml
│   │   │   └── WtDetailCalendar.qml
│   │   ├── weather/     # Weather detail components
│   │   │   └── WeatherDetailCard.qml
│   │   ├── AppIcons.qml
│   │   ├── ClockPanel.qml
│   │   ├── CpuPanel.qml
│   │   ├── FlagSelectionPanel.qml
│   │   ├── MainPanel.qml
│   │   ├── MusicPanel.qml
│   │   ├── StatusArea.qml
│   │   ├── Timespace.qml
│   │   ├── WeatherPanel.qml
│   │   └── WorkspacePanel.qml
│   │
│   ├── dialogs/         # Dialog components
│   │   ├── ConfirmDialog.qml
│   │   ├── NotificationPopup.qml
│   │   └── VolumeOsd.qml
│   │
│   └── settings/        # Settings panels
│       ├── SettingsPanel.qml      # Main settings container
│       ├── GeneralSettings.qml    # Language selection
│       ├── AppearanceSettings.qml # Theme, size, position
│       ├── WallpapersSettings.qml # Image/video wallpapers
│       ├── NetworkSettings.qml    # WiFi management
│       ├── AudioSettings.qml      # Audio mixer
│       ├── PerformanceSettings.qml # System monitor
│       ├── ShortcutsSettings.qml  # Keyboard shortcuts
│       ├── SystemSettings.qml     # Power management
│       └── AboutSettings.qml      # About panel
│
├── services/            # Background services
│   ├── CavaService.qml # Audio visualizer service
│   └── JsonEditor.qml  # JSON config file editor
│
├── utils/              # Utility components
│   ├── components/    # Reusable UI components
│   └── loaders/       # Helper loaders
│
├── assets/            # Static resources
│   ├── battery/      # Battery icons
│   ├── cpu/          # CPU icons (cpu_1.png - cpu_10.png)
│   ├── flags/        # Country flags (30+ countries)
│   ├── music/        # Music player icons
│   ├── panel/        # Panel icons
│   ├── settings/     # Settings icons
│   ├── system/       # System icons (power, lock, etc.)
│   ├── volume/       # Volume icons
│   ├── wifi/         # WiFi icons
│   ├── fire.png
│   ├── pie-chart.png
│   └── search.png
│
├── scripts/           # Shell & Python scripts
│   ├── battery_monitor.sh
│   ├── check-network
│   ├── check-playing
│   ├── cpu
│   ├── generate-video-thumbnail.sh
│   ├── listapps.py
│   ├── memory-info.py
│   ├── music-controller
│   ├── ram-usage
│   └── task-manager-ram.py
│
├── screenshot/        # Screenshots for README
│   ├── battery/
│   ├── bluetooth/
│   ├── cpu/
│   ├── menu/
│   ├── mixer/
│   ├── panelMusic/
│   ├── panel_time/
│   ├── ram/
│   ├── volumeOsd/
│   └── wifi/
│
└── shell.qml         # Main entry point
```

---

## 🎯 Architecture Principles

### 1. Modular Design
- **Separation of Concerns**: Each module handles a specific functionality
- **Single Responsibility**: Components do one thing well
- **Reusability**: Components can be used across different panels

### 2. Configuration System
- **Dynamic Loading**: Configs, themes, languages, and sizes loaded at runtime
- **Hot Reload**: Changes to JSON files automatically reload the UI
- **Centralized**: All configuration in `config/` directory

### 3. Component Hierarchy
```
shell.qml (root)
├── Config Loaders (global)
│   ├── ConfigLoader → currentConfig
│   ├── ThemeLoader → currentTheme
│   ├── LanguageLoader → currentLanguage
│   └── SizesLoader → currentSizes
│
├── MainPanel
│   ├── AppIcons
│   ├── WorkspacePanel
│   ├── MusicPanel
│   ├── Timespace
│   ├── CpuPanel
│   └── StatusArea
│
├── Dialogs (floating)
│   ├── VolumeOsd
│   ├── NotificationPopup
│   └── ConfirmDialog
│
└── Detail Panels (on-demand loading)
    ├── LauncherPanel
    ├── SettingsPanel
    ├── BluetoothPanel
    ├── WifiPanel
    ├── MixerPanel
    ├── WeatherPanel
    └── ... (more panels)
```

---

## 📝 Import Patterns

### Path Resolution Rules

Based on directory depth from project root:

#### Root Level (`shell.qml`)
```qml
import "./config" as Config
import "./modules/dialogs" as Dialogs
import "./modules/panels" as Panels
import "./services" as Services
```

#### Level 1 (`modules/panels/*.qml`)
```qml
// Import from other modules
import "../../config" as Config
import "../../services" as Services

// Asset paths
source: "../../assets/icon.png"

// Script paths
command: [Qt.resolvedUrl("../../scripts/script.sh")]
```

#### Level 2 (`modules/panels/Cpu/*.qml`)
```qml
// Import from root
import "../../../config" as Config

// Asset paths
source: "../../../assets/cpu/cpu_1.png"

// Script paths
command: [Qt.resolvedUrl("../../../scripts/cpu")]
```

#### Level 3+ (subdirectories)
For components in deeper directories like `modules/panels/Bluetooth/`:
```qml
// Import sibling components (same directory)
import "." as Components

// Usage
Components.BluetoothHeader { }
Components.BluetoothStatusCard { }
```

### Config Loaders (`config/` directory)
Config loaders use paths **relative to their own directory**:
```qml
// In config/ThemeLoader.qml
Qt.resolvedUrl("themes/" + currentTheme + ".json")

// In config/LanguageLoader.qml
Qt.resolvedUrl("languages/" + currentLanguage + ".json")

// In config/SizesLoader.qml
Qt.resolvedUrl("themes/sizes/" + currentSizeProfile + ".json")
```

---

## 🌐 Global Properties

These properties are available throughout the application:

### From Config Loaders
- `currentConfig` - Main configuration object
- `currentTheme` - Current theme colors
- `currentLanguage` - Current language strings
- `currentSizes` - Size profile for current resolution

### Common Usage
```qml
Rectangle {
    color: currentTheme.primary.background

    Text {
        text: currentLanguage.settings.title
        font.pixelSize: currentSizes.fontSize.medium
    }
}
```

---

## 🎨 Naming Conventions

### File Names
- **PascalCase**: All QML files (e.g., `BluetoothPanel.qml`, `CpuCoresDisplay.qml`)
- **kebab-case**: Scripts (e.g., `check-network`, `music-controller`)
- **snake_case**: Python scripts (e.g., `memory-info.py`, `task-manager-ram.py`)
- **lowercase**: JSON files (e.g., `default.json`, `dark.json`)

### Component IDs
- **camelCase**: Component IDs (e.g., `musicPanel`, `cpuCoresDisplay`)
- Descriptive and unique within file

### Properties
- **camelCase**: Property names (e.g., `currentTheme`, `isConnected`)
- Boolean properties: prefix with `is`, `has`, `can` (e.g., `isLoading`, `hasError`)

---

## 🔄 Data Flow

### 1. Configuration Loading
```
shell.qml starts
    ↓
Config loaders initialize
    ↓
Load JSON files (config, theme, language, sizes)
    ↓
Properties available globally (currentConfig, currentTheme, etc.)
    ↓
Components use global properties
```

### 2. User Interaction
```
User clicks → Panel opens → Loader activates → Component loads → Actions execute
```

### 3. Settings Changes
```
User changes setting
    ↓
JsonEditor updates JSON file
    ↓
Loader detects file change
    ↓
Reload JSON content
    ↓
UI automatically updates (property bindings)
```

---

## 🧩 Component Patterns

### Panel Pattern
```qml
// Standard panel structure
PanelWindow {
    id: root

    // Size from global config
    implicitWidth: currentSizes.panelName.width || 400
    implicitHeight: currentSizes.panelName.height || 600

    // Properties
    property var sizes: currentSizes.panelName || {}
    property var theme: currentTheme
    property var lang: currentLanguage

    // Main container
    Rectangle {
        anchors.fill: parent
        color: theme.primary.background
        radius: sizes.radius || 16

        // Content layout
        ColumnLayout {
            anchors.fill: parent
            // Components...
        }
    }
}
```

### Settings Pattern
```qml
// Settings section structure
Rectangle {
    property var theme: currentTheme
    property var lang: currentLanguage
    property var sizes: currentSizes.settingsPanel || {}

    ScrollView {
        ColumnLayout {
            // Setting items
            Text {
                text: lang.settings.sectionName
                color: theme.primary.foreground
            }
        }
    }
}
```

### Service Pattern
```qml
// Background service structure
QtObject {
    id: service

    property bool isRunning: false
    property var data: null

    signal dataUpdated()

    function start() { }
    function stop() { }

    Component.onCompleted: {
        start()
    }
}
```

---

## 📦 Component Breakdown Example: Bluetooth Panel

The Bluetooth panel demonstrates good component architecture:

### Before Refactoring
- `BluetoothPanel.qml` - 695 lines (monolithic)

### After Refactoring
- `BluetoothPanel.qml` - 221 lines (main container)
  - Imports sub-components with `import "." as Components`
  - Handles state management and device scanning

- `BluetoothHeader.qml` - 122 lines
  - Bluetooth icon, title, scan button
  - Scanning animation

- `BluetoothStatusCard.qml` - 94 lines
  - Connection status display
  - Toggle switch for Bluetooth on/off

- `BluetoothDeviceList.qml` - 73 lines
  - ScrollView with ListView
  - Empty state messaging

- `BluetoothDeviceItem.qml` - 240 lines
  - Individual device representation
  - Connect/disconnect buttons
  - Pairing functionality

**Benefits:**
- 66% reduction in main file size
- Each component has single responsibility
- Easier to test and maintain
- Components can be reused

---

## 🔍 Best Practices

### 1. Use Global Properties
```qml
// Good - Use global properties
color: currentTheme.primary.background
text: currentLanguage.settings.title

// Bad - Hardcode values
color: "#24273a"
text: "Settings"
```

### 2. Provide Fallback Values
```qml
// Good - Fallback for missing size config
width: sizes.buttonWidth || 100
height: currentSizes.panel?.headerHeight || 60

// Bad - No fallback
width: sizes.buttonWidth  // Can be undefined
```

### 3. Optional Chaining for Nested Properties
```qml
// Good - Safe property access
visible: adapter?.enabled || false
text: lang?.settings?.title || "Settings"

// Bad - Can crash if property doesn't exist
visible: adapter.enabled
```

### 4. Consistent Path Resolution
```qml
// Good - Use Qt.resolvedUrl for dynamic paths
Qt.resolvedUrl("../../scripts/" + scriptName)

// Bad - String concatenation only (doesn't resolve correctly)
"../../scripts/" + scriptName
```

### 5. Component Composition
```qml
// Good - Break down into smaller components
Components.BluetoothHeader { }
Components.BluetoothStatusCard { }
Components.BluetoothDeviceList { }

// Bad - Everything in one file (700+ lines)
```

---

## 🔧 Adding New Features

### Adding a New Panel

1. **Create panel file** in `modules/panels/`
2. **Follow naming convention**: `PanelName.qml` (PascalCase)
3. **Add size configuration** to all size JSON files in `config/themes/sizes/`
4. **Add language strings** to all language files in `config/languages/`
5. **Update imports** if needed
6. **Add to appropriate launcher** (StatusArea, AppIcons, etc.)

### Adding a New Language

1. **Copy** `config/languages/en.json` to `config/languages/xx.json`
2. **Translate** all strings
3. **Add to GeneralSettings.qml** language list
4. **Add flag icon** to `assets/flags/xx.png`

### Adding a New Theme

1. **Create** `config/themes/themename.json`
2. **Define color palette** (follow existing structure)
3. **Add to AppearanceSettings.qml** theme list
4. **Test** with both light and dark backgrounds

---

## 📊 Performance Considerations

### Lazy Loading
- Use `Loader` with `active` property for on-demand panels
- Example: Settings, Launcher, Detail panels

### Asset Optimization
- Use appropriate image sizes (sourceSize property)
- Cache video thumbnails in `~/.cache/quickshell/thumbnails/`

### Process Management
- Stop unnecessary background processes when panels close
- Use `Process.running = false` to terminate

### Memory Management
- Unload panels when not visible (`active: panelVisible`)
- Clear large data structures when no longer needed

---

## 🧪 Testing Checklist

When making changes, test:
- [ ] At least 2 different size profiles (1920, 2560)
- [ ] Both dark and light themes
- [ ] At least 2 languages (en, vi)
- [ ] Panel position: top and bottom
- [ ] All paths resolve correctly (no broken images/scripts)
- [ ] No console errors in QuickShell output

---

## 📚 Additional Resources

- **QuickShell Documentation**: https://quickshell.outfoxxed.me/
- **QML Documentation**: https://doc.qt.io/qt-6/qmlapplications.html
- **Hyprland Wiki**: https://wiki.hyprland.org/
- **Catppuccin Theme**: https://github.com/catppuccin/catppuccin

---

<div align="center">

**Happy coding!** 🚀

Made with ❤️ and QML

</div>

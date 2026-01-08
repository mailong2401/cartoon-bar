# Project Architecture

This QuickShell project follows a standard modular architecture for better organization and maintainability.

## Directory Structure

```
cartoon-bar/
├── config/                 # Configuration and settings
│   ├── configs/           # JSON configuration files
│   ├── languages/         # i18n translation files (30 languages)
│   ├── themes/            # Theme definitions and size profiles
│   ├── ConfigLoader.qml   # Config file loader
│   ├── LanguageLoader.qml # Language file loader
│   ├── SizesLoader.qml    # Size profile loader
│   └── ThemeLoader.qml    # Theme loader
│
├── modules/               # Feature modules (UI components)
│   ├── dialogs/          # Popup dialogs
│   │   ├── ConfirmDialog.qml
│   │   ├── NotificationPopup.qml
│   │   └── VolumeOsd.qml
│   │
│   ├── panels/           # Main UI panels
│   │   ├── AppIcons.qml
│   │   ├── Battery/      # Battery monitoring panel
│   │   ├── Bluetooth/    # Bluetooth management
│   │   ├── ClockPanel.qml
│   │   ├── Cpu/          # CPU monitoring panel
│   │   ├── CpuPanel.qml
│   │   ├── FlagSelectionPanel.qml
│   │   ├── Launcher/     # Application launcher
│   │   ├── Mixer/        # Audio mixer
│   │   ├── MusicPanel.qml
│   │   ├── MusicPlayer.qml
│   │   ├── Ram/          # RAM monitoring panel
│   │   ├── StatusArea.qml
│   │   ├── Timespace.qml
│   │   ├── weather/      # Weather components
│   │   ├── WeatherPanel.qml
│   │   ├── WeatherTime/  # Weather and time panel
│   │   ├── WifiPanel/    # WiFi management
│   │   └── WorkspacePanel.qml
│   │
│   └── settings/         # Settings UI
│       ├── AppearanceSettings.qml
│       ├── AudioSettings.qml
│       ├── GeneralSettings.qml
│       ├── NetworkSettings.qml
│       ├── PerformanceSettings.qml
│       ├── SettingsPanel.qml
│       ├── ShortcutsSettings.qml
│       ├── SidebarSettings.qml
│       ├── SystemSettings.qml
│       └── WallpapersSettings.qml
│
├── services/              # Background services
│   ├── CavaService.qml   # Audio visualization service
│   └── JsonEditor.qml    # JSON file editor service
│
├── utils/                 # Utility components and helpers
│   ├── components/       # Reusable UI components
│   │   └── CustomComboBox.qml
│   └── loaders/          # (Reserved for future loaders)
│
├── assets/               # Static assets (images, icons)
├── scripts/              # Shell scripts and Python utilities
└── shell.qml            # Main entry point

```

## Import Patterns

### From shell.qml (root)
```qml
import "./config" as Config
import "./modules/dialogs" as Dialogs
import "./modules/panels" as Panels

Config.ThemeLoader { id: themeLoader }
Dialogs.ConfirmDialog { id: confirmDialog }
Panels.StatusArea { }
```

### From modules/panels/ (one level deep)
```qml
import "../../config" as Config
import "../../services" as Services

// Asset paths: "../../assets/..."
// Script paths: Qt.resolvedUrl("../../scripts/...")
// Config files: Qt.resolvedUrl("../../config/configs/...")
```

### From modules/panels/Cpu/ (two levels deep)
```qml
// Asset paths: "../../../assets/..."
// Script paths: Qt.resolvedUrl("../../../scripts/...")
```

## Key Design Principles

1. **Separation of Concerns**: Each directory has a clear, single responsibility
2. **Modularity**: Features are isolated in their own modules
3. **Configurability**: All settings centralized in config/
4. **Reusability**: Common components in utils/
5. **Service Layer**: Background processes separated into services/

## File Naming Conventions

- **Panels**: `[Feature]Panel.qml` (e.g., `CpuPanel.qml`)
- **Dialogs**: `[Feature]Dialog.qml` or `[Feature]Popup.qml`
- **Loaders**: `[Resource]Loader.qml` (e.g., `ThemeLoader.qml`)
- **Services**: `[Feature]Service.qml` (e.g., `CavaService.qml`)

## Adding New Features

1. **New Panel**: Add to `modules/panels/`
2. **New Dialog**: Add to `modules/dialogs/`
3. **New Settings Page**: Add to `modules/settings/`
4. **New Service**: Add to `services/`
5. **New Utility**: Add to `utils/components/`

## Migration Notes

This structure was migrated from the previous flat `components/` directory. All import paths have been updated to reflect the new hierarchy. If you encounter any import errors, ensure paths are relative to the file's location in the new structure.

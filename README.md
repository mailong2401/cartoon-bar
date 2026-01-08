# 🎨 Cartoon Bar - QuickShell Panel for Hyprland

<div align="center">

[Cartoon Bar Screenshot](https://github.com/user-attachments/assets/5d26eb04-14fa-42c2-a8a8-3d8ddafc04c7)

*A modern, feature-rich Wayland panel built with QuickShell for Hyprland*

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Hyprland](https://img.shields.io/badge/Hyprland-Compatible-blue)](https://hyprland.org/)
[![QuickShell](https://img.shields.io/badge/QuickShell-Wayland-green)](https://github.com/outfoxxed/quickshell)

</div>

---

## 📋 Table of Contents

- [Introduction](#-introduction)
- [Features](#-features)
- [Screenshots](#-screenshots)
- [System Requirements](#-system-requirements)
- [Installation](#-installation)
- [Configuration](#-configuration)
- [Project Architecture](#-project-architecture)
- [Components](#-components)
- [Theme & Language](#-theme--language)
- [Shortcuts](#-shortcuts)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🎯 Introduction

**Cartoon Bar** is a modern Wayland panel built entirely with **QuickShell** (QML) specifically for **Hyprland window manager**. The panel provides a smooth user experience with highly customizable interface, multi-language support, and multi-resolution display compatibility.

### ✨ Highlights

- 🎨 **2 Themes**: Dark (Catppuccin Mocha) and Light (Catppuccin Latte)
- 🌍 **30 Languages**: Full multi-language support across the globe
- 📐 **10 Size Profiles**: Support from HD (1280px) to 4K (3840px)
- 🎥 **Video Wallpaper**: Support both image and video wallpapers (mp4, mkv, webm, gif)
- ⚡ **Real-time Updates**: Workspace tracking, Music player, Weather, System stats
- 🔧 **Settings Panel**: Complete configuration interface without file editing
- 🎵 **Media Control**: Integrated playerctl for Spotify/MPD
- 🌦️ **Weather Widget**: Real-time weather API
- 💻 **System Monitor**: CPU, RAM, Network, Battery tracking

---

## 📸 Screenshots

### Menu & Settings

| Launcher | Settings Panel |
|:--------:|:--------------:|
| ![Launcher](screenshot/menu/screenshot_Launcher.png) | ![Settings 1](screenshot/menu/screenshot_setting1.png) |

| Settings Panel (cont.) | Confirm Dialog |
|:----------------------:|:--------------:|
| ![Settings 2](screenshot/menu/screenshot_setting2.png) | ![Confirm Dialog](screenshot/menu/screenshot_ConfirmDialog1.png) |

| Confirm Dialog (cont.) |
|:----------------------:|
| ![Confirm Dialog 2](screenshot/menu/screenshot_ConfirmDialog2.png) |

### System Status Panels

| CPU Panel | RAM Panel |
|:---------:|:---------:|
| ![CPU](screenshot/cpu/screenshot_panel_cpu.png) | ![RAM](screenshot/ram/screenshot_panel_ram.png) |

| Battery Panel | Battery Panel (cont.) |
|:-------------:|:---------------------:|
| ![Battery 1](screenshot/battery/screenshot_panel_battery_1.png) | ![Battery 2](screenshot/battery/screenshot_panel_battery_2.png) |

### Music Panel

| Music Panel |
|:-----------:|
| ![Music Panel](screenshot/panelMusic/screenshot_panel_music.png) |

### Network & Connectivity

| WiFi Panel | WiFi Panel (cont.) |
|:----------:|:------------------:|
| ![WiFi 1](screenshot/wifi/screenshot_panel_wifi_1.png) | ![WiFi 2](screenshot/wifi/screenshot_panel_wifi_2.png) |

| Bluetooth Panel | Bluetooth Panel (cont.) |
|:---------------:|:-----------------------:|
| ![Bluetooth 1](screenshot/bluetooth/screenshot_2026-01-06_06-36-52.png) | ![Bluetooth 2](screenshot/bluetooth/screenshot_2026-01-06_06-37-01.png) |

### Audio

| Mixer Panel |
|:-----------:|
| ![Mixer](screenshot/mixer/screenshot_panel_mixer.png) |

### Time & Calendar

| Calendar | Country Flag Selection |
|:--------:|:----------------------:|
| ![Calendar](screenshot/panel_time/screenshot_calendar.png) | ![Flag Selection](screenshot/panel_time/screenshot_select_flag.png) |

### Volume OSD

| Volume OSD |
|:----------:|
| ![Volume OSD](screenshot/volumeOsd/volume_osd.gif) |

---

## 🚀 Features

### Main Panel Components

| Component | Function | Technology |
|-----------|----------|------------|
| **🎯 App Icons** | Quick launcher (dashboard) | Click to open LauncherPanel |
| **🖥️ Workspace Panel** | Display workspace 1-10 | Hyprland socket real-time |
| **🎵 Music Player** | Media control | playerctl (Spotify/MPD) |
| **⏰ Timespace** | Time, weather, country flag | weatherapi.com |
| **📊 CPU Panel** | CPU & RAM usage | top/free commands |
| **📡 Status Area** | WiFi, Bluetooth, Audio, Battery | NetworkManager, PipeWire |

### Clock Panel (Floating)

- ⏰ Large clock displaying hours, minutes, date, month
- 📍 9 positions: top, bottom, left, right, topLeft, topRight, bottomLeft, bottomRight, center
- 🎨 Font: ComicShannsMono Nerd Font
- ⚙️ Can be toggled from Settings

### Settings Panel (9 Sections)

1. **General** - Language selection (30 languages with country flags)
2. **Appearance** - Theme, screen size, panel position
3. **Wallpapers** - Image & Video wallpaper management with thumbnail preview
4. **Network** - WiFi scanning, connection, password
5. **Audio** - PipeWire mixer, volume control
6. **Performance** - System monitor, CPU/RAM details
7. **Shortcuts** - System shortcuts
8. **System** - Power management (sleep, lock, logout, restart, shutdown)
9. **About** - Project information

### Additional Features

- 🔔 **Notification Popup**: System notifications
- 🔊 **Volume OSD**: Volume change display
- ✅ **Confirm Dialog**: Important action confirmation
- 🔍 **App Launcher**: Search and launch applications
- 📶 **WiFi Panel**: Scan and connect to WiFi networks
- 🔵 **Bluetooth Panel**: Manage Bluetooth devices
- 🎛️ **Mixer Panel**: Detailed audio management (PipeWire)
- 🔋 **Battery Panel**: Detailed battery information
- 🌡️ **Weather Detail**: Extended weather panel

---

## 💻 System Requirements

### Operating System
- **Linux** (developed on Arch Linux)
- **Wayland** compositor (X11 not supported)
- **Hyprland** window manager (required)

### Main Dependencies

#### QuickShell & Qt
```bash
# QuickShell framework
quickshell

# Qt modules (usually bundled with QuickShell)
qt6-base
qt6-declarative
qt6-wayland
```

#### System utilities
```bash
# Hyprland
hyprland
hyprctl               # Hyprland control

# Wallpaper (choose one or both)
swww                  # Image wallpaper daemon
mpvpaper              # Video wallpaper support
ffmpeg                # Video thumbnail generation

# Media player
playerctl             # MPRIS media control
cava                  # Audio visualizer for Music Panel

# Network
networkmanager        # WiFi/Network management
nmcli                 # NetworkManager CLI
bluez                 # Bluetooth
bluez-utils           # Bluetooth utilities

# System monitoring
procps-ng             # top, free commands
iproute2              # ip command
iputils               # ping command

# Audio
pipewire              # Audio server
wireplumber           # PipeWire session manager

# System control
systemd               # System management

# Other
curl                  # API calls (weather)
jq                    # JSON processing (optional)
python3               # Python scripts
```

#### Font
```bash
# Nerd Font (required for icons)
ttf-comicshannsmono-nerd  # or similar name in your distro
```

### Weather API
- **weatherapi.com** API key (free: 1M calls/month)
- Sign up at: https://www.weatherapi.com/signup.aspx

---

## 🔧 Installation

### 1. Install dependencies (Arch Linux)

#### Full setup with dotfiles
```bash
cd ~
git clone https://github.com/mailong2401/dotfiles-hyprland
cd dotfiles-hyprland
chmod +x setup.sh
./setup.sh
```

#### Or manual installation
```bash
# Install main packages
sudo pacman -S hyprland quickshell playerctl networkmanager \
               bluez bluez-utils pipewire wireplumber curl python cava \
               swww mpvpaper ffmpeg

# Install Nerd Font
yay -S ttf-comicshannsmono-nerd
# or
sudo pacman -S ttf-nerd-fonts-symbols-mono
```

### 2. Clone Cartoon Bar
```bash
# Clone to QuickShell config directory
git clone git@github.com:mailong2401/cartoon-bar.git \
    ~/.config/quickshell/cartoon-bar

cd ~/.config/quickshell/cartoon-bar
```

### 3. Configure Weather API (Optional)
```bash
# Edit config file
nano configs/default.json

# Change:
{
  "weatherApiKey": "YOUR_API_KEY_HERE",
  "weatherLocation": "Your City,Country"
}
```

### 4. Run QuickShell
```bash
# Run directly
export QML_XHR_ALLOW_FILE_READ=1 && quickshell --path ~/.config/quickshell/cartoon-bar

# Or add to Hyprland config
echo "exec-once = export QML_XHR_ALLOW_FILE_READ=1 && quickshell --path ~/.config/quickshell/cartoon-bar" \
    >> ~/.config/hypr/hyprland.conf
```

### 5. Grant permissions to scripts
```bash
cd ~/.config/quickshell/cartoon-bar/scripts
chmod +x *.sh *.py music-controller check-playing
```

---

## ⚙️ Configuration

### Main configuration file: `configs/default.json`

```json
{
  "mainPanelPos": "top",              // Panel position: "top" | "bottom"
  "clockPanelPosition": "bottomRight", // Clock position: 9 options
  "clockPanelVisible": true,          // Show clock panel
  "spacingPanel": 12,                 // Spacing between components (px)

  "lang": "vi",                       // Language: vi, en, zh, ja, kr, etc.
  "theme": "dark",                    // Theme: "dark" | "light"
  "displaySize": "1920",              // Size: 1280-3840

  "countryFlag": "korea",             // Flag to display
  "weatherApiKey": "...",             // Weather API key
  "weatherLocation": "Ho Chi Minh City,Vietnam"
}
```

### Changing config

#### Method 1: Via Settings Panel (Recommended)
1. Click on **App Icons** (left corner of panel)
2. Click **Settings** button (⚙️)
3. Select corresponding tab and make changes
4. Config auto-saves and reloads

#### Method 2: Edit file directly
```bash
# Edit config
nano ~/.config/quickshell/cartoon-bar/configs/default.json

# QuickShell will auto-reload (if running)
```

### Clock Panel positions
```
topLeft      top      topRight
left        center       right
bottomLeft  bottom  bottomRight
```

### Available Languages (30)

**Asia-Pacific:**
- `vi` - Tiếng Việt (Vietnamese)
- `zh` - 中文 (Chinese)
- `ja` - 日本語 (Japanese)
- `kr` - 한국어 (Korean)
- `hi` - हिन्दी (Hindi)
- `th` - ไทย (Thai)
- `id` - Bahasa Indonesia (Indonesian)

**Europe:**
- `en` - English
- `de` - Deutsch (German)
- `fr` - Français (French)
- `es` - Español (Spanish)
- `it` - Italiano (Italian)
- `pt` - Português (Portuguese)
- `ru` - Русский (Russian)
- `uk` - Українська (Ukrainian)
- `pl` - Polski (Polish)
- `nl` - Nederlands (Dutch)
- `sv` - Svenska (Swedish)
- `no` - Norsk (Norwegian)
- `da` - Dansk (Danish)
- `fi` - Suomi (Finnish)
- `cs` - Čeština (Czech)
- `sk` - Slovenčina (Slovak)
- `hu` - Magyar (Hungarian)
- `ro` - Română (Romanian)
- `bg` - Български (Bulgarian)
- `el` - Ελληνικά (Greek)

**Middle East:**
- `ar` - العربية (Arabic)
- `tr` - Türkçe (Turkish)
- `he` - עברית (Hebrew)

### Available Display Sizes
- **1280** - HD (1280×720)
- **1366** - WXGA (1366×768)
- **1440** - WXGA+ (1440×900)
- **1600** - HD+ (1600×900)
- **1680** - WSXGA+ (1680×1050)
- **1920** - Full HD (1920×1080) *default*
- **2560** - 2K/QHD (2560×1440)
- **2880** - 3K (2880×1620)
- **3440** - UW-QHD (3440×1440)
- **3840** - 4K/UHD (3840×2160)

---

## 🏗️ Project Architecture

The project follows a modular architecture with clear separation of concerns:

```
cartoon-bar/
├── config/         # Configuration and settings (themes, languages, sizes)
├── modules/        # Feature modules (panels, dialogs, settings)
├── services/       # Background services (audio, JSON editor)
├── utils/          # Utility components and helpers
├── assets/         # Static assets (images, icons)
├── scripts/        # Shell scripts and Python utilities
└── shell.qml       # Main entry point
```

For detailed information about the project structure, import patterns, and conventions, see [ARCHITECTURE.md](ARCHITECTURE.md).

---

## 🧩 Components

### WorkspacePanel
- Display workspace 1-10 from Hyprland
- **Icons**:
  - 🟡 Pac-Man - Current workspace
  - 👻 Ghost - Created but empty workspace
  - ⚪ Empty - Not yet created workspace
- Click to switch workspace
- Real-time tracking via Hyprland socket

### MusicPlayer
- Support: Spotify, MPD, VLC, Firefox, etc. (MPRIS compatible)
- Display: Artist - Song title (marquee scrolling)
- Controls: Previous, Play/Pause, Next
- Updates every 1 second
- Scripts: `music-controller`, `check-playing`
- **Music Panel** (click on song info):
  - Album art display
  - Song title & artist
  - Progress bar with time
  - Playback controls
  - **Cava audio visualizer** with theme colors

### Timespace Widget
- **⏰ Clock**: Display HH:MM
- **🌦️ Weather**:
  - Current temperature
  - Humidity, feels like
  - Weather icon
  - Requires Weather API key
- **🏳️ Country Flag**: Select from list

### Status Area
- **📶 WiFi**: Signal, connection, network scanning
- **🔵 Bluetooth**: Devices, connection
- **🎛️ Mixer**: Volume, audio devices
- **🔋 Battery**: %, charging/discharging status

### CPU & RAM Panel
- **CPU**: % usage from `top`
- **RAM**: % usage from `free`
- Click to open detail panel:
  - CPU cores usage
  - Temperature (if available)
  - RAM: used/total
  - Swap usage

### LauncherPanel
- Search installed applications
- List from `/usr/share/applications/`
- Sidebar categories
- Script: `listapps.py`

---

## 🎨 Theme & Language

### Theme Structure

#### Dark Theme (Catppuccin Mocha)
```json
{
  "type": "dark",
  "primary": {
    "background": "#24273a",      // Main background
    "dim_background": "#1e2030",  // Darker background
    "foreground": "#cad3f5",      // Main text
    "dim_foreground": "#8087a2"   // Dimmed text
  },
  "button": {
    "background": "#363a4f",
    "background_select": "#494d64",
    "border": "#5b6078",
    "border_select": "#8aadf4"
  },
  "normal": {
    "black": "#24273a",
    "red": "#ed8796",
    "green": "#a6da95",
    "yellow": "#eed49f",
    "blue": "#8aadf4",
    "magenta": "#f5bde6",
    "cyan": "#8bd5ca",
    "white": "#cad3f5"
  }
}
```

#### Light Theme (Catppuccin Latte)
- Light background: `#f5eee6`
- Text: `#2b2530`
- Similar structure with inverted colors

### Language Structure
```json
{
  "settings": {
    "title": "Settings",
    "general": "General",
    "appearance": "Appearance",
    // ...
  },
  "dateFormat": {
    "day": { "0": "Sun", "1": "Mon", ... },
    "month": { "1": "Jan", "2": "Feb", ... }
  },
  "general": { ... },
  "appearance": { ... },
  "system": { ... }
}
```

### Wallpaper Management

The wallpaper settings support both **images** and **videos**:

#### Supported Formats
- **Images**: `.jpg`, `.jpeg`, `.png`, `.bmp`, `.webp`
- **Videos**: `.mp4`, `.mkv`, `.webm`, `.gif`

#### Features
- 🖼️ **Thumbnail Preview**: Automatic thumbnail generation for videos using ffmpeg
- 📁 **Auto-scan**: Automatically scans `~/Pictures/Wallpapers/` folder
- 🎬 **Video Playback**: Smooth video wallpaper with mpvpaper
- 🌊 **Transition Effects**:
  - Videos: Fade-in with hardware acceleration
  - Images: Grow transition with swww
- 💾 **Smart Switching**: Automatically stops video when switching to image (and vice versa)
- 🗂️ **Thumbnail Cache**: Video thumbnails cached at `~/.cache/quickshell/thumbnails/`

#### Usage
1. Place your wallpapers in `~/Pictures/Wallpapers/`
2. Open Settings → Wallpapers
3. Click on any image/video to set as wallpaper
4. Video files show ▶ badge, images show 🖼️
5. Current wallpaper shows ✓ badge

### Adding new language
1. Copy `languages/en.json` → `languages/xx.json`
2. Translate all strings
3. Add to `components/Settings/GeneralSettings.qml` language list with country flag
4. Add corresponding flag image to `assets/flags/`

---

## ⌨️ Shortcuts

### Hyprland Keybindings (`$mainMod = SUPER`)

#### Basic
| Key | Action |
|-----|--------|
| `SUPER + RETURN` | Open terminal (kitty) |
| `SUPER + Q` | Close current window |
| `SUPER + M` | Exit Hyprland |
| `SUPER + E` | Open file manager (thunar) |
| `SUPER + SPACE` | Open app launcher (wofi) |
| `SUPER + V` | Toggle floating window |
| `SUPER + P` | Toggle pseudotiling |
| `SUPER + J` | Toggle split layout |

#### Window movement
| Key | Action |
|-----|--------|
| `SUPER + ← ↑ → ↓` | Move focus |
| `SUPER + [1-0]` | Switch workspace 1-10 |
| `SUPER + SHIFT + [1-0]` | Move window to workspace |

#### Special workspace
| Key | Action |
|-----|--------|
| `SUPER + S` | Toggle workspace `magic` |
| `SUPER + SHIFT + S` | Move to `special:magic` |

#### Mouse
| Action | Description |
|--------|-------------|
| `SUPER + Drag Left` | Move window |
| `SUPER + Drag Right` | Resize window |
| `SUPER + Scroll` | Switch workspace |

---

## 🔍 Troubleshooting

### Panel not displaying
```bash
# Check if QuickShell is running
ps aux | grep quickshell

# View logs
quickshell -c ~/.config/quickshell/cartoon-bar/shell.qml

# Check Hyprland socket
ls -la /tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock
```

### Music Player not working
```bash
# Check playerctl
playerctl status

# Check MPRIS players
playerctl -l

# Test script
~/.config/quickshell/cartoon-bar/scripts/check-playing
```

### Weather not loading
```bash
# Test API key
curl "https://api.weatherapi.com/v1/current.json?key=YOUR_KEY&q=London"

# Check config
cat ~/.config/quickshell/cartoon-bar/configs/default.json | grep weather
```

### WiFi Panel not scanning
```bash
# Check NetworkManager
systemctl status NetworkManager

# Test nmcli
nmcli device wifi list
```

### Font icons not displaying
```bash
# Install Nerd Font
yay -S ttf-comicshannsmono-nerd

# Rebuild font cache
fc-cache -fv

# Check font
fc-list | grep -i comic
```

---

## 🤝 Contributing

We welcome all contributions! Please:

1. **Fork** this repository
2. Create a **feature branch**:
   ```bash
   git checkout -b feature/AmazingFeature
   ```
3. **Commit** changes:
   ```bash
   git commit -m 'Add some AmazingFeature'
   ```
4. **Push** to branch:
   ```bash
   git push origin feature/AmazingFeature
   ```
5. Open a **Pull Request**

### Development Guidelines
- Code according to QML standards (4 spaces indent)
- Clear comments (English or Vietnamese)
- Test on at least 2 size profiles
- Update README if adding new features

---

## 🙏 Credits

- **QuickShell** - [outfoxxed/quickshell](https://github.com/outfoxxed/quickshell)
- **Hyprland** - [hyprwm/Hyprland](https://github.com/hyprwm/Hyprland)
- **Catppuccin Theme** - [catppuccin/catppuccin](https://github.com/catppuccin/catppuccin)
- **Weather API** - [weatherapi.com](https://www.weatherapi.com/)
- **Nerd Fonts** - [ryanoasis/nerd-fonts](https://github.com/ryanoasis/nerd-fonts)

---

## 📞 Contact

- **Author**: Mai Long
- **GitHub**: [@mailong2401](https://github.com/mailong2401)
- **Repository**: [cartoon-bar](https://github.com/mailong2401/cartoon-bar)
- **Dotfiles**: [dotfiles-hyprland](https://github.com/mailong2401/dotfiles-hyprland)

---

<div align="center">

**Enjoy watching cartoons!** 🎉

Made with ❤️ and QML

</div>

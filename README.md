# 🎨 Cartoon Bar - QuickShell Panel for Hyprland

<div align="center">

[Cartoon Bar Screenshot](https://github.com/user-attachments/assets/5d26eb04-14fa-42c2-a8a8-3d8ddafc04c7)

*A modern, feature-rich Wayland panel built with QuickShell for Hyprland*

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Hyprland](https://img.shields.io/badge/Hyprland-Compatible-blue)](https://hyprland.org/)
[![QuickShell](https://img.shields.io/badge/QuickShell-Wayland-green)](https://github.com/outfoxxed/quickshell)

</div>

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


### Weather Panel
| Weather Panel |
|:-----------:|
| ![Weather Panel](screenshot/weather/screenshot_weather_panel.png)|

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
git clone git@github.com:mailong2401/cartoon-shell.git \
    ~/.config/quickshell/cartoon-shell

cd ~/.config/quickshell/cartoon-shell
```

### 3. Configure Weather API (Optional)
```bash
# Edit config file
nano config/configs/default.json

# Change:
{
  "weatherApiKey": "YOUR_API_KEY_HERE",
  "weatherLocation": "Your City,Country"
}
```

### 4. Run QuickShell
```bash
# Run directly
export QML_XHR_ALLOW_FILE_READ=1 && quickshell --path ~/.config/quickshell/cartoon-shell

# Or add to Hyprland config
echo "exec-once = export QML_XHR_ALLOW_FILE_READ=1 && quickshell --path ~/.config/quickshell/cartoon-shell" \
    >> ~/.config/hypr/hyprland.conf
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


### Wallpaper Management

The wallpaper settings support both **images** and **videos**:

#### Supported Formats
- **Images**: `.jpg`, `.jpeg`, `.png`, `.bmp`, `.webp`
- **Videos**: `.mp4`, `.mkv`, `.webm`, `.gif`


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


### Font icons not displaying
```bash
# Install Nerd Font
yay -S ttf-comicshannsmono-nerd

# Rebuild font cache
fc-cache -fv

# Check font
fc-list | grep -i comic
```


<div align="center">

**Enjoy watching cartoons!** 🎉

Made with ❤️ and QML

</div>

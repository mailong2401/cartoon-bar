#!/usr/bin/env python3
"""
listapps_with_icons.py - optimized with full icon paths

Features:
- Parse only keys under [Desktop Entry]
- Clean Exec field and parse with shlex
- Provide execBase for better de-dup/selection
- Prefer normal launchers over special entries
- Cache results for speed
- Filter by query (search name/exec/comment/icon)
- Enhanced icon finding with multiple fallbacks
"""
import os
import sys
import json
import hashlib
import pickle
import time
import shlex
import re
from pathlib import Path

CACHE_FILE = Path.home() / ".cache" / "listapps_icons_cache.pkl"
CACHE_FILE.parent.mkdir(parents=True, exist_ok=True)

DESKTOP_DIRS = [
    "/usr/share/applications",
    "/usr/local/share/applications",
    "/var/lib/flatpak/exports/share/applications/",
    os.path.expanduser("~/.local/share/applications")
]

# Expanded icon directories with better search order
ICON_DIRS = [
    "/usr/share/icons/Adwaita",
    "/usr/share/icons/breeze",
    "/usr/share/icons/Papirus",
    "/usr/share/icons/oxygen",
    "/usr/share/icons/gnome",
    "/usr/share/icons/elementary",
    "/usr/share/icons/ubuntu-mono-dark",
    "/usr/share/icons/ubuntu-mono-light",
    "/usr/share/pixmaps",
    os.path.expanduser("~/.local/share/icons"),
    os.path.expanduser("~/.icons")
]

# Common icon sizes to check
ICON_SIZES = ['512x512', '256x256', '128x128', '96x96', '64x64', '48x48', '32x32', '24x24', '22x22', '16x16', 'scalable']

FIELD_CODE_RE = re.compile(r"%[fFuUdDinkcmv]")  # common desktop file field codes

def get_cache_key():
    timestamps = []
    for directory in DESKTOP_DIRS:
        path = Path(directory)
        if path.exists():
            try:
                timestamps.append(str(path.stat().st_mtime))
            except:
                pass
    return hashlib.md5(''.join(timestamps).encode()).hexdigest()

def load_cache():
    if CACHE_FILE.exists():
        try:
            with open(CACHE_FILE, 'rb') as f:
                cache_data = pickle.load(f)
                if cache_data.get('key') == get_cache_key():
                    return cache_data.get('apps', [])
        except:
            pass
    return None

def save_cache(apps):
    try:
        cache_data = {
            'key': get_cache_key(),
            'apps': apps,
            'timestamp': time.time()
        }
        with open(CACHE_FILE, 'wb') as f:
            pickle.dump(cache_data, f)
    except:
        pass

def find_icon_comprehensive(icon_name):
    """
    Comprehensive icon search with multiple fallbacks
    Returns absolute path to icon file
    """
    if not icon_name:
        return ""
    
    # If it's already an absolute path and exists
    if os.path.isabs(icon_name) and os.path.exists(icon_name):
        return icon_name
    
    # Remove .png, .svg, .xpm extensions if present for searching
    icon_base = icon_name
    for ext in ['.png', '.svg', '.xpm', '.jpg', '.jpeg']:
        if icon_base.endswith(ext):
            icon_base = icon_base[:-len(ext)]
    
    # Search patterns to try
    search_patterns = [
        # Direct filename matches
        icon_name,
        icon_base,
        f"{icon_base}.svg",
        f"{icon_base}.png",
        f"{icon_base}.xpm",
        
        # With size directories
        *[f"{size}/apps/{icon_name}" for size in ICON_SIZES],
        *[f"{size}/apps/{icon_base}" for size in ICON_SIZES],
        *[f"{size}/apps/{icon_base}.svg" for size in ICON_SIZES],
        *[f"{size}/apps/{icon_base}.png" for size in ICON_SIZES],
        
        # In apps subdirectory
        f"apps/{icon_name}",
        f"apps/{icon_base}",
        f"apps/{icon_base}.svg",
        f"apps/{icon_base}.png",
        
        # In categories
        *[f"{size}/categories/{icon_name}" for size in ICON_SIZES],
        *[f"{size}/categories/{icon_base}" for size in ICON_SIZES],
        
        # Mime types
        *[f"{size}/mimetypes/{icon_name}" for size in ICON_SIZES],
        *[f"{size}/mimetypes/{icon_base}" for size in ICON_SIZES],
    ]
    
    # File extensions to try
    extensions = ['.svg', '.png', '.xpm', '.jpg', '.jpeg']
    
    # Search through all directories and patterns
    for icon_dir in ICON_DIRS:
        path = Path(icon_dir)
        if not path.exists():
            continue
            
        for pattern in search_patterns:
            for ext in extensions:
                # Try exact pattern
                icon_path = path / pattern
                if icon_path.exists():
                    return str(icon_path)
                
                # Try pattern with extension
                if not pattern.endswith(ext):
                    icon_path_with_ext = path / f"{pattern}{ext}"
                    if icon_path_with_ext.exists():
                        return str(icon_path_with_ext)
    
    # Special case: check in /usr/share/pixmaps directly
    pixmaps_path = Path("/usr/share/pixmaps")
    if pixmaps_path.exists():
        for ext in extensions:
            icon_path = pixmaps_path / f"{icon_base}{ext}"
            if icon_path.exists():
                return str(icon_path)
            icon_path = pixmaps_path / f"{icon_name}{ext}"
            if icon_path.exists():
                return str(icon_path)
    
    # Check if it's a theme icon that might be available via icon theme
    # For common icons, provide fallback paths
    common_icons = {
    }
    
    if icon_base in common_icons and os.path.exists(common_icons[icon_base]):
        return common_icons[icon_base]
    
    return ""

def is_desktop_file_hidden(filepath):
    try:
        with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read(1000)
        return 'NoDisplay=true' in content or 'Hidden=true' in content
    except:
        return True

def parse_desktop_file(filepath):
    """
    Parse only the [Desktop Entry] section.
    Return dict with keys: name, exec (cleaned), execBase, icon, comment, iconPath
    """
    try:
        in_entry = False
        data = {}
        with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
            for raw in f:
                line = raw.strip()
                if not line:
                    continue
                # Section header
                if line.startswith('[') and line.endswith(']'):
                    section = line[1:-1].strip()
                    if section == 'Desktop Entry':
                        in_entry = True
                        continue
                    else:
                        # once a new section appears after Desktop Entry, stop parsing keys
                        if in_entry:
                            break
                        else:
                            continue
                if not in_entry:
                    continue
                if line.startswith('#'):
                    continue
                if '=' not in line:
                    continue
                key, value = line.split('=', 1)
                data[key.strip()] = value.strip()
        if not data:
            return None

        name = data.get('Name') or data.get('GenericName') or None
        exec_cmd = data.get('Exec') or None
        if not name or not exec_cmd:
            return None

        # remove field codes like %f %F %u %U %i %c %k
        exec_clean = FIELD_CODE_RE.sub('', exec_cmd).strip()
        # collapse multiple spaces
        exec_clean = re.sub(r'\s+', ' ', exec_clean).strip()

        # split args safely to preserve quoted parts
        try:
            parts = shlex.split(exec_clean)
        except Exception:
            # fallback: simple split
            parts = exec_clean.split()

        exec_base = parts[0] if parts else exec_clean

        icon_name = data.get('Icon', '')
        # Use comprehensive icon search
        icon_path = find_icon_comprehensive(icon_name)

        comment = data.get('Comment', '')

        return {
            "name": name,
            "exec": exec_clean,
            "execBase": exec_base,
            "icon": icon_name,
            "comment": comment,
            "iconPath": icon_path,
            "desktopFile": os.path.basename(filepath)  # Add source file for debugging
        }
    except Exception as e:
        print(f"Error parsing {filepath}: {e}", file=sys.stderr)
        return None

def is_bad_entry(app):
    """Check if this entry should be deprioritized"""
    exec_lower = app.get('exec', '').lower()
    name_lower = app.get('name', '').lower()
    
    # Các entry nên bị deprioritize
    bad_patterns = [
        '--profilemanager',
        'profile manager', 
        'profile-manager',
        '--safe-mode',
        '--new-instance',
        'migration',
        'wizard',
        'troubleshoot',
        'debug',
        'uninstall',
        'reset',
        'settings',
        'config',
        'preferences'
    ]
    
    for pattern in bad_patterns:
        if pattern in exec_lower or pattern in name_lower:
            return True
    return False

def scan_desktop_files():
    # try cache
    cached = load_cache()
    if cached is not None:
        return cached

    apps_map = {}  # key -> best app dict (key: name lower)
    for directory in DESKTOP_DIRS:
        path = Path(directory)
        if not path.exists():
            continue
        try:
            for entry in os.scandir(path):
                if not entry.name.endswith('.desktop') or not entry.is_file():
                    continue
                if is_desktop_file_hidden(entry.path):
                    continue
                app = parse_desktop_file(entry.path)
                if not app:
                    continue

                key = app.get('name', '').lower()
                if not key:
                    continue

                is_bad = is_bad_entry(app)

                existing = apps_map.get(key)
                if existing:
                    existing_is_bad = is_bad_entry(existing)
                    
                    if existing_is_bad and not is_bad:
                        apps_map[key] = app
                    elif not existing_is_bad and is_bad:
                        pass
                    else:
                        pass
                else:
                    apps_map[key] = app
        except Exception as e:
            print(f"Error scanning {directory}: {e}", file=sys.stderr)
            continue

    # Convert map to list
    final_apps = []
    for app in apps_map.values():
        if not is_bad_entry(app):
            final_apps.append(app)
    
    # Sort by name
    final_apps.sort(key=lambda x: x.get('name', '').lower())
    
    save_cache(final_apps)
    return final_apps

def filter_apps(apps, query):
    """Return apps where query is in name/exec/comment/icon"""
    if not query:
        return apps
    q = query.lower()
    out = []
    for app in apps:
        name = (app.get('name') or "").lower()
        exec_cmd = (app.get('exec') or "").lower()
        comment = (app.get('comment') or "").lower()
        icon = (app.get('icon') or "").lower()
        if q in name or q in exec_cmd or q in comment or q in icon:
            out.append(app)
    return out

if __name__ == "__main__":
    try:
        search_query = None
        if len(sys.argv) > 1:
            search_query = " ".join(sys.argv[1:]).strip()
        apps_list = scan_desktop_files()
        if search_query:
            apps_list = filter_apps(apps_list, search_query)
        print(json.dumps(apps_list, ensure_ascii=False, indent=2))
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)

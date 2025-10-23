#!/usr/bin/env python3
import json
import subprocess

try:
    result = subprocess.run(["hyprctl", "activeworkspace", "-j"], capture_output=True, text=True)
    data = json.loads(result.stdout)
    ws_name = data.get("name") or data.get("id")
    print(f"{ws_name}")
except Exception as e:
    print(f"⚠️ Lỗi: {e}")


#!/usr/bin/env python3
import json
import subprocess

try:
    # Lấy danh sách workspace hiện tại
    result = subprocess.run(["hyprctl", "workspaces", "-j"], capture_output=True, text=True)
    workspaces_data = json.loads(result.stdout)

    # Tạo dict tra cứu số lượng cửa sổ
    windows_by_id = {str(ws["id"]): ws.get("windows", 0) for ws in workspaces_data}

    # Tạo danh sách 10 workspace
    workspaces = []
    for i in range(1, 11):
        win_count = windows_by_id.get(str(i), 0)
        workspaces.append({
            "id": str(i),
            "active": win_count > 0
        })

    # Xuất JSON
    print(json.dumps(workspaces, indent=2))
except Exception as e:
    print(json.dumps({"error": str(e)}))


#!/usr/bin/env python3
import subprocess
import json

def get_processes():
    # Chạy lệnh ps để lấy danh sách tiến trình
    result = subprocess.run(
        ["ps", "-eo", "pid,cmd,%mem,rss", "--sort=-%mem"],
        stdout=subprocess.PIPE,
        text=True,
    )

    lines = result.stdout.strip().split("\n")[1:]  # Bỏ dòng tiêu đề
    processes = []

    for line in lines:
        parts = line.split(None, 3)  # Tách theo khoảng trắng, tối đa 4 phần
        if len(parts) < 4:
            continue

        pid, cmd, percent, rss = parts
        try:
            pid = int(pid)
            percent = float(percent)
            rss_mb = float(rss) / 1024
        except ValueError:
            continue

        processes.append({
            "pid": pid,
            "name": cmd,
            "percent": percent,
            "rss_mb": rss_mb
        })

    return processes

if __name__ == "__main__":
    procs = get_processes()
    print(json.dumps(procs, indent=2))


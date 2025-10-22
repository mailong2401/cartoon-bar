#!/usr/bin/env python3
import json

def get_meminfo():
    """Đọc /proc/meminfo và trả về thông tin RAM & Swap (MB, %)"""
    meminfo = {}
    with open("/proc/meminfo") as f:
        for line in f:
            key, value = line.split(":")
            meminfo[key.strip()] = int(value.strip().split()[0])  # KB

    total = meminfo["MemTotal"] / 1024
    free = meminfo["MemFree"] / 1024
    available = meminfo.get("MemAvailable", free) / 1024
    buffers = meminfo.get("Buffers", 0) / 1024
    cached = meminfo.get("Cached", 0) / 1024
    shared = meminfo.get("Shmem", 0) / 1024

    # Dung lượng RAM đã dùng (loại trừ cache và buffer)
    used = total - free - buffers - cached
    used_percent = int((used / total) * 100)

    swap_total = meminfo.get("SwapTotal", 0) / 1024
    swap_free = meminfo.get("SwapFree", 0) / 1024
    swap_used = swap_total - swap_free
    swap_percent = int((swap_used / swap_total) * 100) if swap_total > 0 else 0

    return {
        "memory": {
            "total_mb": int(total),
            "used_mb": int(used),
            "free_mb": int(free),
            "available_mb": int(available),
            "buffers_mb": int(buffers),
            "cached_mb": int(cached),
            "shared_mb": int(shared),
            "used_percent": used_percent
        },
        "swap": {
            "total_mb": int(swap_total),
            "used_mb": int(swap_used),
            "free_mb": int(swap_free),
            "used_percent": swap_percent
        }
    }

if __name__ == "__main__":
    print(json.dumps(get_meminfo(), indent=2))


#!/usr/bin/env bash
# Script kiểm tra RAM và in ra JSON

# Lấy thông tin RAM từ /proc/meminfo
total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
available=$(grep MemAvailable /proc/meminfo | awk '{print $2}')

# Tính toán
used=$((total - available))
percent=$((used * 100 / total))

# Chuyển sang MB
total_mb=$((total / 1024))
used_mb=$((used / 1024))
available_mb=$((available / 1024))

# In ra dạng JSON
printf '{
  "total_mb": %d,
  "used_mb": %d,
  "available_mb": %d,
  "used_percent": %d
}\n' "$total_mb" "$used_mb" "$available_mb" "$percent"

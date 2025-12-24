#!/bin/bash
# ===== Cấu hình =====
BAT="/sys/class/power_supply/BAT1"
LOG_JSON="$HOME/battery_log.json"
LOW_THRESHOLD=15
HIGH_THRESHOLD=95

# ===== Lấy thông số pin =====
status=$(cat $BAT/status)
capacity=$(cat $BAT/capacity)
energy=$(cat $BAT/energy_now)
energy_full=$(cat $BAT/energy_full)
power=$(cat $BAT/power_now)
voltage=$(cat $BAT/voltage_now)

# ===== Tốc độ sạc/xả (mA) =====
if [ "$voltage" -ne 0 ]; then
  current=$((power / voltage))
  current_mA=$((current / 1000))
else
  current_mA=0
fi

# ===== Tạo JSON =====
json_output=$(
  cat <<EOF
{
  "status": "$status",
  "capacity": $capacity,
  "energy_mWh": $((energy / 1000)),
  "energy_full_mWh": $((energy_full / 1000)),
  "power_mW": $((power / 1000)),
  "voltage_V": $((voltage / 1000000)),
  "current_mA": $current_mA
}
EOF
)

# ===== In JSON ra terminal =====
echo "$json_output"

# ===== Ghi JSON vào file =====
echo "$json_output" >>"$LOG_JSON"

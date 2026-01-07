#!/usr/bin/env bash

WALL="$1"

# kiểm tra file có tồn tại không
if [ ! -f "$WALL" ]; then
  echo "❌ File không tồn tại: $WALL"
  exit 1
fi

EXT="${WALL##*.}"
EXT="$(echo "$EXT" | tr 'A-Z' 'a-z')"

case "$EXT" in
mp4 | mkv | webm | gif)
  echo "🎥 Video wallpaper → dùng mpvpaper"

  # kill mpvpaper cũ nếu đang chạy - dùng pkill mạnh hơn
  pkill -9 mpvpaper 2>/dev/null
  pkill -9 -f "mpvpaper" 2>/dev/null
  killall -9 mpvpaper 2>/dev/null
  killall -9 mpv 2>/dev/null

  # kill swww để khỏi tốn RAM
  swww kill 2>/dev/null

  # chờ một chút để processes thực sự tắt
  sleep 0.3

  # chạy mpvpaper dưới nền và detach khỏi parent process
  # Thêm các options cho hiệu ứng mượt mà:
  # --hwdec=auto: Hardware decoding
  # --video-sync=display-resample: Smooth playback
  # --interpolation: Frame interpolation cho mượt hơn
  # --fade-in-duration=1: Fade in khi bắt đầu
  nohup mpvpaper -o "no-audio loop hwdec=auto video-sync=display-resample interpolation fade-in-duration=1" "*" "$WALL" >/dev/null 2>&1 &

  # đợi một chút để mpvpaper khởi động
  sleep 0.5

  echo "✓ mpvpaper đã khởi động với hiệu ứng fade-in"
  ;;

png | jpg | jpeg | webp)
  echo "🖼 Ảnh wallpaper → dùng swww"

  # kill mpvpaper khi chuyển sang ảnh - dùng pkill để chắc chắn
  pkill -9 mpvpaper 2>/dev/null
  pkill -9 -f "mpvpaper" 2>/dev/null
  killall -9 mpvpaper 2>/dev/null
  killall -9 mpv 2>/dev/null

  # chờ một chút để processes thực sự tắt
  sleep 0.2

  # khởi động swww nếu chưa chạy
  if ! pgrep -x swww-daemon >/dev/null; then
    swww-daemon &

    sleep 0.3
  fi

  swww img "$WALL" --transition-type grow --transition-duration 1
  ;;

*)
  echo "⚠️ Định dạng không hỗ trợ: .$EXT"
  exit 2
  ;;
esac

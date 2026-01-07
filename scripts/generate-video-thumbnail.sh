#!/usr/bin/env bash

VIDEO_FILE="$1"
OUTPUT_FILE="$2"

# Kiểm tra input
if [ -z "$VIDEO_FILE" ] || [ ! -f "$VIDEO_FILE" ]; then
  echo "Error: Video file not found"
  exit 1
fi

if [ -z "$OUTPUT_FILE" ]; then
  echo "Error: Output file not specified"
  exit 1
fi

# Tạo thumbnail tại giây thứ 1 của video
ffmpeg -i "$VIDEO_FILE" -ss 00:00:01 -vframes 1 -q:v 2 "$OUTPUT_FILE" -y 2>/dev/null

if [ $? -eq 0 ]; then
  echo "Thumbnail created: $OUTPUT_FILE"
else
  echo "Error creating thumbnail"
  exit 1
fi

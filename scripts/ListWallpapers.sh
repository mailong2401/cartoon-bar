#!/bin/bash

# Đường dẫn đến thư mục Wallpapers
wallpapers_dir="$HOME/Pictures/"

# Kiểm tra thư mục có tồn tại không
if [ ! -d "$wallpapers_dir" ]; then
  echo "Thư mục $wallpapers_dir không tồn tại."
  exit 1
fi

# Liệt kê các file ảnh với các định dạng đã cho
find "$wallpapers_dir" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.bmp" -o -iname "*.webp" \)

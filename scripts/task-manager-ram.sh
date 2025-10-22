#!/usr/bin/env bash
# Liệt kê top 10 tiến trình dùng RAM nhiều nhất dạng JSON

echo '['
ps -eo pid,comm,%mem,rss --sort=-%mem | head -n 11 | tail -n +2 | awk '
{
  printf "  {\"pid\": %d, \"name\": \"%s\", \"percent\": %.1f, \"rss_mb\": %.1f}", $1, $2, $3, $4/1024
  if (NR < 10) printf ","
  print ""
}
'
echo ']'

#!/usr/bin/env bash

set -u

cpu_usage() {
  local first second idle1 idle2 total1 total2 idle_delta total_delta

  read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
  idle1=$((idle + iowait))
  total1=$((user + nice + system + idle + iowait + irq + softirq + steal))

  sleep 0.1

  read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
  idle2=$((idle + iowait))
  total2=$((user + nice + system + idle + iowait + irq + softirq + steal))

  idle_delta=$((idle2 - idle1))
  total_delta=$((total2 - total1))

  if (( total_delta <= 0 )); then
    printf "0"
  else
    printf "%d" $((100 * (total_delta - idle_delta) / total_delta))
  fi
}

memory_usage() {
  awk '
    /MemTotal:/ { total = $2 }
    /MemAvailable:/ { available = $2 }
    END {
      if (total > 0) {
        printf "%d", (total - available) * 100 / total
      } else {
        printf "0"
      }
    }
  ' /proc/meminfo
}

temperature_icon() {
  local temp_file temp

  temp_file="/sys/class/thermal/thermal_zone8/temp"
  if [[ ! -r "$temp_file" ]]; then
    temp_file="$(find /sys/class/thermal -maxdepth 2 -name temp -readable 2>/dev/null | head -n 1)"
  fi

  if [[ -z "${temp_file:-}" || ! -r "$temp_file" ]]; then
    printf ""
    return
  fi

  temp="$(awk '{ printf "%d", $1 / 1000 }' "$temp_file")"
  if (( temp >= 80 )); then
    printf "󱗗 %d°C" "$temp"
  elif (( temp >= 60 )); then
    printf " %d°C" "$temp"
  elif (( temp >= 40 )); then
    printf " %d°C" "$temp"
  else
    printf " %d°C" "$temp"
  fi
}

printf "cpu=%s\n" "$(cpu_usage)"
printf "memory=%s\n" "$(memory_usage)"
printf "temperature=%s\n" "$(temperature_icon)"

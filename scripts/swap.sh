#!/bin/bash

# Ambil penggunaan swap dalam KB
swap_usage_kb=$(free -k | awk '/Swap:/ {print $3}')

# Ambil kapasitas total swap dalam KB
swap_total_kb=$(free -k | awk '/Swap:/ {print $2}')

# Hitung persentase penggunaan swap
swap_usage_percent=$(echo "scale=2; ($swap_usage_kb / $swap_total_kb) * 100" | bc)

# Output: usage_kb,total_kb,usage_percent
echo "$swap_usage_kb,$swap_total_kb,$swap_usage_percent"

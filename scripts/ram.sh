#!/bin/bash

# Jika ada parameter, gunakan sebagai custom value
if [[ -n $1 ]]; then
    ram_usage_kb=$1
    ram_total_kb=$2
else
    # Ambil penggunaan RAM dalam KB
    ram_usage_kb=$(free -k | awk '/Mem:/ {print $3}')
    # Ambil kapasitas total RAM dalam KB
    ram_total_kb=$(free -k | awk '/Mem:/ {print $2}')
fi

# Hitung persentase penggunaan RAM
ram_usage_percent=$(echo "scale=2; ($ram_usage_kb / $ram_total_kb) * 100" | bc)

# Output: usage_kb,total_kb,usage_percent
echo "$ram_usage_kb,$ram_total_kb,$ram_usage_percent"

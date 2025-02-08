#!/bin/bash

# Ambil target disk/partisi dari parameter atau konfigurasi
disk_target=$1

# Jika target tidak diberikan, gunakan default dari konfigurasi
if [[ -z $disk_target ]]; then
    disk_target=$(grep 'disk_target=' ../config/disk-config.sh | cut -d'=' -f2 | tr -d '"')
fi

# Ambil penggunaan dan kapasitas disk/partisi dalam KB
disk_data=$(df -k "$disk_target" | tail -1)
disk_usage_kb=$(echo "$disk_data" | awk '{print $3}')
disk_total_kb=$(echo "$disk_data" | awk '{print $2}')

# Hitung persentase penggunaan disk
disk_usage_percent=$(echo "scale=2; ($disk_usage_kb / $disk_total_kb) * 100" | bc)

# Output: usage_kb,total_kb,usage_percent
echo "$disk_usage_kb,$disk_total_kb,$disk_usage_percent"

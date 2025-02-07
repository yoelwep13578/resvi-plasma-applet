#!/bin/bash

# Ambil target ZRAM dari parameter atau konfigurasi
zram_target=$1

# Jika target tidak diberikan, gunakan default dari konfigurasi
if [[ -z $zram_target ]]; then
    zram_target=$(grep 'zram_target=' ../config/zram-config.sh | cut -d'=' -f2 | tr -d '"')
fi

# Ambil penggunaan dan kapasitas ZRAM dalam KB
zram_data=$(zramctl --output=DISKSIZE,DATA --noheadings "$zram_target")
zram_total_kb=$(echo "$zram_data" | awk '{print $1 * 1024 * 1024}')  # Konversi GB ke KB
zram_usage_kb=$(echo "$zram_data" | awk '{print $2 * 1024 * 1024}')  # Konversi GB ke KB

# Hitung persentase penggunaan ZRAM
zram_usage_percent=$(echo "scale=2; ($zram_usage_kb / $zram_total_kb) * 100" | bc)

# Output: usage_kb,total_kb,usage_percent
echo "$zram_usage_kb,$zram_total_kb,$zram_usage_percent"

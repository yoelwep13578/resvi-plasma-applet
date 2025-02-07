#!/bin/bash

# Tentukan path ke file konfigurasi
CONFIG_FILE="$(dirname "$0")/../config/zram-config.sh"

# Baca file konfigurasi
source "$CONFIG_FILE"

# Ambil target ZRAM dari parameter atau konfigurasi
zram_target=$1

# Jika target tidak diberikan, gunakan default dari konfigurasi
if [[ -z $zram_target ]]; then
    zram_target=$(grep 'zram_target=' "$CONFIG_FILE" | cut -d'=' -f2 | tr -d '"')
fi

# Ambil data ZRAM menggunakan zramctl
zram_info=$(zramctl --noheadings "$zram_target" 2>/dev/null)

# Jika data ZRAM tidak ditemukan, beri nilai default
if [[ -z $zram_info ]]; then
    zram_usage_kb=0
    zram_total_kb=0
    zram_usage_percent=0
else
    # Parse data dari zramctl
    zram_total_kb=$(echo "$zram_info" | awk '{print $3}' | sed 's/G/*1024*1024/;s/M/*1024/;s/K//' | bc)
    zram_data_kb=$(echo "$zram_info" | awk '{print $4}' | sed 's/G/*1024*1024/;s/M/*1024/;s/K//' | bc)
    zram_compressed_kb=$(echo "$zram_info" | awk '{print $5}' | sed 's/G/*1024*1024/;s/M/*1024/;s/K//' | bc)
    zram_total_used_kb=$(echo "$zram_info" | awk '{print $6}' | sed 's/G/*1024*1024/;s/M/*1024/;s/K//' | bc)

    # Tentukan nilai usage berdasarkan konfigurasi loadinfo_zram
    case $loadinfo_zram in
        "data") zram_usage_kb=$zram_data_kb ;;
        "compressed") zram_usage_kb=$zram_compressed_kb ;;
        "total") zram_usage_kb=$zram_total_used_kb ;;
        *) zram_usage_kb=$zram_data_kb ;;  # Default ke DATA
    esac

    # Hitung persentase penggunaan ZRAM
    if (( $(echo "$zram_total_kb > 0" | bc -l) )); then
        zram_usage_percent=$(echo "scale=2; ($zram_usage_kb / $zram_total_kb) * 100" | bc)
    else
        zram_usage_percent=0
    fi
fi

# Output: usage_kb,total_kb,usage_percent
echo "$zram_usage_kb,$zram_total_kb,$zram_usage_percent"

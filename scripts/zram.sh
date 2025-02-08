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
    zram_total=$(echo "$zram_info" | awk '{print $3}')  # DISKSIZE
    zram_data=$(echo "$zram_info" | awk '{print $4}')   # DATA
    zram_compressed=$(echo "$zram_info" | awk '{print $5}')  # COMPR
    zram_total_used=$(echo "$zram_info" | awk '{print $6}')  # TOTAL

    # Fungsi untuk mengkonversi nilai ke KB
    convert_to_kb() {
        local value=$1
        local unit=${value: -1}  # Ambil satuan (G, M, K)
        local num=${value%?}     # Ambil angka tanpa satuan

        case $unit in
            "G") echo "$num * 1024 * 1024" | bc ;;
            "M") echo "$num * 1024" | bc ;;
            "K") echo "$num" | bc ;;
            *) echo "0" ;;  # Default jika satuan tidak dikenali
        esac
    }

    # Konversi semua nilai ke KB
    zram_total_kb=$(convert_to_kb "$zram_total")
    zram_data_kb=$(convert_to_kb "$zram_data")
    zram_compressed_kb=$(convert_to_kb "$zram_compressed")
    zram_total_used_kb=$(convert_to_kb "$zram_total_used")

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

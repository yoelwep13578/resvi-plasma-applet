#!/bin/bash

# Tentukan path berdasarkan lokasi script ini
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
CONFIG_FILE="$SCRIPT_DIR/../config/ram-config.sh"
SCRIPTS_DIR="$SCRIPT_DIR/../scripts"

# Baca file konfigurasi
source "$CONFIG_FILE"

# Ambil data RAM dari script
ram_data=$("$SCRIPTS_DIR/ram.sh" "$1" "$2")
ram_usage_kb=$(echo "$ram_data" | cut -d',' -f1)
ram_total_kb=$(echo "$ram_data" | cut -d',' -f2)
ram_usage_percent=$(echo "$ram_data" | cut -d',' -f3)

# Fungsi untuk mengkonversi KB ke satuan yang diinginkan
convert_to_unit() {
    local value_kb=$1
    local data_size=$2
    local data_unit=$3

    # Tentukan satuan secara otomatis jika data_size="auto"
    if [[ $data_size == "auto" ]]; then
        if (( $(echo "$value_kb < 1024" | bc -l) )); then
            data_size="K"
        elif (( $(echo "$value_kb < 1048576" | bc -l) )); then
            data_size="M"
        elif (( $(echo "$value_kb < 1073741824" | bc -l) )); then
            data_size="G"
        else
            data_size="T"
        fi
    fi

    # Konversi ke B, KB, MB, GB, TB (basis 10) atau KiB, MiB, GiB, TiB (basis 2)
    case $data_size in
        "B")
            if [[ $data_unit == "GB" || $data_unit == "GB-hide-B" ]]; then
                value=$(echo "scale=2; $value_kb * 1024" | bc)  # Basis 10
            else
                value=$(echo "scale=2; $value_kb * 1024" | bc)  # Basis 2 (sama untuk B)
            fi
            ;;
        "K")
            if [[ $data_unit == "GB" || $data_unit == "GB-hide-B" ]]; then
                value=$(echo "scale=2; $value_kb" | bc)  # Basis 10 (KB)
            else
                value=$(echo "scale=2; $value_kb" | bc)  # Basis 2 (KiB)
            fi
            ;;
        "M")
            if [[ $data_unit == "GB" || $data_unit == "GB-hide-B" ]]; then
                value=$(echo "scale=2; $value_kb / 1000" | bc)  # Basis 10 (MB)
            else
                value=$(echo "scale=2; $value_kb / 1024" | bc)  # Basis 2 (MiB)
            fi
            ;;
        "G")
            if [[ $data_unit == "GB" || $data_unit == "GB-hide-B" ]]; then
                value=$(echo "scale=2; $value_kb / 1000 / 1000" | bc)  # Basis 10 (GB)
            else
                value=$(echo "scale=2; $value_kb / 1024 / 1024" | bc)  # Basis 2 (GiB)
            fi
            ;;
        "T")
            if [[ $data_unit == "GB" || $data_unit == "GB-hide-B" ]]; then
                value=$(echo "scale=2; $value_kb / 1000 / 1000 / 1000" | bc)  # Basis 10 (TB)
            else
                value=$(echo "scale=2; $value_kb / 1024 / 1024 / 1024" | bc)  # Basis 2 (TiB)
            fi
            ;;
        *) value="$value_kb" ;;
    esac

    # Tentukan unit berdasarkan data_unit
    case $data_unit in
        "GB") unit="${data_size}B" ;;
        "GiB") unit="${data_size}iB" ;;
        "GB-hide-B") unit="${data_size}" ;;
        "GiB-hide-B") unit="${data_size}i" ;;
        "GiB-hide-iB") unit="${data_size}" ;;
        *) unit="${data_size}B" ;;
    esac

    # Hilangkan unit ganda (misalnya, "BB" atau "BiB")
    if [[ $unit == *"BB" || $unit == *"BiB" ]]; then
        unit="${unit:0:1}"
    fi

    echo "$value,$unit"
}

# Format angka berdasarkan konfigurasi
format_number() {
    local number=$1
    local decimal_type=$2
    local fixed_width=$3
    local text_align=$4
    local unit=$5

    # Format angka berdasarkan decimal_type
    case $decimal_type in
        "dynamic")
            if [[ $fixed_width -ge 4 && $fixed_width -le 6 ]]; then
                # Tampilkan 1 angka desimal hanya untuk nilai satuan (0-9)
                if (( $(echo "$number < 10" | bc -l) )); then
                    number=$(printf "%.1f" "$number")
                else
                    number=$(printf "%.0f" "$number")
                fi
            else
                number=$(printf "%.0f" "$number")
            fi
            ;;
        "none")
            number=$(printf "%.0f" "$number")
            ;;
        "1")
            number=$(printf "%.1f" "$number")
            ;;
        "2")
            number=$(printf "%.2f" "$number")
            ;;
        *)
            number=$(printf "%.0f" "$number")
            ;;
    esac

    # Tambahkan unit (misalnya, GB untuk size)
    if [[ -n $unit ]]; then
        number="$number$unit"
    fi

    # Tambahkan spasi jika fixed_width diatur
    if [[ $fixed_width != "no" ]]; then
        local current_length=${#number}
        local spaces_to_add=$((fixed_width - current_length))

        if [[ $spaces_to_add -gt 0 ]]; then
            if [[ $text_align == "left" ]]; then
                number="$number$(printf '%*s' "$spaces_to_add" "")"
            else
                number="$(printf '%*s' "$spaces_to_add" "")$number"
            fi
        fi
    fi

    echo "$number"
}

# Tentukan nilai yang akan ditampilkan
if [[ $loadinfo_type == "percentage" ]]; then
    loadinfo_value="$ram_usage_percent"
    loadinfo_unit="%"
else
    converted_data=$(convert_to_unit "$ram_usage_kb" "$loadinfo_data_size" "$loadinfo_data_unit")
    loadinfo_value=$(echo "$converted_data" | cut -d',' -f1)
    loadinfo_unit=$(echo "$converted_data" | cut -d',' -f2)
fi

# Format nilai loadinfo
formatted_loadinfo=$(format_number "$loadinfo_value" "$loadinfo_decimal" "$loadinfo_fixed_width" "$loadinfo_text_align" "$loadinfo_unit")

# Tentukan nilai maxcap
if [[ $maxcap_type == "follow-system" ]]; then
    converted_maxcap=$(convert_to_unit "$ram_total_kb" "$loadinfo_data_size" "$loadinfo_data_unit")
    maxcap_value=$(echo "$converted_maxcap" | cut -d',' -f1)
    maxcap_unit=$(echo "$converted_maxcap" | cut -d',' -f2)
else
    maxcap_value="$maxcap_text"
    maxcap_unit=""
fi

# Format nilai maxcap
formatted_maxcap=$(format_number "$maxcap_value" "$maxcap_decimal" "$maxcap_fixed_width" "$maxcap_text_align" "$maxcap_unit")

# Fungsi untuk menggambar bar
draw_bar() {
    local fill=$1
    local empty=$2
    local length=$3
    local percent=$4
    local left_sign=$5
    local right_sign=$6

    # Jika persentase mendekati 100, anggap sebagai 100
    if (( $(echo "$percent >= 99.9" | bc -l) )); then
        percent=100
    fi

    # Konversi persentase ke bilangan bulat
    local percent_int=$(echo "$percent" | awk '{print int($1)}')

    # Jika persentase 0, tidak ada fill
    if (( percent_int == 0 )); then
        fill_length=0
        empty_length=$length
    else
        local fill_length=$((percent_int * length / 100))
        local empty_length=$((length - fill_length))
    fi

    printf "%s" "$left_sign"
    if (( fill_length > 0 )); then
        printf "%0.s$fill" $(seq 1 $fill_length)
    fi
    if (( empty_length > 0 )); then
        printf "%0.s$empty" $(seq 1 $empty_length)
    fi
    printf "%s" "$right_sign"
}

# Tentukan panjang bar berdasarkan konfigurasi
case $bar_length in
    "shortest") bar_length_num=10 ;;
    "short") bar_length_num=15 ;;
    "medium") bar_length_num=20 ;;
    "long") bar_length_num=25 ;;
    "longest") bar_length_num=30 ;;
    *) bar_length_num=$bar_length ;;  # Jika diisi angka langsung
esac

# Tampilkan widget berdasarkan urutan di display_as
IFS=',' read -r -a display_order <<< "$display_as"
for part in "${display_order[@]}"; do
    case $part in
        "label")
            if [[ $label_type == "icon" ]]; then
                printf "%s" "$label_left_sign$label_icon$label_right_sign"
            else
                printf "%s" "$label_left_sign$label_text$label_right_sign"
            fi
            ;;
        "load")
            printf "%s" "$loadinfo_left_sign$formatted_loadinfo$loadinfo_right_sign"
            ;;
        "bar")
            draw_bar "$bar_fill_character" "$bar_empty_character" "$bar_length_num" "$ram_usage_percent" "$bar_left_sign" "$bar_right_sign"
            ;;
        "max")
            printf "%s" "$maxcap_left_sign$formatted_maxcap$maxcap_right_sign"
            ;;
    esac
done

echo

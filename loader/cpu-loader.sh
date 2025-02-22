#!/bin/bash

# Tentukan path berdasarkan lokasi script ini
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
CONFIG_FILE="$SCRIPT_DIR/../config/cpu-config.sh"
SCRIPTS_DIR="$SCRIPT_DIR/../scripts"

# Baca file konfigurasi
source "$CONFIG_FILE"

# Jika ada parameter, gunakan sebagai custom value untuk cpu_usage
if [[ -n $1 ]]; then
    cpu_usage=$1
else
    # Ambil data CPU dari script
    cpu_usage=$("$SCRIPTS_DIR/cpu.sh")
fi

# Fungsi untuk memilih ikon berdasarkan persentase CPU
get_dynamic_icon() {
    local cpu_usage=$1

    if (( $(echo "$cpu_usage < ${label_icon_level1%,*}" | bc -l) )); then
        echo "${label_icon_level1#*,}"
    elif (( $(echo "$cpu_usage < ${label_icon_level2%,*}" | bc -l) )); then
        echo "${label_icon_level2#*,}"
    elif (( $(echo "$cpu_usage < ${label_icon_level3%,*}" | bc -l) )); then
        echo "${label_icon_level3#*,}"
    elif (( $(echo "$cpu_usage < ${label_icon_level4%,*}" | bc -l) )); then
        echo "${label_icon_level4#*,}"
    else
        echo "${label_icon_level5#*,}"
    fi
}

# Pilih ikon
if [[ $label_dynamic_icon == "yes" ]]; then
    label_icon=$(get_dynamic_icon "$cpu_usage")
fi

# Command untuk testing (di-comment)
# Contoh: ./cpu-loader.sh 75.5
# Contoh: ./cpu-loader.sh 100

# Fungsi untuk memformat angka berdasarkan konfigurasi decimal
format_number() {
    local number=$1
    local decimal_type=$2
    local fixed_width=$3
    local text_align=$4
    local unit=$5

    # Jika persentase mendekati 100, anggap sebagai 100
    if (( $(echo "$number >= 99.9" | bc -l) )); then
        number=100
    fi

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

    # Tambahkan unit (misalnya, % untuk percentage)
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

# Format angka berdasarkan konfigurasi
if [[ $loadinfo_type == "percentage" ]]; then
    formatted_cpu_usage=$(format_number "$cpu_usage" "$loadinfo_decimal" "$loadinfo_fixed_width" "$loadinfo_text_align" "%")
else
    formatted_cpu_usage=$(format_number "$cpu_usage" "$loadinfo_decimal" "$loadinfo_fixed_width" "$loadinfo_text_align")
fi

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
            printf "%s" "$loadinfo_left_sign$formatted_cpu_usage$loadinfo_right_sign"
            ;;
        "bar")
            draw_bar "$bar_fill_character" "$bar_empty_character" "$bar_length_num" "$cpu_usage" "$bar_left_sign" "$bar_right_sign"
            ;;
        "max")
            printf "%s" "$maxcap_left_sign$maxcap_text$maxcap_right_sign"
            ;;
    esac
done

echo

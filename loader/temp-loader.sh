#!/bin/bash

# Tentukan path ke file konfigurasi dan script
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
CONFIG_FILE="$SCRIPT_DIR/../config/temp-config.sh"
SCRIPTS_DIR="$SCRIPT_DIR/../scripts"

# Baca file konfigurasi
source "$CONFIG_FILE"

# Ambil data suhu dari script
temp_data=$("$SCRIPTS_DIR/temp.sh" "$temp_target")
temp_celsius=$(echo "$temp_data" | cut -d',' -f1)
temp_fahrenheit=$(echo "$temp_data" | cut -d',' -f2)

# Fungsi untuk menentukan ikon dinamis
get_dynamic_icon() {
    local temp=$1
    local unit=$2

    if [[ $label_dynamic_icon == "yes" ]]; then
        # Konversi suhu ke Celsius jika unit adalah Fahrenheit
        if [[ $unit == "F" ]]; then
            temp=$(echo "scale=2; ($temp - 32) * 5/9" | bc)
        fi

        # Tentukan ikon berdasarkan level suhu
        if (( $(echo "$temp < ${label_icon_level1%,*}" | bc -l) )); then
            echo "${label_icon_level1##*,}"
        elif (( $(echo "$temp < ${label_icon_level2%,*}" | bc -l) )); then
            echo "${label_icon_level2##*,}"
        elif (( $(echo "$temp < ${label_icon_level3%,*}" | bc -l) )); then
            echo "${label_icon_level3##*,}"
        elif (( $(echo "$temp < ${label_icon_level4%,*}" | bc -l) )); then
            echo "${label_icon_level4##*,}"
        else
            echo "${label_icon_level5##*,}"
        fi
    else
        echo "$label_icon"
    fi
}

# Tentukan ikon yang akan ditampilkan
if [[ $label_dynamic_icon == "yes" ]]; then
    label_icon=$(get_dynamic_icon "$temp_celsius" "C")
fi

# Tentukan nilai yang akan ditampilkan berdasarkan unit_temp
case $loadinfo_unit_temp in
    "C")
        loadinfo_value="$temp_celsius"
        loadinfo_unit="°C"
        ;;
    "F")
        loadinfo_value="$temp_fahrenheit"
        loadinfo_unit="°F"
        ;;
    "C-hide-degree")
        loadinfo_value="$temp_celsius"
        loadinfo_unit="C"
        ;;
    "F-hide-degree")
        loadinfo_value="$temp_fahrenheit"
        loadinfo_unit="F"
        ;;
    "C-hide-C")
        loadinfo_value="$temp_celsius"
        loadinfo_unit="°"
        ;;
    "F-hide-F")
        loadinfo_value="$temp_fahrenheit"
        loadinfo_unit="°"
        ;;
    *)
        loadinfo_value="$temp_celsius"
        loadinfo_unit="°C"
        ;;
esac

# Format nilai loadinfo
format_number() {
    local number=$1
    local decimal_type=$2
    local fixed_width=$3
    local text_align=$4
    local unit=$5

    case $decimal_type in
        "dynamic")
            if (( $(echo "$number < 10" | bc -l) )); then
                number=$(printf "%.1f" "$number")
            else
                number=$(printf "%.0f" "$number")
            fi
            ;;
        "none") number=$(printf "%.0f" "$number") ;;
        "1") number=$(printf "%.1f" "$number") ;;
        "2") number=$(printf "%.2f" "$number") ;;
        *) number=$(printf "%.0f" "$number") ;;
    esac

    if [[ -n $unit ]]; then
        number="$number$unit"
    fi

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

formatted_loadinfo=$(format_number "$loadinfo_value" "$loadinfo_decimal" "$loadinfo_fixed_width" "$loadinfo_text_align" "$loadinfo_unit")

# Tentukan nilai maxcap
if [[ $maxcap_type == "follow-limit" ]]; then
    maxcap_celsius=$(echo "$maxcap_limit" | cut -d',' -f1)
    maxcap_fahrenheit=$(echo "$maxcap_limit" | cut -d',' -f2)

    case $loadinfo_unit_temp in
        "C"|"C-hide-degree"|"C-hide-C")
            maxcap_value="$maxcap_celsius"
            maxcap_unit="$loadinfo_unit"
            ;;
        "F"|"F-hide-degree"|"F-hide-F")
            maxcap_value="$maxcap_fahrenheit"
            maxcap_unit="$loadinfo_unit"
            ;;
        *)
            maxcap_value="$maxcap_celsius"
            maxcap_unit="°C"
            ;;
    esac
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

    if (( $(echo "$percent >= 99.9" | bc -l) )); then
        percent=100
    fi

    local percent_int=$(echo "$percent" | awk '{print int($1)}')
    local fill_length=$((percent_int * length / 100))
    local empty_length=$((length - fill_length))

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
    *) bar_length_num=$bar_length ;;
esac

# Hitung persentase suhu
if [[ $maxcap_type == "follow-limit" ]]; then
    case $loadinfo_unit_temp in
        "C"|"C-hide-degree"|"C-hide-C")
            temp_percent=$(echo "scale=2; ($temp_celsius / $maxcap_celsius) * 100" | bc)
            ;;
        "F"|"F-hide-degree"|"F-hide-F")
            temp_percent=$(echo "scale=2; ($temp_fahrenheit / $maxcap_fahrenheit) * 100" | bc)
            ;;
        *)
            temp_percent=$(echo "scale=2; ($temp_celsius / $maxcap_celsius) * 100" | bc)
            ;;
    esac
else
    temp_percent=0
fi

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
            draw_bar "$bar_fill_character" "$bar_empty_character" "$bar_length_num" "$temp_percent" "$bar_left_sign" "$bar_right_sign"
            ;;
        "max")
            printf "%s" "$maxcap_left_sign$formatted_maxcap$maxcap_right_sign"
            ;;
    esac
done

echo

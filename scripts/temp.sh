#!/bin/bash

# Ambil target suhu dari parameter atau konfigurasi
temp_target=$1

# Jika target tidak diberikan, gunakan default dari konfigurasi
if [[ -z $temp_target ]]; then
    temp_target=$(grep 'temp_target=' ../config/temp-config.sh | cut -d'=' -f2 | tr -d '"')
fi

# Ambil data suhu menggunakan sensors
if [[ $temp_target == *"Package"* ]]; then
    # Jika target mengandung "Package", ambil nilai dari kolom ke-4
    temp_data=$(sensors | grep "$temp_target" | awk '{print $4}' | sed 's/+//;s/°C//;s/°F//')
elif [[ $temp_target == *"Core"* ]]; then
    # Jika target mengandung "Core", ambil nilai dari kolom ke-3
    temp_data=$(sensors | grep "$temp_target" | awk '{print $3}' | sed 's/+//;s/°C//;s/°F//')
else
    # Default: ambil nilai dari kolom ke-2
    temp_data=$(sensors | grep "$temp_target" | awk '{print $2}' | sed 's/+//;s/°C//;s/°F//')
fi

# Jika data suhu tidak ditemukan, beri nilai default
if [[ -z $temp_data ]]; then
    temp_celsius=0
    temp_fahrenheit=0
else
    # Konversi suhu ke Celsius dan Fahrenheit
    temp_celsius=$(echo "$temp_data" | bc)
    temp_fahrenheit=$(echo "scale=2; ($temp_celsius * 9/5) + 32" | bc)
fi

# Output: temp_celsius,temp_fahrenheit
echo "$temp_celsius,$temp_fahrenheit"

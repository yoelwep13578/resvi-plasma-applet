#!/bin/bash

# DISPLAY/APPEARANCE
display_as="label,load,bar,max"

# LABEL
label_type="icon"
label_icon=""  # Ikon default untuk ZRAM
label_text="ZRAM"
label_left_sign="["
label_right_sign="]"
label_dynamic_icon="no"  # Nonaktifkan dynamic icon untuk ZRAM

# LOAD/CURRENT
loadinfo_fixed_width="4"
loadinfo_text_align="right"
loadinfo_type="size"  # Tampilkan nilai dalam ukuran (bisa "percentage" atau "size")
loadinfo_data_size="auto"  # Satuan data (auto, B, K, M, G, T)
loadinfo_data_unit="GiB-hide-iB"  # Konversi data (GB, GiB, GB-hide-B, GiB-hide-B, GiB-hide-iB)
loadinfo_decimal="dynamic"
loadinfo_left_sign="["
loadinfo_right_sign="]"

# BAR
bar_length="medium"
bar_fill_character="/"
bar_empty_character="_"
bar_left_sign=" "
bar_right_sign=" "

# MAX/CAPACITY
maxcap_fixed_width="4"
maxcap_text_align="right"
maxcap_type="follow-system"  # Ambil kapasitas maksimal dari sistem
maxcap_decimal="dynamic"
maxcap_left_sign="["
maxcap_right_sign="]"

# READ TARGET
zram_target="/dev/zram0"  # Target ZRAM yang akan dimonitor

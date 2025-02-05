#!/bin/bash

# DISPLAY/APPEARANCE
display_as="label,load,bar,max"

# LABEL
label_type="icon"
label_icon=""
label_text="CPU"
label_left_sign="["
label_right_sign="]"

# LOAD/CURRENT
loadinfo_fixed_width="4"
loadinfo_text_align="right"
loadinfo_type="percentage"
loadinfo_decimal="dynamic"
loadinfo_left_sign="["
loadinfo_right_sign="]"

# BAR
bar_length="medium"        # Bisa diisi "shortest", "short", "medium", "long", "longest", atau angka
bar_fill_character="/"
bar_empty_character="."
bar_left_sign=" "
bar_right_sign=" "

# MAX/CAPACITY
maxcap_fixed_width="no"
maxcap_text_align="left"
maxcap_type="text"
maxcap_text="100%"
maxcap_decimal="dynamic"
maxcap_left_sign="["
maxcap_right_sign="]"

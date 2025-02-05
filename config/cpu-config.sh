#!/bin/bash

# DISPLAY/APPEARANCE
display_as="label,load,bar,max"

# LABEL
label_type="icon"
label_icon=""  # Ikon default
label_text="CPU"
label_left_sign="["
label_right_sign="]"

# Dynamic icon configuration
label_dynamic_icon="no"
label_icon_level1="0, "
label_icon_level2="40,󰾆"
label_icon_level3="70,󰾅"
label_icon_level4="101,󰓅"
label_icon_level5="101, "

# LOAD/CURRENT
loadinfo_fixed_width="4"
loadinfo_text_align="right"
loadinfo_type="percentage"
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
maxcap_text_align="left"
maxcap_type="text"
maxcap_text="100%"
maxcap_decimal="dynamic"
maxcap_left_sign="["
maxcap_right_sign="]"

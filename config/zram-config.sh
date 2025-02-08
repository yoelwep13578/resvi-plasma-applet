#!/bin/bash

##########################
#   DISPLAY/APPEARANCE   #
##########################
display_as="label,load,bar,max"   # [label],[load],[bar],[max]
                                  # Fillable with single section, or multi sections (separated by comma)

#############
#   LABEL   #
#############
label_type="icon"                 # [icon] [text]
label_icon=""
label_text="ZRAM"
label_left_sign="["
label_right_sign="]"

####################
#   LOAD/CURRENT   #
####################
loadinfo_fixed_width="4"          # [no] [(Numbers >= 4)]
loadinfo_text_align="right"       # [left] [right]
loadinfo_type="size"              # [percentage] [size]
loadinfo_data_size="auto"         # [auto] [B] [K] [M] [G] [T]
loadinfo_data_unit="GiB-hide-iB"  # [GB] [GiB] [GB-hide-B] [GiB-hide-B] [GiB-hide-iB]
loadinfo_decimal="dynamic"        # [dynamic] [none] [1] [2]
loadinfo_left_sign="["
loadinfo_right_sign="]"

loadinfo_zram="data"              # What should it show? Choose [data] [compressed] or [total]

###########
#   BAR   #
###########
bar_length="medium"               # [shortest] [short] [medium] [long] [longest] [(CustomNumber)]
bar_fill_character="/"
bar_empty_character="_"
bar_left_sign=" "
bar_right_sign=" "

####################
#   MAX/CAPACITY   #
####################
maxcap_fixed_width="4"            # [no] [(Numbers >= 4)]
maxcap_text_align="right"         # [left] [right]
maxcap_type="follow-system"       # Only [follow-system]
maxcap_decimal="dynamic"          # [dynamic] [none] [1] [2]
maxcap_left_sign="["
maxcap_right_sign="]"

# READ TARGET
zram_target="/dev/zram0"          # ZRAM Target. Usually like /dev/zramX

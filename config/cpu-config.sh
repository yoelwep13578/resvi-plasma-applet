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

label_icon=""                    # Fillable with icon, character, and space
label_text="CPU"                  # Fillable with character and space
label_left_sign="["               # Fillable with character and space
label_right_sign="]"              # Fillable with character and space

#############################
#   DYNAMIC ICON ON LABEL   #
#############################
label_dynamic_icon="no"           # [no] [yes]

label_icon_level1="0, "           # [(LimitThreshold),(Icon)]
label_icon_level2="40,󰾆"          # [(LimitThreshold),(Icon)]
label_icon_level3="70,󰾅"          # [(LimitThreshold),(Icon)]
label_icon_level4="101,󰓅"         # [(LimitThreshold),(Icon)]
label_icon_level5="101, "         # [(LimitThreshold),(Icon)]

####################
#   LOAD/CURRENT   #
####################
loadinfo_fixed_width="4"          # [no] [(Numbers >= 4)]
loadinfo_text_align="right"       # [left] [right]
loadinfo_type="percentage"        # Only [percentage] for CPU ResVi as default. Don't change it!
loadinfo_decimal="dynamic"        # [dynamic] [none] [1] [2]

loadinfo_left_sign="["            # Fillable with character and space
loadinfo_right_sign="]"           # Fillable with character and space

###########
#   BAR   #
###########
bar_length="medium"               # [shortest] [short] [medium] [long] [longest] [(CustomNumber)]

bar_fill_character="/"            # Fillable with character and space
bar_empty_character="_"           # Fillable with character and space

bar_left_sign=" "                 # Fillable with character and space
bar_right_sign=" "                # Fillable with character and space

####################
#   MAX/CAPACITY   #
####################
maxcap_fixed_width="4"            # [no] [(Numbers >= 4)]
maxcap_text_align="right"         # [left] [right]
maxcap_type="text"                # [follow-system] [text]
maxcap_text="100%"
maxcap_decimal="dynamic"          # [dynamic] [none] [1] [2]

maxcap_left_sign="["              # Fillable with character and space
maxcap_right_sign="]"             # Fillable with character and space

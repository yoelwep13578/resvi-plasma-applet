#!/bin/bash

##########################
#   DISPLAY/APPEARANCE   #
##########################
display_as="label,load,bar,max"   # [label],[load],[bar],[max]

#############
#   LABEL   #
#############
label_type="icon"                 # [icon] [text]
label_icon=""                    # Ikon default untuk suhu
label_text="Temp"
label_left_sign="["
label_right_sign="]"

#############################
#   DYNAMIC ICON ON LABEL   #
#############################
label_dynamic_icon="yes"           # [yes] [no]

label_icon_level1="50,122,"         # [(LimitCelsius),(LimitFahrenheit),(Icon)]
label_icon_level2="70,158,"         # [(LimitCelsius),(LimitFahrenheit),(Icon)]
label_icon_level3="80,176,"         # [(LimitCelsius),(LimitFahrenheit),(Icon)]
label_icon_level4="90,194,"         # [(LimitCelsius),(LimitFahrenheit),(Icon)]
label_icon_level5="100,212,"         # [(LimitCelsius),(LimitFahrenheit),(Icon)]

####################
#   LOAD/CURRENT   #
####################
loadinfo_fixed_width="4"          # [no] [(Numbers >= 4)]
loadinfo_text_align="right"       # [left] [right]
loadinfo_type="temperature"       # [temperature]
loadinfo_unit_temp="C"            # [C] [F] [C-hide-degree] [F-hide-degree] [C-hide-C] [F-hide-F]
loadinfo_decimal="dynamic"        # [dynamic] [none] [1] [2]

loadinfo_left_sign="["
loadinfo_right_sign="]"

# TARGET
temp_target="Package id 0"        # Target suhu (misalnya "Package id 0", "Core 0", dll)

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
maxcap_type="follow-limit"        # [follow-limit] [text]
maxcap_limit="100,212"            # [LimitCelsius, LimitFahrenheit]
maxcap_text="100%"
maxcap_decimal="dynamic"          # [dynamic] [none] [1] [2]

maxcap_left_sign="["
maxcap_right_sign="]"

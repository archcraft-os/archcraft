#!/bin/bash

# A simple script to display battery percent
# Taken from Anachron i3blocks
# I only slightly modify this script to add an option to show icon
# I also remove the i3blocks specify script
# To make this works with tint2 executor, polybar custom script, dzen2 feeder, conkybar, lemonbar feeder, dunst notify, etc.
# 'battery -i' = with icon, 'battery' = text only
# Cheers!
# Addy

BATTERY=0
BATTERY_INFO=$(acpi -b | grep "Battery ${BATTERY}")
BATTERY_STATE=$(echo "${BATTERY_INFO}" | grep -wo "Full\|Charging\|Discharging")
BATTERY_POWER=$(echo "${BATTERY_INFO}" | grep -o '[0-9]\+%' | tr -d '%')

if [[ "${BATTERY_STATE}" = "Charging" ]]; then
	if  [[ $1 = "-i" ]]; then
	echo "  ${BATTERY_POWER}%+"
	else
	echo "${BATTERY_POWER}%+"
	fi
	
elif [[ "${BATTERY_STATE}" = "Discharging" ]]; then
	if  [[ $1 = "-i" ]]; then
	echo "  ${BATTERY_POWER}%-"
	else
	echo "${BATTERY_POWER}%-"
	fi
  
else
	if  [[ $1 = "-i" ]]; then
	echo "  ${BATTERY_POWER}%"
	else
	echo "${BATTERY_POWER}%"
	fi
fi

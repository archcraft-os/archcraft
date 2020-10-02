#!/usr/bin/env bash

# Script to fix OS Name

checkname="$(cat /etc/os-release | grep -i NAME | head -n 1 | sed 's/NAME=//' | tr -d \")"
checkjson="$(pacman -Q jsoncpp | awk '{print $2}')"

check_os_name() {
	if [[ "$checkname" != "Archcraft" ]]; then
		if [[ "$DESKTOP_SESSION" == "bspwm" ]]; then
			dunstify -u critical -i /usr/share/icons/Hybrid/emblems/22/vcs-conflicting.svg "Issue Found!" "Run os_name.sh in terminal to resolve."
		else
			dunstify -u critical -i /usr/share/icons/Hybrid/emblems/22/vcs-conflicting.svg "Issue Found! Go to..." "Preferences > System Status > Fix Issue to resolve."
		fi
	fi
}

check_jsoncpp() {
	vfile="$HOME/.cache/jsoncpp_version"
	prev_ver="$(cat $vfile)"
	if [[ "$checkjson" != "$prev_ver" ]]; then
		dunstify -u critical -i /usr/share/icons/Hybrid/emblems/22/vcs-conflicting.svg "Jsoncpp Updated!" "Please recompile polybar or just install it from AUR (if not working)."
		echo "$checkjson" > "$vfile"
	fi
}

check_os_name
check_jsoncpp

#!/usr/bin/env bash

# pipemenu to fix changed os name

checkname="$(cat /etc/os-release | grep -i NAME | head -n 1 | sed 's/NAME=//' | tr -d \")"

# Lib
if ! . "/usr/lib/archlabs/common/al-include.cfg" 2>/dev/null; then
    echo $"Error: Failed to source /usr/lib/archlabs/common/al-include.cfg" >&2 ; exit 1
fi

gen_menu() {
	menuStart
	if [[ "$checkname" != "Archcraft" ]]; then
		menuItem "Fix Issue" "apps_as_root.sh os_name.sh"
	else
		menuItem "All Good!" "echo"
	fi
	menuEnd
}

{ gen_menu; exit 0; }

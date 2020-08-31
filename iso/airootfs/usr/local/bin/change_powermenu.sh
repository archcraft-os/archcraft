#!/usr/bin/env bash

# Change Powermenu Themes

# Dir
dir="$HOME/.config/rofi"

# Lib
if ! . "/usr/lib/archlabs/common/al-include.cfg" 2>/dev/null; then
    echo $"Error: Failed to source /usr/lib/archlabs/common/al-include.cfg" >&2 ; exit 1
fi

# Available themes
styles=($(ls -p --hide="confirm.rasi" $dir/powermenus | grep -Ev '/'))
themes=($(ls -p --hide="colors.rasi" $dir/powermenus/styles))
check_style=$(cat $dir/bin/powermenu | grep STYLE | head -n 1 | sed 's/STYLE=//' | tr -d \")
check_dir=$(cat $dir/bin/powermenu | grep DIR | head -n 1 | sed 's/DIR=//' | tr -d \")

# Main
gen_menu() {
	local cstyle=1
	local ctheme=1

	menuStart
	menuSeparator "Styles"
	if [[ $check_dir == powermenus ]]; then
		menuItem "> Edit ${check_style}" "geany $dir/powermenus/${check_style}.rasi"
		menuSeparator
	fi
	for style in "${styles[@]}"; do
		menuItem "${cstyle}. ${style%.*}" "sed -i -e 's/DIR=.*/DIR=powermenus/g' $dir/bin/powermenu && sed -i -e "s/STYLE=.*/STYLE=${style%.*}/g" $dir/bin/powermenu"	
		cstyle=$(($cstyle+1))
	done
	menuSeparator "Themes"
	for theme in "${themes[@]}"; do
		menuItem "${ctheme}. ${theme%.*}" "sed -i -e 's/@import .*/@import \"$theme\"/g' $dir/powermenus/styles/colors.rasi"
		ctheme=$(($ctheme+1))
	done
	menuEnd
}

{ gen_menu; exit 0; }

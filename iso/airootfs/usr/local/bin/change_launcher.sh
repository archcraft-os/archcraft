#!/usr/bin/env bash

# Change Rofi Themes

# Dir
dir="$HOME/.config/rofi"

# Lib
if ! . "/usr/lib/archlabs/common/al-include.cfg" 2>/dev/null; then
    echo $"Error: Failed to source /usr/lib/archlabs/common/al-include.cfg" >&2 ; exit 1
fi

# Available themes
styles=($(ls -p $dir/launchers | grep -Ev '/'))
themes=($(ls -p --hide="colors.rasi" $dir/launchers/styles))
check_style=$(cat $dir/bin/launcher | grep STYLE | head -n 1 | sed 's/STYLE=//' | tr -d \")
check_dir=$(cat $dir/bin/launcher | grep DIR | head -n 1 | sed 's/DIR=//' | tr -d \")

# Main
gen_menu() {
	local cstyle=1
	local ctheme=1

	menuStart
	menuSeparator "Styles"
	if [[ $check_dir == launchers ]]; then
		menuItem "> Edit ${check_style}" "geany $dir/launchers/${check_style}.rasi"
		menuSeparator
	fi
	for style in "${styles[@]}"; do
		menuItem "${cstyle}. ${style%.*}" "sed -i -e 's/DIR=.*/DIR=launchers/g' $dir/bin/launcher && sed -i -e "s/STYLE=.*/STYLE=${style%.*}/g" $dir/bin/launcher"	
		cstyle=$(($cstyle+1))
	done
	if [[ $check_style == Ribbon_* ]]; then
	menuSeparator "Themes"
	for theme in "${themes[@]}"; do
		menuItem "${ctheme}. ${theme%.*}" "sed -i -e 's/@import .*/@import \"$theme\"/g' $dir/launchers/styles/colors.rasi"
		ctheme=$(($ctheme+1))
	done
	fi
	menuEnd
}

{ gen_menu; exit 0; }

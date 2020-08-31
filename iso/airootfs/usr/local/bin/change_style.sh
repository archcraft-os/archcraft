#!/usr/bin/env bash

## Change Openbox Styles

# Dir
dir="$HOME/.config/openbox/styles"

# Lib
if ! . "/usr/lib/archlabs/common/al-include.cfg" 2>/dev/null; then
    echo $"Error: Failed to source /usr/lib/archlabs/common/al-include.cfg" >&2 ; exit 1
fi

# Styles
styles=($(ls -p --hide="Default.sh" $HOME/.config/openbox/styles))

gen_menu () {
    local count=1

	menuStart
	menuItem "Default" "bash $dir/Default.sh"
	menuSeparator 
	for style in "${styles[@]}"; do
		menuItem "${count}. ${style%.*}" "bash $dir/$style"
		count=$(($count+1))
	done
	menuEnd
}

{ gen_menu; exit 0; }

#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Mail   : adi1090x@gmail.com
## Github : @adi1090x
## Reddit : @adi1090x

## Change Openbox Styles

# Dir
dir="$HOME/.config/openbox/styles"

# Lib
if ! . "/usr/lib/archlabs/common/al-include.cfg" 2>/dev/null; then
    echo $"Error: Failed to source /usr/lib/archlabs/common/al-include.cfg" >&2 ; exit 1
fi

# Styles
styles=($(ls $HOME/.config/openbox/styles))

gen_menu () {
	menuStart
	for style in "${styles[@]}"; do
		menuItem "${style%.*}" "bash $dir/$style"	
	done
	menuEnd
}

{ gen_menu; exit 0; }

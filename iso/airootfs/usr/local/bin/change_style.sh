#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Mail   : adi1090x@gmail.com
## Github : @adi1090x
## Reddit : @adi1090x

## Change fonts for various applications

# Dir
dir="$HOME/.config/openbox/styles"

# Lib
if ! . "/usr/lib/archlabs/common/al-include.cfg" 2>/dev/null; then
    echo $"Error: Failed to source /usr/lib/archlabs/common/al-include.cfg" >&2 ; exit 1
fi

if [[ "$1" == "--forest" ]]; then
	$dir/forest.sh
elif [[ "$1" == "--slime" ]]; then
	$dir/slime.sh
elif [[ "$1" == "--beach" ]]; then
	$dir/beach.sh
elif [[ "$1" == "--grid" ]]; then
	$dir/grid.sh
elif [[ "$1" == "--spark" ]]; then
	$dir/spark.sh
elif [[ "$1" == "--manhattan" ]]; then
	$dir/manhattan.sh
elif [[ "$1" == "--wave" ]]; then
	$dir/wave.sh
else
    menuStart
        menuItem 'Forest' "$0 --forest"
        menuItem 'Slime' "$0 --slime"
        menuItem 'Beach' "$0 --beach"
        menuItem 'Grid' "$0 --grid"
        menuItem 'Spark' "$0 --spark"
        menuItem 'Manhattan' "$0 --manhattan"
        menuItem 'Wave' "$0 --wave"
    menuEnd
fi

exit 0

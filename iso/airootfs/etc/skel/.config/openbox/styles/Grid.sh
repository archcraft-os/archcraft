#!/usr/bin/env bash

## Dirs #############################################
polybar_path="$HOME/.config/polybar"
rofi_path="$HOME/.config/rofi"
termite_path="$HOME/.config/termite"
geany_path="$HOME/.config/geany"
openbox_path="$HOME/.config/openbox"
dunst_path="$HOME/.config/dunst"

# wallpaper ---------------------------------
nitrogen --save --set-zoom-fill /usr/share/backgrounds/bg_4.png

# polybar ---------------------------------
sed -i -e 's/STYLE=.*/STYLE="grid"/g' $polybar_path/launch.sh
sed -i -e 's/font-0 = .*/font-0 = "Terminus:Medium:size=9;2"/g' $polybar_path/grid/config.ini

cat > $polybar_path/grid/colors.ini << _EOF_
;; _-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
;;
;;	   ______      __               
;;	  / ____/___  / /___  __________
;;	 / /   / __ \/ / __ \/ ___/ ___/
;;	/ /___/ /_/ / / /_/ / /  (__  ) 
;;	\____/\____/_/\____/_/  /____/  
;;
;;  Created By Aditya Shakya @adi1090x
;;
;; _-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_

[color]

BG = #01161B
BGM = #007B82
FG = #CFD8DC

;; _-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
_EOF_

# relaunch polybar
$polybar_path/launch.sh

# rofi ---------------------------------
sed -i -e 's/STYLE=.*/STYLE="grid"/g' "$rofi_path/bin/mpd" "$rofi_path/bin/network" "$rofi_path/bin/screenshot"
sed -i -e 's/DIR=.*/DIR="grid"/g' "$rofi_path/bin/launcher" "$rofi_path/bin/powermenu"
sed -i -e 's/STYLE=.*/STYLE="launcher"/g' "$rofi_path/bin/launcher"
sed -i -e 's/STYLE=.*/STYLE="powermenu"/g' "$rofi_path/bin/powermenu"
sed -i -e 's/font:.*/font:				 	"Terminus Medium 9";/g' "$rofi_path/grid/font.rasi"

cat > $rofi_path/grid/colors.rasi << _EOF_
/* Color-Scheme */

* {
    BG:    #01161Bff;
    BGA:   #263238ff;
    FG:    #A3B5B8ff;
    SEL:   #007B82ff;
    UGT:   #EC407Aff;
	ON:    #61C766ff;
	OFF:   #EC7875ff;
}
_EOF_

sed -i -e 's/font:.*/font:				 	"Terminus Medium 9";/g' "$rofi_path/dialogs/askpass.rasi" "$rofi_path/dialogs/confirm.rasi"
sed -i -e 's/border:.*/border:					1px;/g' "$rofi_path/dialogs/askpass.rasi" "$rofi_path/dialogs/confirm.rasi"
cat > $rofi_path/dialogs/colors.rasi << _EOF_
/* Color-Scheme */

* {
    BG:    #01161Bff;
    FG:    #A3B5B8ff;
    BDR:   #007B82ff;
}
_EOF_

# Network Manager ---------------------------------
sed -i -e 's#dmenu_command = .*#dmenu_command = rofi -dmenu -theme grid/networkmenu.rasi#g' "$HOME"/.config/networkmanager-dmenu/config.ini

# termite ---------------------------------
sed -i -e 's/font = .*/font = Terminus Medium 9/g' $termite_path/config
sed -i '/colors/Q' $termite_path/config

cat >> $termite_path/config << _EOF_
[colors]

# Special
background=#01161B
foreground=#a3b5b8
cursor=#a3b5b8

# black
color0=#01161B
color8=#727e80

# red
color1=#275155
color9=#275155

# green
color2=#06686E
color10=#06686E

# yellow
color3=#1F6066
color11=#1F6066

# blue
color4=#4A6A6D
color12=#4A6A6D

# magenta
color5=#017B83
color13=#017B83

# cyan
color6=#357D80
color14=#357D80

# white
color7=#a3b5b8
color15=#a3b5b8
_EOF_

# alt config
cp "$termite_path"/config "$termite_path"/config_easy
sed -i -e 's/font = .*/font = Iosevka Custom 9/g' $termite_path/config_easy

# reload settings
killall -USR1 termite

# geany ---------------------------------
sed -i -e 's/color_scheme=.*/color_scheme=grid.conf/g' "$geany_path"/geany.conf
sed -i -e 's/editor_font=.*/editor_font=Terminus Medium 9/g' "$geany_path"/geany.conf

# gtk theme, icons and fonts ---------------------------------
xfconf-query -c xsettings -p /Net/ThemeName -s "grid"
xfconf-query -c xsettings -p /Net/IconThemeName -s "grid"
xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "grid"
xfconf-query -c xsettings -p /Gtk/FontName -s "Terminus Medium 9"

# openbox ---------------------------------
obconfig () {
	namespace="http://openbox.org/3.4/rc"
	config="$openbox_path/rc.xml"
	theme="grid"
	layout="LC"
	font="Terminus"
	fontsize="9"

	# Theme
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:name' -v "$theme" "$config"

	# Title
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:titleLayout' -v "$layout" "$config"

	# Fonts
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveWindow"]/a:name' -v "$font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveWindow"]/a:size' -v "$fontsize" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveWindow"]/a:weight' -v Bold "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveWindow"]/a:slant' -v Normal "$config"

	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveWindow"]/a:name' -v "$font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveWindow"]/a:size' -v "$fontsize" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveWindow"]/a:weight' -v Normal "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveWindow"]/a:slant' -v Normal "$config"

	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuHeader"]/a:name' -v "$font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuHeader"]/a:size' -v "$fontsize" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuHeader"]/a:weight' -v Bold "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuHeader"]/a:slant' -v Normal "$config"

	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuItem"]/a:name' -v "$font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuItem"]/a:size' -v "$fontsize" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuItem"]/a:weight' -v Normal "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuItem"]/a:slant' -v Normal "$config"

	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveOnScreenDisplay"]/a:name' -v "$font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveOnScreenDisplay"]/a:size' -v "$fontsize" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveOnScreenDisplay"]/a:weight' -v Bold "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveOnScreenDisplay"]/a:slant' -v Normal "$config"

	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveOnScreenDisplay"]/a:name' -v "$font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveOnScreenDisplay"]/a:size' -v "$fontsize" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveOnScreenDisplay"]/a:weight' -v Normal "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveOnScreenDisplay"]/a:slant' -v Normal "$config"

	# Margins
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:margins/a:top' -v 0 "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:margins/a:bottom' -v 10 "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:margins/a:left' -v 10 "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:margins/a:right' -v 10 "$config"
}

obconfig && openbox --reconfigure

# dunst ---------------------------------
sed -i -e 's/geometry = .*/geometry = "250x50-10+38"/g' $dunst_path/dunstrc
sed -i -e 's/font = .*/font = Terminus Medium 9/g' $dunst_path/dunstrc
sed -i -e 's/frame_width = .*/frame_width = 1/g' $dunst_path/dunstrc

cat > $dunst_path/sid << _EOF_
Dark
_EOF_

sed -i '/urgency_low/Q' $dunst_path/dunstrc
cat >> $dunst_path/dunstrc << _EOF_
[urgency_low]
timeout = 2
background = "#01161B"
foreground = "#A3B5B8"
frame_color = "#007B82"

[urgency_normal]
timeout = 5
background = "#01161B"
foreground = "#A3B5B8"
frame_color = "#007B82"

[urgency_critical]
timeout = 0
background = "#01161B"
foreground = "#007B82"
frame_color = "#007B82"
_EOF_

pkill dunst && dunst &

# Plank ---------------------------------
cat > $HOME/.cache/plank.conf << _EOF_
[dock1]
alignment='center'
auto-pinning=true
current-workspace-only=false
dock-items=['xfce-settings-manager.dockitem', 'exo-file-manager.dockitem', 'termite.dockitem']
hide-delay=0
hide-mode='auto'
icon-size=32
items-alignment='center'
lock-items=false
monitor=''
offset=95
pinned-only=false
position='right'
pressure-reveal=false
show-dock-item=false
theme='Transparent'
tooltips-enabled=true
unhide-delay=0
zoom-enabled=true
zoom-percent=120
_EOF_

# reload settings
cat $HOME/.cache/plank.conf | dconf load /net/launchpad/plank/docks/

# Other ---------------------------------
sed -i -e 's/progressbar_color = .*/progressbar_color = "black"/g' $HOME/.ncmpcpp/config

## EOF #############################################

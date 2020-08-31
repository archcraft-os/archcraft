#!/usr/bin/env bash

## Dirs #############################################
polybar_path="$HOME/.config/polybar"
rofi_path="$HOME/.config/rofi"
termite_path="$HOME/.config/termite"
geany_path="$HOME/.config/geany"
openbox_path="$HOME/.config/openbox"
dunst_path="$HOME/.config/dunst"

# wallpaper ---------------------------------
nitrogen --save --set-zoom-fill /usr/share/backgrounds/bg_3.jpg

# polybar ---------------------------------
sed -i -e 's/STYLE=.*/STYLE="beach"/g' $polybar_path/launch.sh
sed -i -e 's/font-0 = .*/font-0 = "Terminus:size=8;3"/g' $polybar_path/beach/config.ini

# relaunch polybar
$polybar_path/launch.sh

# rofi ---------------------------------
sed -i -e 's/STYLE=.*/STYLE="beach"/g' "$rofi_path/bin/mpd" "$rofi_path/bin/network" "$rofi_path/bin/screenshot"
sed -i -e 's/DIR=.*/DIR="beach"/g' "$rofi_path/bin/launcher" "$rofi_path/bin/powermenu"
sed -i -e 's/STYLE=.*/STYLE="launcher"/g' "$rofi_path/bin/launcher"
sed -i -e 's/STYLE=.*/STYLE="powermenu"/g' "$rofi_path/bin/powermenu"
sed -i -e 's/font:.*/font:				 	"Terminus 9";/g' "$rofi_path/beach/font.rasi"

sed -i -e 's/font:.*/font:				 	"Terminus 9";/g' "$rofi_path/dialogs/askpass.rasi" "$rofi_path/dialogs/confirm.rasi"
sed -i -e 's/border:.*/border:					0px;/g' "$rofi_path/dialogs/askpass.rasi" "$rofi_path/dialogs/confirm.rasi"
cat > $rofi_path/dialogs/colors.rasi << _EOF_
/* Color-Scheme */

* {
    BG:    #141c21ff;
    FG:    #93a1a1ff;
    BDR:   #2587ccff;
}
_EOF_

# Network Manager ---------------------------------
sed -i -e 's#dmenu_command = .*#dmenu_command = rofi -dmenu -theme beach/networkmenu.rasi#g' "$HOME"/.config/networkmanager-dmenu/config.ini

# termite ---------------------------------
sed -i -e 's/font = .*/font = Terminus 9/g' $termite_path/config
sed -i '/colors/Q' $termite_path/config

cat >> $termite_path/config << _EOF_
[colors]

foreground = #93a1a1
background = #141c21
cursor = #afbfbf

#black
color0 = #263640
color8 = #4a697d

#red
color1 = #d12f2c
color9 = #fa3935

#green
color2 = #819400
color10 = #a4bd00

#yellow
color3 = #b08500
color11 = #d9a400

#blue
color4 = #2587cc
color12 = #2ca2f5

#magenta
color5 = #696ebf
color13 = #8086e8

#cyan
color6 = #289c93
color14 = #33c5ba

#white
color7 = #bfbaac
color15 = #fdf6e3
_EOF_

# alt config
cp "$termite_path"/config "$termite_path"/config_easy
sed -i -e 's/font = .*/font = Iosevka Custom 9/g' $termite_path/config_easy

# reload settings
killall -USR1 termite

# geany ---------------------------------
sed -i -e 's/color_scheme=.*/color_scheme=github.conf/g' "$geany_path"/geany.conf
sed -i -e 's/editor_font=.*/editor_font=Terminus 9/g' "$geany_path"/geany.conf

# gtk theme, icons and fonts ---------------------------------
xfconf-query -c xsettings -p /Net/ThemeName -s "Arc"
xfconf-query -c xsettings -p /Net/IconThemeName -s "Arc"
xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "Arc"
xfconf-query -c xsettings -p /Gtk/FontName -s "Terminus 9"

# openbox ---------------------------------
obconfig () {
	namespace="http://openbox.org/3.4/rc"
	config="$openbox_path/rc.xml"
	theme="beach"
	layout="CLM"
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
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:margins/a:top' -v 20 "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:margins/a:bottom' -v 0 "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:margins/a:left' -v 20 "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:margins/a:right' -v 20 "$config"
}

obconfig && openbox --reconfigure

# dunst ---------------------------------
sed -i -e 's/geometry = .*/geometry = "300x60-20-50"/g' $dunst_path/dunstrc
sed -i -e 's/font = .*/font = Terminus 9/g' $dunst_path/dunstrc
sed -i -e 's/frame_width = .*/frame_width = 0/g' $dunst_path/dunstrc

cat > $dunst_path/sid << _EOF_
Dark
_EOF_

sed -i '/urgency_low/Q' $dunst_path/dunstrc
cat >> $dunst_path/dunstrc << _EOF_
[urgency_low]
timeout = 4
background = "#141c21"
foreground = "#93a1a1"
frame_color = "#141c21"

[urgency_normal]
timeout = 8
background = "#141c21"
foreground = "#93a1a1"
frame_color = "#141c21"

[urgency_critical]
timeout = 0
background = "#141c21"
foreground = "#d42434"
frame_color = "#141c21"
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
offset=80
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

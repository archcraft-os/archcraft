#!/usr/bin/env bash

## Dirs #############################################
polybar_path="$HOME/.config/polybar"
rofi_path="$HOME/.config/rofi"
termite_path="$HOME/.config/termite"
geany_path="$HOME/.config/geany"
openbox_path="$HOME/.config/openbox"
dunst_path="$HOME/.config/dunst"

# wallpaper ---------------------------------
nitrogen --save --set-zoom-fill /usr/share/backgrounds/bg_5.jpg

# polybar ---------------------------------
sed -i -e 's/STYLE=.*/STYLE="spark"/g' $polybar_path/launch.sh
sed -i -e 's/font-0 = .*/font-0 = "Iosevka Nerd Font:size=10;3"/g' $polybar_path/spark/config.ini

# relaunch polybar
$polybar_path/launch.sh

# rofi ---------------------------------
sed -i -e 's/STYLE=.*/STYLE="spark"/g' "$rofi_path/bin/mpd" "$rofi_path/bin/network" "$rofi_path/bin/screenshot"
sed -i -e 's/DIR=.*/DIR="spark"/g' "$rofi_path/bin/launcher" "$rofi_path/bin/powermenu"
sed -i -e 's/STYLE=.*/STYLE="launcher"/g' "$rofi_path/bin/launcher"
sed -i -e 's/STYLE=.*/STYLE="powermenu"/g' "$rofi_path/bin/powermenu"
sed -i -e 's/font:.*/font:				 	"Iosevka 10";/g' "$rofi_path/spark/font.rasi"

sed -i -e 's/font:.*/font:				 	"Iosevka 10";/g' "$rofi_path/dialogs/askpass.rasi" "$rofi_path/dialogs/confirm.rasi"
sed -i -e 's/border:.*/border:					0px;/g' "$rofi_path/dialogs/askpass.rasi" "$rofi_path/dialogs/confirm.rasi"
cat > $rofi_path/dialogs/colors.rasi << _EOF_
/* Color-Scheme */

* {
    BG:    #EDFEFEff;
    FG:    #303030ff;
    BDR:   #EF2D6Dff;
}
_EOF_

# Network Manager ---------------------------------
sed -i -e 's#dmenu_command = .*#dmenu_command = rofi -dmenu -theme spark/networkmenu.rasi#g' "$HOME"/.config/networkmanager-dmenu/config.ini

# termite ---------------------------------
sed -i -e 's/font = .*/font = Iosevka Custom 9/g' $termite_path/config
sed -i '/colors/Q' $termite_path/config

cat >> $termite_path/config << _EOF_
[colors]

background = #1E2541
foreground = #EEFFFF
cursor = #EEFFFF

color0 = #1E2541
color1 = #F0719B
color2 = #5AF7B0
color3 = #FFA56B
color4 = #57C7FF
color5 = #C792EA
color6 = #89DDFF
color7 = #EEFFFF
color8 = #354274
color9 = #F02E6E
color10 = #2CE592
color11 = #FF8537
color12 = #1DA0E2
color13 = #A742EA
color14 = #47BAE8
color15 = #DEE6E7
color16 = #2A335A
_EOF_

# alt config
cp "$termite_path"/config "$termite_path"/config_easy
sed -i -e 's/font = .*/font = Noto Sans Mono 10/g' $termite_path/config_easy

# reload settings
killall -USR1 termite

# geany ---------------------------------
sed -i -e 's/color_scheme=.*/color_scheme=spark.conf/g' "$geany_path"/geany.conf
sed -i -e 's/editor_font=.*/editor_font=Iosevka Custom 10/g' "$geany_path"/geany.conf

# gtk theme, icons and fonts ---------------------------------
xfconf-query -c xsettings -p /Net/ThemeName -s "spark"
xfconf-query -c xsettings -p /Net/IconThemeName -s "Hybrid_Light"
xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "Hybrid_Light"
xfconf-query -c xsettings -p /Gtk/FontName -s "Noto Sans 8"

# openbox ---------------------------------
obconfig () {
	namespace="http://openbox.org/3.4/rc"
	config="$openbox_path/rc.xml"
	theme="spark"
	layout="LIMC"
	font="Noto Sans"
	fontsize="8"

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
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:margins/a:top' -v 8 "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:margins/a:bottom' -v 0 "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:margins/a:left' -v 8 "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:margins/a:right' -v 8 "$config"
}

obconfig && openbox --reconfigure

# dunst ---------------------------------
sed -i -e 's/geometry = .*/geometry = "280x50-20+20"/g' $dunst_path/dunstrc
sed -i -e 's/font = .*/font = Iosevka Custom 9/g' $dunst_path/dunstrc
sed -i -e 's/frame_width = .*/frame_width = 0/g' $dunst_path/dunstrc

cat > $dunst_path/sid << _EOF_
Light
_EOF_

sed -i '/urgency_low/Q' $dunst_path/dunstrc
cat >> $dunst_path/dunstrc << _EOF_
[urgency_low]
timeout = 4
background = "#EDFEFE"
foreground = "#303030"
frame_color = "#EDFEFE"

[urgency_normal]
timeout = 8
background = "#EDFEFE"
foreground = "#303030"
frame_color = "#EDFEFE"

[urgency_critical]
timeout = 0
background = "#EDFEFE"
foreground = "#EF2D6D"
frame_color = "#EDFEFE"
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
offset=0
pinned-only=false
position='right'
pressure-reveal=false
show-dock-item=false
theme='Transparent'
tooltips-enabled=true
unhide-delay=0
zoom-enabled=true
zoom-percent=130
_EOF_

# reload settings
cat $HOME/.cache/plank.conf | dconf load /net/launchpad/plank/docks/

# Other ---------------------------------
sed -i -e 's/progressbar_color = .*/progressbar_color = "black"/g' $HOME/.ncmpcpp/config

## EOF #############################################

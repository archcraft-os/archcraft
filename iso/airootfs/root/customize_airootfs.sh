#!/usr/bin/env bash
#
# SPDX-License-Identifier: GPL-3.0-or-later

set -e -u

# Warning: customize_airootfs.sh is deprecated! Support for it will be removed in a future archiso version.
# Still works in archiso 54-1

## -------------------------------------------------------------- ##

## Append archcraft repository to pacman.conf
cat >> "/etc/pacman.conf" <<- EOL

[multilib]
Include = /etc/pacman.d/mirrorlist

## Archcraft Repository
[archcraft]
SigLevel = Optional TrustAll
Server = https://archcraft-os.github.io/archcraft-pkgs/\$arch
EOL

## -------------------------------------------------------------- ##

## Copy Few Configs Into Root Dir
rdir="/root/.config"
sdir="/etc/skel"
if [[ ! -d "$rdir" ]]; then
	mkdir "$rdir"
fi

rconfig=(alacritty bspwm geany gtk-3.0 Kvantum leafpad libfm pcmanfm qt5ct ranger Thunar xfce4)
for cfg in "${rconfig[@]}"; do
	cp -rf "$sdir"/.config/"$cfg" "$rdir"
done

rcfg=('.oh-my-zsh' '.gtkrc-2.0' '.vimrc' '.zshrc')
for cfile in "${rcfg[@]}"; do
	cp -rf "$sdir"/"$cfile" /root
done

## -------------------------------------------------------------- ##

## Modify Calamares Desktop File
calamares='/usr/share/applications/calamares.desktop'

sed -i -e 's#Exec=sh.*#Exec=sh -c "/etc/calamares/launch.sh"#g' "$calamares"
sed -i -e 's#Name=.*#Name=Install Archcraft#g' "$calamares"
sed -i -e 's#GenericName=.*#GenericName=System Installer#g' "$calamares"
sed -i -e 's#Icon=.*#Icon=archcraft#g' "$calamares"
sed -i -e 's#Comment=.*#Comment=Archcraft System Installer#g' "$calamares"

## -------------------------------------------------------------- ##

## Modify Timeshift Desktop File

sed -i -e 's#Exec=timeshift-launcher#Exec=apps_as_root.sh timeshift-gtk#g' /usr/share/applications/timeshift-gtk.desktop

## -------------------------------------------------------------- ##

## Hide Unnecessary Apps
adir="/usr/share/applications"
apps=(avahi-discover.desktop bssh.desktop bvnc.desktop compton.desktop echomixer.desktop \
	envy24control.desktop exo-mail-reader.desktop exo-preferred-applications.desktop feh.desktop gparted.desktop \
	hdajackretask.desktop hdspconf.desktop hdspmixer.desktop hwmixvolume.desktop lftp.desktop \
	libfm-pref-apps.desktop lxshortcut.desktop lstopo.desktop mimeinfo.cache \
	networkmanager_dmenu.desktop nm-connection-editor.desktop pcmanfm-desktop-pref.desktop \
	qv4l2.desktop qvidcap.desktop stoken-gui.desktop stoken-gui-small.desktop thunar-bulk-rename.desktop \
	thunar-settings.desktop thunar-volman-settings.desktop yad-icon-browser.desktop)

for app in "${apps[@]}"; do
	if [[ -f "$adir/$app" ]]; then
		sed -i '$s/$/\nNoDisplay=true/' "$adir/$app"
	fi
done

## -------------------------------------------------------------- ##

## Other Stuff
cp /usr/bin/networkmanager_dmenu /usr/local/bin/nmd && sed -i 's/config.ini/nmd.ini/g' /usr/local/bin/nmd
rm -rf /usr/share/xsessions/openbox-kde.desktop /usr/share/applications/xfce4-about.desktop
rm -rf /usr/share/pixmaps/archlinux.png /usr/share/pixmaps/archlinux.svg

#!/usr/bin/env bash
#
# SPDX-License-Identifier: GPL-3.0-or-later

set -e -u

# Warning: customize_airootfs.sh is deprecated! Support for it will be removed in a future archiso version.
# Still works in archiso 54-1

## -------------------------------------------------------------- ##

## Enable Parallel Downloads
sed -i -e 's|#ParallelDownloads.*|ParallelDownloads = 6|g' /etc/pacman.conf
sed -i -e '/#\[testing\]/Q' /etc/pacman.conf

## Append archcraft repository to pacman.conf
cat >> "/etc/pacman.conf" <<- EOL
	## Archcraft Repository
	[archcraft]
	SigLevel = Optional TrustAll
	Server = https://archcraft.io/archcraft-pkgs/\$arch

	#[testing]
	#Include = /etc/pacman.d/mirrorlist

	[core]
	Include = /etc/pacman.d/mirrorlist

	[extra]
	Include = /etc/pacman.d/mirrorlist

	#[community-testing]
	#Include = /etc/pacman.d/mirrorlist

	[community]
	Include = /etc/pacman.d/mirrorlist

	# If you want to run 32 bit applications on your x86_64 system,
	# enable the multilib repositories as required here.

	#[multilib-testing]
	#Include = /etc/pacman.d/mirrorlist

	[multilib]
	Include = /etc/pacman.d/mirrorlist

	# An example of a custom package repository.  See the pacman manpage for
	# tips on creating your own repositories.
	#[custom]
	#SigLevel = Optional TrustAll
	#Server = file:///home/custompkgs
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

## Remove thunar wallpaper plugin
rm -rf /usr/lib/thunarx-3/thunar-wallpaper-plugin.so

## -------------------------------------------------------------- ##

## Hide Unnecessary Apps
adir="/usr/share/applications"
apps=(avahi-discover.desktop bssh.desktop bvnc.desktop compton.desktop echomixer.desktop \
	envy24control.desktop exo-mail-reader.desktop exo-preferred-applications.desktop feh.desktop \
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
rm -rf /usr/share/pixmaps/{archlinux.png,archlinux.svg,archlinux-logo.png,archlinux-logo.svg}

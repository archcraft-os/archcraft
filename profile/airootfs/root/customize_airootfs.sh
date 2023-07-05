#!/usr/bin/env bash

## Script to perform several important tasks before `mkarchcraftiso` create filesystem image.

set -e -u

## -------------------------------------------------------------- ##

## Fix Initrd Generation in Installed System
cat > "/etc/mkinitcpio.d/linux.preset" <<- _EOF_
	# mkinitcpio preset file for the 'linux' package

	ALL_kver="/boot/vmlinuz-linux"
	ALL_config="/etc/mkinitcpio.conf"

	PRESETS=('default' 'fallback')

	#default_config="/etc/mkinitcpio.conf"
	default_image="/boot/initramfs-linux.img"
	#default_options=""

	#fallback_config="/etc/mkinitcpio.conf"
	fallback_image="/boot/initramfs-linux-fallback.img"
	fallback_options="-S autodetect"    
_EOF_

## -------------------------------------------------------------- ##

## Enable Parallel Downloads
sed -i -e 's|#ParallelDownloads.*|ParallelDownloads = 5|g' /etc/pacman.conf
sed -i -e '/#\[core-testing\]/Q' /etc/pacman.conf

## Append archcraft repository to pacman.conf
cat >> "/etc/pacman.conf" <<- EOL
	[archcraft]
	SigLevel = Optional TrustAll
	Include = /etc/pacman.d/archcraft-mirrorlist

	#[core-testing]
	#Include = /etc/pacman.d/mirrorlist

	[core]
	Include = /etc/pacman.d/mirrorlist

	#[extra-testing]
	#Include = /etc/pacman.d/mirrorlist

	[extra]
	Include = /etc/pacman.d/mirrorlist

	# If you want to run 32 bit applications on your x86_64 system,
	# enable the multilib repositories as required here.

	#[multilib-testing]
	#Include = /etc/pacman.d/mirrorlist

	#[multilib]
	#Include = /etc/pacman.d/mirrorlist

	# An example of a custom package repository.  See the pacman manpage for
	# tips on creating your own repositories.
	#[custom]
	#SigLevel = Optional TrustAll
	#Server = file:///home/custompkgs
EOL

## -------------------------------------------------------------- ##

## Set zsh as default shell for new user
sed -i -e 's#SHELL=.*#SHELL=/bin/zsh#g' /etc/default/useradd

## -------------------------------------------------------------- ##

## Copy Few Configs Into Root Dir
rdir="/root/.config"
sdir="/etc/skel"
if [[ ! -d "$rdir" ]]; then
	mkdir "$rdir"
fi

rconfig=(alacritty bspwm geany gtk-3.0 Kvantum neofetch qt5ct ranger Thunar xfce4)
for cfg in "${rconfig[@]}"; do
	if [[ -e "$sdir/.config/$cfg" ]]; then
		cp -rf "$sdir"/.config/"$cfg" "$rdir"
	fi
done

rcfg=('.oh-my-zsh' '.gtkrc-2.0' '.vim_runtime' '.vimrc' '.zshrc')
for cfile in "${rcfg[@]}"; do
	if [[ -e "$sdir/$cfile" ]]; then
		cp -rf "$sdir"/"$cfile" /root
	fi
done

## -------------------------------------------------------------- ##

## Don't launch welcome app on installed system, launch Help instead
sed -i -e '/## Welcome-App-Run-Once/Q' /etc/skel/.config/openbox/autostart
cat >> "/etc/skel/.config/openbox/autostart" <<- EOL
	## Help-App-Run-Once
	help-and-tips &
	sed -i -e '/## Help-App-Run-Once/Q' "\$HOME"/.config/openbox/autostart
EOL

sed -i -e '/## Welcome-App-Run-Once/Q' /etc/skel/.config/bspwm/bspwmrc
cat >> "/etc/skel/.config/bspwm/bspwmrc" <<- EOL
	## Help-App-Run-Once
	help-and-tips &
	sed -i -e '/## Help-App-Run-Once/Q' "\$HOME"/.config/bspwm/bspwmrc
EOL


## -------------------------------------------------------------- ##

## Fix cursor theme
rm -rf /usr/share/icons/default

## Update xdg-user-dirs for bookmarks in thunar and pcmanfm
runuser -l liveuser -c 'xdg-user-dirs-update'
runuser -l liveuser -c 'xdg-user-dirs-gtk-update'
xdg-user-dirs-update
xdg-user-dirs-gtk-update

## Delete stupid gnome backgrounds
gndir='/usr/share/backgrounds/gnome'
if [[ -d "$gndir" ]]; then
	rm -rf "$gndir"
fi

## -------------------------------------------------------------- ##

## Hide Unnecessary Apps
adir="/usr/share/applications"
apps=(avahi-discover.desktop bssh.desktop bvnc.desktop echomixer.desktop \
	envy24control.desktop exo-preferred-applications.desktop feh.desktop \
	hdajackretask.desktop hdspconf.desktop hdspmixer.desktop hwmixvolume.desktop lftp.desktop \
	libfm-pref-apps.desktop lxshortcut.desktop lstopo.desktop \
	networkmanager_dmenu.desktop nm-connection-editor.desktop pcmanfm-desktop-pref.desktop \
	qv4l2.desktop qvidcap.desktop stoken-gui.desktop stoken-gui-small.desktop thunar-bulk-rename.desktop \
	thunar-settings.desktop thunar-volman-settings.desktop yad-icon-browser.desktop)

for app in "${apps[@]}"; do
	if [[ -e "$adir/$app" ]]; then
		sed -i '$s/$/\nNoDisplay=true/' "$adir/$app"
	fi
done

## -------------------------------------------------------------- ##

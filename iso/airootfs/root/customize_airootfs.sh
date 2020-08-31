#!/usr/bin/env bash
#
# SPDX-License-Identifier: GPL-3.0-or-later

set -e -u

# Warning: customize_airootfs.sh is deprecated! Support for it will be removed in a future archiso version.

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist

## Add liveuser to these groups
#usermod -G "adm,audio,video,floppy,log,network,rfkill,scanner,storage,optical,power,wheel" liveuser

## Disto Info
cat > "/etc/os-release" <<- EOL
	NAME="Archcraft"
	PRETTY_NAME="Archcraft"
	ID=arch
	BUILD_ID=rolling
	ANSI_COLOR="38;2;23;147;209"
	HOME_URL="https://archcraft-os.github.io/"
	LOGO=archcraft
EOL

cat > "/etc/issue" <<- EOL
	Archcraft \r (\l)
EOL

## Append archcraft repository to pacman.conf
cat >> "/etc/pacman.conf" <<- EOL

[multilib]
Include = /etc/pacman.d/mirrorlist

## Archcraft Repository
[archcraft]
SigLevel = Optional TrustAll
Server = https://archcraft-os.github.io/archcraft-pkgs/\$arch
EOL

## Hide Unnecessary Apps
adir="/usr/share/applications"
sed -i '$s/$/\nNoDisplay=true/' $adir/avahi-discover.desktop $adir/bssh.desktop $adir/bvnc.desktop $adir/compton.desktop $adir/echomixer.desktop \
$adir/envy24control.desktop $adir/exo-mail-reader.desktop \
$adir/exo-preferred-applications.desktop $adir/feh.desktop $adir/gparted.desktop \
$adir/hdajackretask.desktop $adir/hdspconf.desktop $adir/hdspmixer.desktop $adir/hwmixvolume.desktop $adir/lftp.desktop \
$adir/libfm-pref-apps.desktop $adir/lxshortcut.desktop $adir/lstopo.desktop $adir/mimeinfo.cache \
$adir/networkmanager_dmenu.desktop $adir/nm-connection-editor.desktop $adir/pcmanfm-desktop-pref.desktop \
$adir/qv4l2.desktop $adir/qvidcap.desktop $adir/stoken-gui.desktop $adir/stoken-gui-small.desktop $adir/thunar-bulk-rename.desktop \
$adir/thunar-settings.desktop $adir/thunar-volman-settings.desktop $adir/yad-icon-browser.desktop

## Other Stuff
cp /usr/bin/networkmanager_dmenu /usr/local/bin/nmd && sed -i 's/config.ini/nmd.ini/g' /usr/local/bin/nmd
sed -i -e 's/Inherits=.*/Inherits=Hybrid_Light,Papirus,Moka,Adwaita,hicolor/g' /usr/share/icons/Arc/index.theme
rm -rf /usr/share/xsessions/openbox-kde.desktop /usr/share/applications/xfce4-about.desktop /usr/share/pixmaps/archlinux.png /usr/share/pixmaps/archlinux.svg

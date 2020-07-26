#!/bin/bash

#-- Main --------------------#
set -e -u

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

usermod -s /usr/bin/zsh root

sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist

#-- Archcraft --------------------#

## Liveuser
useradd -m -p $(openssl passwd liveuser) -g users -G "adm,audio,video,floppy,log,network,rfkill,scanner,storage,optical,power,wheel" -s /bin/zsh liveuser
chown -R liveuser:users /home/liveuser

## Services
systemctl set-default graphical.target
systemctl enable NetworkManager.service 
systemctl enable wpa_supplicant.service
systemctl enable lxdm-plymouth.service
systemctl enable betterlockscreen@$USER

## Mods
sed -i -e 's/MODULES=()/MODULES=(i915? amdgpu? radeon? nouveau? vboxvideo? vmwgfx?)/g' /etc/mkinitcpio.conf
sed -i -e 's/HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)/HOOKS=(base udev plymouth plymouth-encrypt modconf block filesystems keyboard fsck)/g' /etc/mkinitcpio.conf
cp /usr/bin/networkmanager_dmenu /usr/local/bin/nmd && sed -i 's/config.ini/nmd.ini/g' /usr/local/bin/nmd
sed -i -e 's/Inherits=.*/Inherits=Hybrid_Light,Papirus,Moka,Adwaita,hicolor/g' /usr/share/icons/Arc/index.theme

## Disto Info
cat > /etc/os-release <<EOL
NAME="Archcraft"
PRETTY_NAME="Archcraft"
ID=arch
BUILD_ID=rolling
ANSI_COLOR="38;2;23;147;209"
HOME_URL="https://archcraft-os.github.io/"
LOGO=archcraft
EOL

cat > /etc/issue <<EOL
Archcraft \r (\l)
EOL

## Hide Unnecessary Apps
adir="/usr/share/applications"
sed -i '$s/$/\nNoDisplay=true/' $adir/avahi-discover.desktop $adir/bssh.desktop $adir/bvnc.desktop $adir/compton.desktop $adir/echomixer.desktop \
$adir/elinks.desktop $adir/envy24control.desktop $adir/exo-mail-reader.desktop \
$adir/exo-preferred-applications.desktop $adir/feh.desktop $adir/gparted.desktop \
$adir/hdajackretask.desktop $adir/hdspconf.desktop $adir/hdspmixer.desktop $adir/hwmixvolume.desktop $adir/lftp.desktop \
$adir/libfm-pref-apps.desktop $adir/lxshortcut.desktop $adir/lstopo.desktop $adir/mimeinfo.cache \
$adir/networkmanager_dmenu.desktop $adir/nm-connection-editor.desktop $adir/pcmanfm-desktop-pref.desktop \
$adir/qv4l2.desktop $adir/qvidcap.desktop $adir/stoken-gui.desktop $adir/stoken-gui-small.desktop $adir/thunar-bulk-rename.desktop \
$adir/thunar-settings.desktop $adir/thunar-volman-settings.desktop $adir/yad-icon-browser.desktop

## Other Stuff
rm -rf /usr/share/xsessions/openbox-kde.desktop
rm -rf /usr/share/applications/xfce4-about.desktop
rm -rf /usr/share/pixmaps/archlinux.png /usr/share/pixmaps/archlinux.svg
mv /etc/zsh/zshrc /etc/zsh/zshrc.org

## Delete localrepo lines
sed -i '$d' /etc/pacman.conf && sed -i '$d' /etc/pacman.conf && sed -i '$d' /etc/pacman.conf

<p align="center">
<a href="https://archcraft.io"><img src="https://raw.githubusercontent.com/archcraft-os/archcraft-misc-pkgs/main/archcraft-pixmaps/src/icons/archcraft.png" height="150" width="150" alt="Archcraft"></a>
</p>

<p align="center">
<a href="https://www.buymeacoffee.com/adi1090x"><img width="32px" src="https://raw.githubusercontent.com/adi1090x/files/master/other/1.png" alt="Buy Me A Coffee"></a>
<a href="https://ko-fi.com/adi1090x"><img width="32px" src="https://raw.githubusercontent.com/adi1090x/files/master/other/2.png" alt="Support me on ko-fi"></a>
<a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=U3VK2SSVQWAPN"><img width="32px" src="https://raw.githubusercontent.com/adi1090x/files/master/other/3.png" alt="Support me on Paypal"></a>
<a href="https://www.patreon.com/adi1090x"><img width="32px" src="https://raw.githubusercontent.com/adi1090x/files/master/other/4.png" alt="Support me on Patreon"></a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Maintained%3F-Yes-green?style=flat-square">
  <img src="https://img.shields.io/github/downloads/archcraft-os/releases/total?label=downloads&logo=github&color=blue&style=flat-square">
  <img src="https://img.shields.io/sourceforge/dt/archcraft.svg?label=downloads&logo=sourceforge&color=teal&style=flat-square">
  <img src="https://img.shields.io/github/stars/archcraft-os/archcraft?style=flat-square">
  <img src="https://img.shields.io/github/issues/archcraft-os/archcraft?color=violet&style=flat-square">
</p>

<p align="center">
Yet another minimal Linux distribution, based on <a href="https://www.archlinux.org">Arch Linux</a>.
</p>

<p align="center">
<a href="https://archcraft.io">Homepage</a> | 
<a href="https://archcraft.io/install">Installation</a> | 
<a href="https://archcraft.io/features">Features</a> | 
<a href="https://archcraft.io/gallery">Screenshots</a> | 
<a href="https://archcraft.io/blog">Blog</a> | 
<a href="https://archcraft.io/wiki">Wiki</a>
</p>

![gif](https://raw.githubusercontent.com/archcraft-os/archcraft-os.github.io/master/img/main.gif) <br />

---

### Latest Blog Posts

- [Things To Do After Installing Archcraft OS](https://archcraft.io/blog/post_install)
- [Build Archcraft ISO With Its Source](https://archcraft.io/blog/build)
- [Install Archcraft With Calamares (With Encryption)](https://archcraft.io/blog/calamares)
- [Install Archcraft On UEFI System (With Encryption)](https://archcraft.io/blog/uefi)
- [Install Archcraft On BIOS System (With Encryption)](https://archcraft.io/blog/bios)
- [Create A Bootable USB With Archcraft](https://archcraft.io/blog/usb)
- [Boot Archcraft ISO With GRUB2 Bootloader](https://archcraft.io/blog/grub)

### Get The ISO

**1. Download -** You can download the latest release of `ISO` (see [`releases`](https://github.com/archcraft-os/releases)), Available options are...
<p align="center">
  <a href="https://github.com/archcraft-os/releases/releases/download/v21.06/archcraft-2021.06.06-x86_64.iso" target="_blank"><img alt="undefined" src="https://img.shields.io/badge/Download-Github-blue?style=for-the-badge&logo=github"></a>&nbsp;&nbsp;
  <a href="https://sourceforge.net/projects/archcraft/files/latest/download" target="_blank"><img alt="undefined" src="https://img.shields.io/badge/Download-Sourceforge-orange?style=for-the-badge&logo=sourceforge"></a>&nbsp;&nbsp;
  <a href="https://github.com/archcraft-os/releases/releases/download/v21.06/archcraft-2021.06.06-x86_64.iso.torrent" target="_blank"><img alt="undefined" src="https://img.shields.io/badge/Download-Torrent-magenta?style=for-the-badge&logo=discogs"></a>
</p>
  
**2. Build ISO -** If you're already using archlinux & want to build the iso, maybe with your config then...

***Checklist***
- [ ] **archiso** version: `55-1`
- [ ] At least 10GB of free space
- [ ] Arch Linux 64-bit only
- [ ] Clear pacman cache; ```sudo pacman -Scc```

+ Open a terminal and clone the **archcraft** repository.
```bash
git clone --depth=1 https://github.com/archcraft-os/archcraft.git
```

+ Change to the **archcraft** directory & run `setup.sh`.
```bash
cd archcraft
chmod +x setup.sh
./setup.sh
```

+ Now, Change to the **iso** directory & run `mkarchcraftiso` as **root**.
```bash
cd iso
sudo su
./mkarchcraftiso -v .
```

+ If everything goes well, you'll have the ISO in **iso/out** directory. <br />

> If you want to Rebuild the ISO, remove ***work*** & ***out*** dirs inside `iso` directory first. then run `./mkarchcraftiso -v .` as **root**. You don't need to run `setup.sh` again, it's a one-time process only. 

### Boot The ISO

**1. Using GRUB -** If you're already using a linux distro with grub, then you can add following entry in your `grub.cfg` file, Replace **X** with your partition number, and */path/to/archcraft.iso* with ISO path. <br />
```
menuentry "Archcraft Live ISO" --class archcraft {
    set root='(hd0,X)'
    set isofile="/path/to/archcraft.iso"
    set dri="free"
    search --no-floppy -f --set=root $isofile
    probe -u $root --set=abc
    set pqr="/dev/disk/by-uuid/$abc"
    loopback loop $isofile
    linux  (loop)/arch/boot/x86_64/vmlinuz-linux img_dev=$pqr img_loop=$isofile driver=$dri quiet splash vt.global_cursor_default=0 loglevel=2 rd.systemd.show_status=false rd.udev.log-priority=3 sysrq_always_enabled=1 cow_spacesize=2G
    initrd  (loop)/arch/boot/intel-ucode.img (loop)/arch/boot/amd-ucode.img (loop)/arch/boot/x86_64/initramfs-linux.img
}
```
<br />

**2. Using dd -** Alternatively, you can use ***dd*** command to make a bootable USB_Drive/SDcard, Just open the terminal and... <br />
```bash
sudo su
dd bs=4M if=/path/to/archcraft.iso of=/dev/sdX status=progress oflag=sync
```
<br />

**3. Using Etcher -** In case you are afraid of ***dd***, then you can use [Etcher](https://www.balena.io/etcher/) to make a bootable USB/SDcard.
This supports Windows, Linux, Mac and has a beautiful UI.

### FYI

+ Default `username` and `password` is **liveuser**.
+ After installing Archcraft, run `sudo pacman -Syy` to sync pacman database.
+ If polybar is not showing some icons properly, run `~/.config/polybar/fix_modules.sh` to fix **Battery** & **Network** Modules.
+ You need to enable **os-prober** for Archcraft to detect other installed OS. Edit `/etc/default/grub` file and uncomment `#GRUB_DISABLE_OS_PROBER=false`, then run `sudo grub-mkconfig -o /boot/grub/grub.cfg` to regenerate grub config file.
+ Update the lock screen according to your screen resolution with `betterlockscreen -u /usr/share/backgrounds/wal_10.jpg` if it's messed up.

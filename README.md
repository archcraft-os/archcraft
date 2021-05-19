<p align="center">
<a href="https://archcraft-os.github.io"><img src="https://raw.githubusercontent.com/archcraft-os/archcraft-pkgs/master/archcraft/ac-pixmaps/src/icons/archcraft_circle.png" height="150" width="150" alt="Archcraft"></a>
</p>

<p align="center">
<a href="https://www.buymeacoffee.com/adi1090x"><img width="32px" src="https://raw.githubusercontent.com/adi1090x/files/master/other/1.png" alt="Buy Me A Coffee"></a>
<a href="https://ko-fi.com/adi1090x"><img width="32px" src="https://raw.githubusercontent.com/adi1090x/files/master/other/2.png" alt="Support me on ko-fi"></a>
<a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=U3VK2SSVQWAPN"><img width="32px" src="https://raw.githubusercontent.com/adi1090x/files/master/other/3.png" alt="Support me on Paypal"></a>
<a href="https://www.patreon.com/adi1090x"><img width="32px" src="https://raw.githubusercontent.com/adi1090x/files/master/other/4.png" alt="Support me on Patreon"></a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Maintained%3F-Yes-green?style=flat-square">
  <img src="https://img.shields.io/github/license/archcraft-os/archcraft?style=flat-square">
  <img src="https://img.shields.io/github/stars/archcraft-os/archcraft?style=flat-square">
  <img src="https://img.shields.io/github/forks/archcraft-os/archcraft?color=teal&style=flat-square">
  <img src="https://img.shields.io/github/issues/archcraft-os/archcraft?color=violet&style=flat-square">
</p>

<p align="center">
Yet another minimal linux distribution, based on <a href="https://www.archlinux.org">Arch Linux</a>.
</p>

<p align="center">
<a href="https://archcraft-os.github.io">Homepage</a> | 
<a href="https://archcraft-os.github.io/install.html">Installation</a> | 
<a href="https://archcraft-os.github.io/features.html">Features</a> | 
<a href="https://archcraft-os.github.io/gallery.html">Screenshots</a> | 
<a href="https://archcraft-os.github.io/blog.html">Wiki</a>
</p>

![gif](https://raw.githubusercontent.com/archcraft-os/archcraft-os.github.io/master/img/main.gif) <br />

---

### Latest Blog Posts

- [Things To Do After Installing Archcraft OS](https://archcraft-os.github.io/blog/post_install.html)
- [Build Archcraft ISO With Its Source](https://archcraft-os.github.io/blog/build.html)
- [Install Archcraft On UEFI System (With Encryption)](https://archcraft-os.github.io/blog/uefi.html)
- [Install Archcraft On BIOS System (With Encryption)](https://archcraft-os.github.io/blog/bios.html)
- [Create A Bootable USB With Archcraft](https://archcraft-os.github.io/blog/usb.html)
- [Boot Archcraft ISO With GRUB2 Bootloader](https://archcraft-os.github.io/blog/grub.html)

### Highlights

- `ABIF` : Arch Base Installation Framework - A Generic Offline Installer
- `GRUB2` : GRand Unified Bootloader - A multi-boot loader
- `Plymouth` : The flicker-free graphical boot screen
- `Xorg` : The most popular display server
- `LXDM` : A lightweight display manager (login screen)
- `Openbox` : A lightweight, powerful, and highly configurable stacking window manager
- `Bspwm` : A tiling window manager, supports multiple monitors
- `Compton` : A standalone compositor for Xorg, suitable for WMs
- `Polybar` : A fast and easy-to-use tool for creating status bars
- `Rofi` : Application launcher, menus & applets
- `Dunst` : A lightweight notification daemon
- `Network Manager` : Manage network connection
- `Thunar & PCmanFM` : File managers for each window manager
- `Geany & Leafpad` : A lightweight IDE & text editor
- `Yay` : AUR (Arch User Repository) helper
- `Styles scripts` : Various scripts to change style for each WM
- `Font Changer` : An individual & a global font changer
- `Wallpaper Generator` : Generates various kinds of wallpapers and applies them
- `Shell` : Zsh with OMZ framework
- `CLI Programs` : Vim, ranger, htop, bashtop, bmon, ncmpcpp & more

### Get The ISO

**1. Download -** You can either download already generated ISO file, or...
<p align="center">
  <a href="https://sourceforge.net/projects/archcraft/files/latest/download" target="_blank"><img alt="undefined" src="https://img.shields.io/badge/Sourceforge-Download-orange?style=for-the-badge&logo=sourceforge"></a>
</p>
  
**2. Build ISO -** If you're already using archlinux & want to build the iso, maybe with your config then...

***Check list***
- [ ] **archiso** version : `51-1`
- [ ] At least 10GB of free space
- [ ] Arch Linux 64-bit only
- [ ] Clear pacman cache; ```sudo pacman -Scc```
- [ ] Configure everything as *root*
- [ ] Disable auto updates

+ Open terminal and clone the **archcraft** repository.
```bash
git clone --depth=1 https://github.com/archcraft-os/archcraft.git
```

+ Change to the **archcraft** directory & run `setup.sh`.
```bash
cd archcraft
chmod +x setup.sh
./setup.sh
```

+ Now, Change to the **iso** directory & run `build.sh` as **root**.
```bash
cd iso
sudo su
./build.sh -v
```

+ If everything goes well, you'll have the ISO in **iso/out** directory. <br />

> If you want to Rebuild the ISO, remove ***work*** & ***out*** dirs inside `iso` directory first. then run `./build.sh -v` as **root**. You don't need to run `setup.sh` again, it's a one time process only. 

### Boot The ISO

**1. Using GRUB -** If you're already using a linux distro with grub, then you can add following entry in your `grub.cfg` file, Replace **X** with your partition number, and */path/to/archcraft.iso* with ISO path. <br />
```
menuentry "Archcraft OS Amd_x86_x64" --class archcraft {
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

**3. Using Etcher -** If you use *Windows*, or maybe linux but afraid of ***dd***, then you can use [Etcher](https://www.balena.io/etcher/) to make a bootable USB/SDcard.

### FYI

+ Default `username` and `password` is **liveuser**.
+ After installing Archcraft, run `sudo pacman -Syy` to sync pacman database.
+ **Important -** I've tested Archcraft on two laptops, with Intel Pentium & Core i3 CPUs. Obviously ISO have intel-video drivers, if you have `nvidia` or something, edit **packages.x86_64** and uncomment the driver package according to your GPU, or WM/DE might freeze on startup (Blank/Gray screen after login).
+ If polybar is not showing some icons properly, run `~/.config/polybar/fix_modules.sh` to fix **Battery** & **Network** Modules.
+ If grub is not showing other installed OSs, please run `sudo grub-mkconfig -o /boot/grub/grub.cfg` to regenerate grub config file on first boot into Archcraft OS.
+ Update the lockscreen according to your screen resolution with `betterlockscreen -u /usr/share/backgrounds/wal_10.jpg` if it's messed up.

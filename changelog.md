<h2 align="center">Archcraft : Changelogs</h2>

### February 2022
**`Not a major Release, Just updated the ISO`**
- Updated Alacritty Configs
- Updated Dunst Configs
- Updated Few Scripts
- Updated the configs for all Window Managers
- Screenshots in clipboard

#

### October 2021
**`Bug Fix Release for v21.09`**
- Fixed `drivers getting removed via installer` bug (backlight, external monitor issues)
- Removed support for `flatpak` as it caused issue with thunar and plank (and other gtk applications)
- Removed support for `snaps` (Arch community really hated it)
- Replaced `lightdm` with **`sddm`**, as webkit2-greeter was causing issues on older machines
- Improved `openbox`, `bspwm`, `polybar` and other stuff
- And... I learned that I don't ~~need to~~ have to add everything people suggest

#

### September 2021
- Created from scratch (for better updates and easy maintenance)
- New **`base`**, **`logo`**, **`packages`**, **`repository`**, etc
- Fixed blackscreen issue on some Nvidia GPUs
- Fixed **`additional kernel`** issue with grub
- Enabled **`snap`** and **`flatpak`** support
- Added **`graphical frontend`** for pacman (with `aur`, `snaps`, `flatpak` integration)
- Enabled **`chaotic aur`** by default
- Enabled **`bluetooth`** services by default
- Enabled **`os-prober`** by default
- Enabled **`on-demand rehash`** for `zsh`
- Using **`lightdm`** with **`webkit2-greeter`** as default display manager
- Using **`firefox`** as the default web browser
- New **`plymouth`** theme, **`grub`** themes
- New **`gtk`**, **`icon`**, **`cursor`** themes and different **`wallpaper`** packs
- New **`welcome`**, **`about`**, **`help and tips`** apps
- New awesome **`fonts`** and updated **`nerd fonts`**
- New **`styles`** and **`themes`** for `openbox (15+)` and `bspwm (20)`
- **`Configurations`** :
  - Redesigned `bspwm` desktop (polybar, rofi, etc)
  - Completely new `openbox` config
  - Improved openbox menu, new pipemenus, different menu styles
  - `Xrandr` pipemenu to adjust resolution and manage multi-monitors easily 
  - `Picom` compositor (`ibhagwan fork`) with dual_kawase blur and rounded corners.
  - Better screenshots with `maim` and screen recording with `ffmpeg`
  - Auto-detection of `network-interface`, `battery`, and `gpu cards` for polybar.
  - Included all my `polybar` and `rofi` themes
  - Typewriter style for `pyroom` for a pleasant writing experience
- **`Command line programs`** :
  - `vim` with [ultimate vimrc](https://github.com/amix/vimrc) (nerd-tree, lightline, etc)
  - `neovim` with [Nvchad](https://github.com/NvChad/NvChad) (the ultimate nvim config)
  - `ranger` with [icons](https://github.com/alexanderjeurissen/ranger_devicons), syntax highlighting and previews (images, videos, pdf, etc)
  - `oh-my-zsh` with [spaceship-prompt](https://github.com/spaceship-prompt/spaceship-prompt)
  - `ncmpcpp` with album art support

#

### June 2021
- Enabled auto login for live session/user
- Enabled password free sudo permissions in live session 
- Added an extra (xfce) terminal, in case alacritty doesn't work for you
- Updated Installers to work in new `Copy to RAM` boot mode
- Updated pacman configuration and fixed pacman related issues
- Added a polkit agent (fix timeshift, snap pkgs related issues)
- Added extra functionalities in thunar (set wallpaper, lockscreen, etc)
- Fixed few bugs and typos
- Updated New Archcraft links

#

### May 2021
- Added Calamares Installer for Easy installation.
- Updated ABIF Installer for Expert Users.
- Updated the whole base for better stability.
- Use btrfs filesystem by default.
- Better timeshift snapshots with btrfs.
- Replaced termite with alacritty terminal.
- Added bluetooth and printer support.
- Added graphics drivers for vmware and more nvidia cards.
- Added tools to style QT applications.
- Updated previous and added new themes in openbox.
- Improved themes in bspwm session.
- Use different lockscreens for each session.
- Added new plymouth theme.
- Added new gtk themes, icon packs and cursor themes.
- Updated the source code to the latest archiso.

#

### April 2021
- Fixed blackscreen issue after login.
- Fixed few bugs and improved few stuff.
- Etc...

#

### January 2021
- Fixed locking on closing laptop lid.
- Fixed hang/freeze on login issue.
- Fixed desktop layout for HD displays.
- Fixed brightness issue for non-intel machines.
- Fixed compositor issues.
- Added New Launchers and powermenus.

#

### October 2020
- Fixed powermenu issue, duplicate mpd notification
- Enabled touchpad tapping
- Added VPN package
- Clickable network module on the bar
- Added a distraction free text editor
- More Nvidia GPU support (GeForce 630-900, 10-20, Quadro/Tesla/Tegra K-series, NVE0, NV110, etc)

#

### September 2020
- Added a startup guide to help you begin with Archcraft OS.
- New default look with better fonts.
- Added AMD and Nvidia support.
- More friendly and familiar key-bindings.
- Installed midori plugins to play HTML5 (youtube) videos.
- App launcher and powermenu style/theme changer.
- Fixed small fonts issue in each style.
- Better openbox menu.
- Added an audio equalizer.
- Added a small script to detect common issues.

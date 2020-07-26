
## Arch Base Installation Framework 2.x series
A generic *offline* installer for Arch-based ISOs. Feel free to use it for your distribution.


# Features
+ Seamless BIOS and UEFI Support
+ Configured to use translation files
+ Easy customisation / basic configuration
+ Supports LUKS (LUKS, LUKS on LVM, and LVM on LUKS), LVM, and btrfs (including special mounting)
+ Create multiple users
+ Built-in error detection


## Basic Assumptions
+ dialog *must* be installed
+ Boot menus assume Grub, Syslinux, and systemd-boot are installed
+ Default partitioning tools are gparted, cfdisk, and parted
+ wipe must be installed for the "secure wipe" option
+ geany is used to edit files
+ You will need to add your own post-configuration code for DMs, and specific files

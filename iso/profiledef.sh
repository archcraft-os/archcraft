#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="archcraft"
iso_label="archcraft_$(date +%Y%m)"
iso_publisher="Aditya Shakya <http://www.github.com/adi1090x>"
iso_application="Yet another minimal linux distribution, based on Arch Linux."
iso_version="$(date +%Y.%m.%d)"
install_dir="arch"
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-x64.systemd-boot.esp' 'uefi-x64.systemd-boot.eltorito')
arch="x86_64"
pacman_conf="pacman.conf"

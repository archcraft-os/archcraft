#!/usr/bin/env bash
#
# SPDX-License-Identifier: GPL-3.0-or-later

set -e -u

iso_name=archcraft
iso_label="archcraft_$(date +%Y%m)"
iso_publisher="Aditya Shakya <http://www.github.com/adi1090x>"
iso_application="Yet another minimal linux distribution, based on Arch Linux."
iso_version=$(date +%Y.%m.%d)
install_dir=arch
work_dir=work
out_dir=out
gpg_key=""

verbose=""
script_path="$( cd -P "$( dirname "$(readlink -f "$0")" )" && pwd )"

umask 0022

_usage ()
{
    echo "usage ${0} [options]"
    echo
    echo " General options:"
    echo "    -N <iso_name>      Set an iso filename (prefix)"
    echo "                        Default: ${iso_name}"
    echo "    -V <iso_version>   Set an iso version (in filename)"
    echo "                        Default: ${iso_version}"
    echo "    -L <iso_label>     Set an iso label (disk label)"
    echo "                        Default: ${iso_label}"
    echo "    -P <publisher>     Set a publisher for the disk"
    echo "                        Default: '${iso_publisher}'"
    echo "    -A <application>   Set an application name for the disk"
    echo "                        Default: '${iso_application}'"
    echo "    -D <install_dir>   Set an install_dir (directory inside iso)"
    echo "                        Default: ${install_dir}"
    echo "    -w <work_dir>      Set the working directory"
    echo "                        Default: ${work_dir}"
    echo "    -o <out_dir>       Set the output directory"
    echo "                        Default: ${out_dir}"
    echo "    -v                 Enable verbose output"
    echo "    -h                 This help message"
    exit "${1}"
}

# Helper function to run make_*() only one time per architecture.
run_once() {
    if [[ ! -e "${work_dir}/build.${1}" ]]; then
        "$1"
        touch "${work_dir}/build.${1}"
    fi
}

# Setup custom pacman.conf with current cache directories.
make_pacman_conf() {
    local _cache_dirs
    _cache_dirs=("$(pacman -v 2>&1 | grep '^Cache Dirs:' | sed 's/Cache Dirs:\s*//g')")
    sed -r "s|^#?\\s*CacheDir.+|CacheDir = $(echo -n "${_cache_dirs[@]}")|g" \
        "${script_path}/pacman.conf" > "${work_dir}/pacman.conf"
}

# Prepare working directory and copy custom airootfs files (airootfs)
make_custom_airootfs() {
    local _airootfs="${work_dir}/x86_64/airootfs"
    mkdir -p -- "${_airootfs}"

    if [[ -d "${script_path}/airootfs" ]]; then
        cp -af --no-preserve=ownership -- "${script_path}/airootfs/." "${_airootfs}"

        [[ -e "${_airootfs}/etc/shadow" ]] && chmod -f 0400 -- "${_airootfs}/etc/shadow"
        [[ -e "${_airootfs}/etc/gshadow" ]] && chmod -f 0400 -- "${_airootfs}/etc/gshadow"

        # Set up user home directories and permissions
        if [[ -e "${_airootfs}/etc/passwd" ]]; then
            while IFS=':' read -a passwd -r; do
                [[ "${passwd[5]}" == '/' ]] && continue

                if [[ -d "${_airootfs}${passwd[5]}" ]]; then
                    chown -hR -- "${passwd[2]}:${passwd[3]}" "${_airootfs}${passwd[5]}"
                    chmod -f 0750 -- "${_airootfs}${passwd[5]}"
                else
                    install -d -m 0750 -o "${passwd[2]}" -g "${passwd[3]}" -- "${_airootfs}${passwd[5]}"
                fi
             done < "${_airootfs}/etc/passwd"
        fi
    fi
}

# Packages (airootfs)
make_packages() {
    if [[ "${gpg_key}" ]]; then
      gpg --export "${gpg_key}" > "${work_dir}/gpgkey"
      exec 17<>"${work_dir}/gpgkey"
    fi
    if [ -n "${verbose}" ]; then
        ARCHISO_GNUPG_FD="${gpg_key:+17}" mkarchiso -v -w "${work_dir}/x86_64" -C "${work_dir}/pacman.conf" -D "${install_dir}" \
            -p "$(grep -h -v '^#' "${script_path}/packages.x86_64"| sed ':a;N;$!ba;s/\n/ /g')" install
    else
        ARCHISO_GNUPG_FD="${gpg_key:+17}" mkarchiso -w "${work_dir}/x86_64" -C "${work_dir}/pacman.conf" -D "${install_dir}" \
            -p "$(grep -h -v '^#' "${script_path}/packages.x86_64"| sed ':a;N;$!ba;s/\n/ /g')" install
    fi
    if [[ "${gpg_key}" ]]; then
      exec 17<&-
    fi
}

# Customize installation (airootfs)
make_customize_airootfs() {
    if [[ -e "${script_path}/airootfs/etc/passwd" ]]; then
        while IFS=':' read -a passwd -r; do
            [[ "${passwd[5]}" == '/' ]] && continue
            cp -RdT --preserve=mode,timestamps,links -- "${work_dir}/x86_64/airootfs/etc/skel" "${work_dir}/x86_64/airootfs${passwd[5]}"
            chown -hR -- "${passwd[2]}:${passwd[3]}" "${work_dir}/x86_64/airootfs${passwd[5]}"

        done < "${script_path}/airootfs/etc/passwd"
    fi

    if [[ -e "${work_dir}/x86_64/airootfs/root/customize_airootfs.sh" ]]; then
        if [ -n "${verbose}" ]; then
            mkarchiso -v -w "${work_dir}/x86_64" -C "${work_dir}/pacman.conf" -D "${install_dir}" \
                -r '/root/customize_airootfs.sh' run
        else
            mkarchiso -w "${work_dir}/x86_64" -C "${work_dir}/pacman.conf" -D "${install_dir}" \
                -r '/root/customize_airootfs.sh' run
        fi
        rm "${work_dir}/x86_64/airootfs/root/customize_airootfs.sh"
    fi
}

# Prepare kernel/initramfs ${install_dir}/boot/
make_boot() {
    mkdir -p "${work_dir}/iso/${install_dir}/boot/x86_64"
    cp "${work_dir}/x86_64/airootfs/boot/archiso.img" "${work_dir}/iso/${install_dir}/boot/x86_64/"
    cp "${work_dir}/x86_64/airootfs/boot/vmlinuz-linux" "${work_dir}/iso/${install_dir}/boot/x86_64/"
}

# Add other aditional/extra files to ${install_dir}/boot/
make_boot_extra() {
    if [[ -e "${work_dir}/x86_64/airootfs/boot/memtest86+/memtest.bin" ]]; then
        # rename for PXE: https://wiki.archlinux.org/index.php/Syslinux#Using_memtest
        cp "${work_dir}/x86_64/airootfs/boot/memtest86+/memtest.bin" "${work_dir}/iso/${install_dir}/boot/memtest"
        mkdir -p "${work_dir}/iso/${install_dir}/boot/licenses/memtest86+/"
        cp "${work_dir}/x86_64/airootfs/usr/share/licenses/common/GPL2/license.txt" \
            "${work_dir}/iso/${install_dir}/boot/licenses/memtest86+/"
    fi
    if [[ -e "${work_dir}/x86_64/airootfs/boot/intel-ucode.img" ]]; then
        cp "${work_dir}/x86_64/airootfs/boot/intel-ucode.img" "${work_dir}/iso/${install_dir}/boot/"
        mkdir -p "${work_dir}/iso/${install_dir}/boot/licenses/intel-ucode/"
        cp "${work_dir}/x86_64/airootfs/usr/share/licenses/intel-ucode/"* \
            "${work_dir}/iso/${install_dir}/boot/licenses/intel-ucode/"
    fi
    if [[ -e "${work_dir}/x86_64/airootfs/boot/amd-ucode.img" ]]; then
        cp "${work_dir}/x86_64/airootfs/boot/amd-ucode.img" "${work_dir}/iso/${install_dir}/boot/"
        mkdir -p "${work_dir}/iso/${install_dir}/boot/licenses/amd-ucode/"
        cp "${work_dir}/x86_64/airootfs/usr/share/licenses/amd-ucode/"* \
            "${work_dir}/iso/${install_dir}/boot/licenses/amd-ucode/"
    fi
}

# Prepare /${install_dir}/boot/syslinux
make_syslinux() {
    _uname_r=$(file -b "${work_dir}/x86_64/airootfs/boot/vmlinuz-linux"| awk 'f{print;f=0} /version/{f=1}' RS=' ')
    mkdir -p "${work_dir}/iso/${install_dir}/boot/syslinux"
    for _cfg in "${script_path}/syslinux/"*.cfg; do
        sed "s|%ARCHISO_LABEL%|${iso_label}|g;
             s|%INSTALL_DIR%|${install_dir}|g" "${_cfg}" > "${work_dir}/iso/${install_dir}/boot/syslinux/${_cfg##*/}"
    done
    cp "${script_path}/syslinux/splash.png" "${work_dir}/iso/${install_dir}/boot/syslinux/"
    cp "${work_dir}/x86_64/airootfs/usr/lib/syslinux/bios/"*.c32 "${work_dir}/iso/${install_dir}/boot/syslinux/"
    cp "${work_dir}/x86_64/airootfs/usr/lib/syslinux/bios/lpxelinux.0" "${work_dir}/iso/${install_dir}/boot/syslinux/"
    cp "${work_dir}/x86_64/airootfs/usr/lib/syslinux/bios/memdisk" "${work_dir}/iso/${install_dir}/boot/syslinux/"
    mkdir -p "${work_dir}/iso/${install_dir}/boot/syslinux/hdt"
    gzip -c -9 "${work_dir}/x86_64/airootfs/usr/share/hwdata/pci.ids" > \
        "${work_dir}/iso/${install_dir}/boot/syslinux/hdt/pciids.gz"
    gzip -c -9 "${work_dir}/x86_64/airootfs/usr/lib/modules/${_uname_r}/modules.alias" > \
        "${work_dir}/iso/${install_dir}/boot/syslinux/hdt/modalias.gz"
}

# Prepare /isolinux
make_isolinux() {
    mkdir -p "${work_dir}/iso/isolinux"
    sed "s|%INSTALL_DIR%|${install_dir}|g" \
        "${script_path}/isolinux/isolinux.cfg" > "${work_dir}/iso/isolinux/isolinux.cfg"
    cp "${work_dir}/x86_64/airootfs/usr/lib/syslinux/bios/isolinux.bin" "${work_dir}/iso/isolinux/"
    cp "${work_dir}/x86_64/airootfs/usr/lib/syslinux/bios/isohdpfx.bin" "${work_dir}/iso/isolinux/"
    cp "${work_dir}/x86_64/airootfs/usr/lib/syslinux/bios/ldlinux.c32" "${work_dir}/iso/isolinux/"
}

# Prepare /EFI
make_efi() {
    mkdir -p "${work_dir}/iso/EFI/boot"
    cp "${work_dir}/x86_64/airootfs/usr/lib/systemd/boot/efi/systemd-bootx64.efi" \
        "${work_dir}/iso/EFI/boot/bootx64.efi"

    mkdir -p "${work_dir}/iso/loader/entries"
    cp "${script_path}/efiboot/loader/loader.conf" "${work_dir}/iso/loader/"

    sed "s|%ARCHISO_LABEL%|${iso_label}|g;
         s|%INSTALL_DIR%|${install_dir}|g" \
        "${script_path}/efiboot/loader/entries/archcraftiso-x86_64-usb.conf" > \
        "${work_dir}/iso/loader/entries/archcraftiso-x86_64.conf"

    # edk2-shell based UEFI shell
    # shellx64.efi is picked up automatically when on /
    cp "${work_dir}/x86_64/airootfs/usr/share/edk2-shell/x64/Shell_Full.efi" "${work_dir}/iso/shellx64.efi"
}

# Prepare efiboot.img::/EFI for "El Torito" EFI boot mode
make_efiboot() {
    mkdir -p "${work_dir}/iso/EFI/archiso"
    truncate -s 64M "${work_dir}/iso/EFI/archiso/efiboot.img"
    mkfs.fat -n ARCHISO_EFI "${work_dir}/iso/EFI/archiso/efiboot.img"

    mkdir -p "${work_dir}/efiboot"
    mount "${work_dir}/iso/EFI/archiso/efiboot.img" "${work_dir}/efiboot"

    mkdir -p "${work_dir}/efiboot/EFI/archiso"
    cp "${work_dir}/iso/${install_dir}/boot/x86_64/vmlinuz-linux" "${work_dir}/efiboot/EFI/archiso/"
    cp "${work_dir}/iso/${install_dir}/boot/x86_64/archiso.img" "${work_dir}/efiboot/EFI/archiso/"

    cp "${work_dir}/iso/${install_dir}/boot/intel-ucode.img" "${work_dir}/efiboot/EFI/archiso/"
    cp "${work_dir}/iso/${install_dir}/boot/amd-ucode.img" "${work_dir}/efiboot/EFI/archiso/"

    mkdir -p "${work_dir}/efiboot/EFI/boot"
    cp "${work_dir}/x86_64/airootfs/usr/lib/systemd/boot/efi/systemd-bootx64.efi" \
        "${work_dir}/efiboot/EFI/boot/bootx64.efi"

    mkdir -p "${work_dir}/efiboot/loader/entries"
    cp "${script_path}/efiboot/loader/loader.conf" "${work_dir}/efiboot/loader/"

    sed "s|%ARCHISO_LABEL%|${iso_label}|g;
         s|%INSTALL_DIR%|${install_dir}|g" \
        "${script_path}/efiboot/loader/entries/archcraftiso-x86_64-cd.conf" > \
        "${work_dir}/efiboot/loader/entries/archcraftiso-x86_64.conf"

    # shellx64.efi is picked up automatically when on /
    cp "${work_dir}/iso/shellx64.efi" "${work_dir}/efiboot/"

    umount -d "${work_dir}/efiboot"
}

# Build airootfs filesystem image
make_prepare() {
    cp -a -l -f "${work_dir}/x86_64/airootfs" "${work_dir}"
    if [ -n "${verbose}" ]; then
        mkarchiso -v -w "${work_dir}" -D "${install_dir}" pkglist
        mkarchiso -v -w "${work_dir}" -D "${install_dir}" ${gpg_key:+-g ${gpg_key}} prepare
    else
        mkarchiso -w "${work_dir}" -D "${install_dir}" pkglist
        mkarchiso -w "${work_dir}" -D "${install_dir}" ${gpg_key:+-g ${gpg_key}} prepare
    fi
    rm -rf "${work_dir}/airootfs"
    # rm -rf "${work_dir}/x86_64/airootfs" (if low space, this helps)
}

# Build ISO
make_iso() {
    if [ -n "${verbose}" ]; then
        mkarchiso -v -w "${work_dir}" -D "${install_dir}" -L "${iso_label}" -P "${iso_publisher}" \
            -A "${iso_application}" -o "${out_dir}" iso "${iso_name}-${iso_version}-x86_64.iso"
    else
        mkarchiso -w "${work_dir}" -D "${install_dir}" -L "${iso_label}" -P "${iso_publisher}" \
            -A "${iso_application}" -o "${out_dir}" iso "${iso_name}-${iso_version}-x86_64.iso"
    fi
}

if [[ ${EUID} -ne 0 ]]; then
    echo "This script must be run as root."
    _usage 1
fi

while getopts 'N:V:L:P:A:D:w:o:g:vh' arg; do
    case "${arg}" in
        N) iso_name="${OPTARG}" ;;
        V) iso_version="${OPTARG}" ;;
        L) iso_label="${OPTARG}" ;;
        P) iso_publisher="${OPTARG}" ;;
        A) iso_application="${OPTARG}" ;;
        D) install_dir="${OPTARG}" ;;
        w) work_dir="${OPTARG}" ;;
        o) out_dir="${OPTARG}" ;;
        g) gpg_key="${OPTARG}" ;;
        v) verbose="-v" ;;
        h) _usage 0 ;;
        *)
           echo "Invalid argument '${arg}'"
           _usage 1
           ;;
    esac
done

mkdir -p "${work_dir}"

run_once make_pacman_conf
run_once make_custom_airootfs
run_once make_packages
run_once make_customize_airootfs
run_once make_boot
run_once make_boot_extra
run_once make_syslinux
run_once make_isolinux
run_once make_efi
run_once make_efiboot
run_once make_prepare
run_once make_iso

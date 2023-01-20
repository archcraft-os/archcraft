#!/usr/bin/env bash

## Copyright (C) 2020-2023 Aditya Shakya <adi1090x@gmail.com>

## Generate sha256sum and gpg signature files
PWD=`pwd`
DIR="$PWD/out"

if [[ ! -d "$DIR" ]]; then
	exit 1
fi

RELEASE=`find $DIR -type f -name "archcraft-*.iso" -printf "%f\n"`

if [[ -n "$RELEASE" ]]; then
	echo -e "\n[*] Generating sha256sum for ${RELEASE} ..."
	cd "$DIR" && sha256sum ${RELEASE} > ${RELEASE}.sha256sum
	if [[ -e "${RELEASE}.sha256sum" ]]; then
		echo -e "[*] Checksum generated successfully."
	else
		echo -e "[!] Failed to generate checksum file."
	fi	
	
	echo -e "\n[*] Generating gpg signature for ${RELEASE} ..."
	gpg --default-key adi1090x@gmail.com --output ${RELEASE}.sig --detach-sig ${RELEASE}
	if [[ -e "${RELEASE}.sig" ]]; then
		echo -e "[*] Signature generated successfully.\n"
	else
		echo -e "[!] Failed to generate signature file.\n"
	fi
else
	echo -e "\n[!] There's no ISO file in 'files' directory.\n[!] Copy the ISO file in 'files' directory & Run this script again.\n"
	exit 1
fi

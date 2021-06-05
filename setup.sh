#!/usr/bin/env bash
#
# SPDX-License-Identifier: GPL-3.0-or-later

## Pre-build script for archcraft OS.

## ANSI Colors (FG & BG)
RED="$(printf '\033[31m')"  GREEN="$(printf '\033[32m')"  ORANGE="$(printf '\033[33m')"  BLUE="$(printf '\033[34m')"
MAGENTA="$(printf '\033[35m')"  CYAN="$(printf '\033[36m')"  WHITE="$(printf '\033[37m')" BLACK="$(printf '\033[30m')"
REDBG="$(printf '\033[41m')"  GREENBG="$(printf '\033[42m')"  ORANGEBG="$(printf '\033[43m')"  BLUEBG="$(printf '\033[44m')"
MAGENTABG="$(printf '\033[45m')"  CYANBG="$(printf '\033[46m')"  WHITEBG="$(printf '\033[47m')" BLACKBG="$(printf '\033[40m')"

## Directories
DIR="$(pwd)"

## Banner
banner () {
    clear
    cat <<- _EOF_
		${RED}┌──────────────────────────────────────────────────┐
		│░░░█▀█░█▀▄░█▀▀░█░█░█▀▀░█▀▄░█▀█░█▀▀░▀█▀░░░█▀█░█▀▀░░│
		│░░░█▀█░█▀▄░█░░░█▀█░█░░░█▀▄░█▀█░█▀▀░░█░░░░█░█░▀▀█░░│
		│░░░▀░▀░▀░▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀░▀░▀░░░░▀░░░░▀▀▀░▀▀▀░░│
		└──────────────────────────────────────────────────┘
		${ORANGE}[*] ${CYAN}By: Aditya Shakya
		${ORANGE}[*] ${CYAN}Github: @adi1090x
		${ORANGE}[*] ${CYAN}Twitter: @adi1090x
	_EOF_
}

## Reset terminal colors
reset_color() {
	tput sgr0   # reset attributes
	tput op     # reset color
    return
}

## Script Termination
exit_on_signal_SIGINT () {
    { printf ${RED}"\n\n%s\n" "[*] Script interrupted." 2>&1; echo; reset_color; }
    exit 0
}

exit_on_signal_SIGTERM () {
    { printf ${RED}"\n\n%s\n" "[*] Script terminated." 2>&1; echo; reset_color; }
    exit 0
}

trap exit_on_signal_SIGINT SIGINT
trap exit_on_signal_SIGTERM SIGTERM

## Prerequisite
prerequisite() {
	echo -e ${ORANGE}"\n[*] ${BLUE}Installing Dependencies... ${CYAN}\n"
	if [[ -f /usr/bin/mkarchiso ]]; then
		echo ${ORANGE}"[*] ${GREEN}Dependencies are already Installed!"
	else
		sudo pacman -Sy archiso --noconfirm
		(type -p mkarchiso &> /dev/null) && echo -e "${ORANGE}\n[*] ${GREEN}Dependencies are succesfully installed!" \
		|| { echo -e "${BLUE}\n[!] ${RED}Error Occured, failed to install dependencies.\n"; reset_color; exit 1; }
	fi
	echo -e ${ORANGE}"\n[*] ${BLUE}Creating 'mkarchcraftiso' ... ${CYAN}"	

	# copy mkarchiso
	cp -f /usr/bin/mkarchiso "$DIR"/iso/mkarchcraftiso && chmod +x "$DIR"/iso/mkarchcraftiso
	sed -i -e 's/-c -G -M/-i -c -G -M/g' "$DIR"/iso/mkarchcraftiso

	# do not delete package database
	sed -i -e 's|\[\[ -d \"${pacstrap_dir}/var/lib/pacman/sync\"|#\[\[ -d \"${pacstrap_dir}/var/lib/pacman/sync\"|g' "$DIR"/iso/mkarchcraftiso

	# preserve mode
	sed -i -e 's/--no-preserve=ownership,mode/--no-preserve=ownership/g' "$DIR"/iso/mkarchcraftiso
	
	if [[ -f "$DIR"/iso/mkarchcraftiso ]]; then
		echo -e ${ORANGE}"\n[*] ${GREEN}'mkarchcraftiso' created succesfully.\n"
	else
		echo -e ${ORANGE}"\n[*] ${RED}Failed to create 'mkarchcraftiso'.\n"
	fi
}

## Setup extra stuff
set_omz () {
	# Setup OMZ
	echo -e ${ORANGE}"[*] ${BLUE}Setting Up Oh-My-Zsh - ${CYAN}\n"
	cd $DIR/iso/airootfs/etc/skel && git clone https://github.com/robbyrussell/oh-my-zsh.git --depth 1 .oh-my-zsh
	cp $DIR/iso/airootfs/etc/skel/.oh-my-zsh/templates/zshrc.zsh-template $DIR/iso/airootfs/etc/skel/.zshrc
	sed -i -e 's/ZSH_THEME=.*/ZSH_THEME="archcraft"/g' $DIR/iso/airootfs/etc/skel/.zshrc
	# Archcraft ZSH theme
	cat > $DIR/iso/airootfs/etc/skel/.oh-my-zsh/custom/themes/archcraft.zsh-theme <<- _EOF_
		# Default OMZ theme for Archcraft

		if [[ "\$USER" == "root" ]]; then
		  PROMPT="%(?:%{\$fg_bold[red]%}%{\$fg_bold[yellow]%}%{\$fg_bold[red]%} :%{\$fg_bold[red]%} )"
		  PROMPT+='%{\$fg[cyan]%}  %c%{\$reset_color%} \$(git_prompt_info)'
		else
		  PROMPT="%(?:%{\$fg_bold[red]%}%{\$fg_bold[green]%}%{\$fg_bold[yellow]%} :%{\$fg_bold[red]%} )"
		  PROMPT+='%{\$fg[cyan]%}  %c%{\$reset_color%} \$(git_prompt_info)'
		fi

		ZSH_THEME_GIT_PROMPT_PREFIX="%{\$fg_bold[blue]%}  git:(%{\$fg[red]%}"
		ZSH_THEME_GIT_PROMPT_SUFFIX="%{\$reset_color%} "
		ZSH_THEME_GIT_PROMPT_DIRTY="%{\$fg[blue]%}) %{\$fg[yellow]%}✗"
		ZSH_THEME_GIT_PROMPT_CLEAN="%{\$fg[blue]%})"
	_EOF_
	# Append some aliases
	cat >> $DIR/iso/airootfs/etc/skel/.zshrc <<- _EOF_
		# omz
		alias zshconfig="geany ~/.zshrc"
		alias ohmyzsh="thunar ~/.oh-my-zsh"

		# ls
		alias l='ls -lh'
		alias ll='ls -lah'
		alias la='ls -A'
		alias lm='ls -m'
		alias lr='ls -R'
		alias lg='ls -l --group-directories-first'

		# git
		alias gcl='git clone --depth 1'
		alias gi='git init'
		alias ga='git add'
		alias gc='git commit -m'
		alias gp='git push origin master'
	_EOF_
	echo -e ${ORANGE}"\n[*] ${GREEN}Done. OMZ added successfully.\n"
}

## Changing ownership to root to avoid false permissions error
final_msg () {
	echo -e ${ORANGE}"[*] ${GREEN}Setup Completed, Change to 'iso' directory and Run './mkarchcraftiso -v' as root to build the ISO.\n"
}

## Main
banner
prerequisite
set_omz
final_msg
exit 0

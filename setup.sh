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
	{ echo; echo ${ORANGE}"[*] ${BLUE}Installing Dependencies... ${CYAN}"; echo; }
	if [[ -f /usr/bin/mkarchiso ]]; then
		{ echo ${ORANGE}"[*] ${GREEN}Dependencies are already Installed!"; }
	else
		sudo pacman -Sy archiso --noconfirm
		(type -p mkarchiso &> /dev/null) && { echo; echo "${ORANGE}[*] ${GREEN}Dependencies are succesfully installed!"; } || { echo; echo "${BLUE}[!] ${RED}Error Occured, failed to install dependencies."; echo; reset_color; exit 1; }
	fi
	{ echo; echo ${ORANGE}"[*] ${BLUE}Modifying /usr/bin/mkarchiso - ${CYAN}"; echo; }
	sudo cp /usr/bin/mkarchiso{,.bak} && sudo sed -i -e 's/-c -G -M/-i -c -G -M/g' /usr/bin/mkarchiso
	sudo sed -i -e 's/archiso-x86_64/archcraftiso-x86_64/g' /usr/bin/mkarchiso
	{ echo; echo -e ${ORANGE}"[*] ${GREEN}Succesfully Modified."; echo; }
}

## Setup extra stuff
set_extra () {
	# Setup OMZ
	{ echo ${ORANGE}"[*] ${BLUE}Setting Up Oh-My-Zsh - ${CYAN}"; echo; }
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
	{ echo; echo ${ORANGE}"[*] ${GREEN}Done. OMZ added successfully."; echo; }

	## Edex-UI (Optional)
	{ read -p ${ORANGE}"[*] ${BLUE}Do you want EDEX-UI? (Y/N): ${CYAN}" answer; echo; }
	if [[ $answer = "Y" ]] || [[ $answer = "y" ]]; then
		{ echo ${ORANGE}"[*] ${BLUE}Alright, Setting up edex-ui... ${CYAN}"; echo; }
		cd $DIR/iso/airootfs && mkdir opt && cd opt
		wget -q https://github.com/GitSquared/edex-ui/releases/download/v2.2.2/eDEX-UI.Linux.x86_64.AppImage
		if [[ -f $DIR/iso/airootfs/opt/eDEX-UI.Linux.x86_64.AppImage ]]; then
			chmod 755 eDEX-UI.Linux.x86_64.AppImage
			cat > $DIR/iso/airootfs/usr/share/applications/eDEX-UI.desktop <<- _EOF_
				[Desktop Entry]
				Name=eDEX-UI
				Comment=eDEX-UI sci-fi interface
				Exec="/opt/eDEX-UI.Linux.x86_64.AppImage"
				Terminal=false
				Type=Application
				Icon=edex-ui
				StartupWMClass=eDEX-UI
				Categories=System;
			_EOF_
			{ echo; echo ${ORANGE}"[*] ${GREEN}eDEX-UI Added. "; echo; }
		else
			{ echo; echo ${ORANGE}"[*] ${RED}Failed to download eDEX-UI. "; echo; }
		fi
	fi
}

## Changing ownership to root to avoid false permissions error
set_mod () {
	echo ${ORANGE}"[*] ${BLUE}Setting up correct permissions..."
	sudo chown -R root:root $DIR/iso/
	{ echo; echo ${ORANGE}"[*] ${GREEN}Setup Completed, follow the next step to build the ISO."; echo; }
}

## Main
banner
prerequisite
set_extra
set_mod
exit 0

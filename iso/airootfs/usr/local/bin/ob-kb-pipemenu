#!/usr/bin/env bash

# al-kb-pipemenu - an Openbox pipemenu for displaying keybinds
# Copyright (C) 2015 damo <damo@bunsenlabs.org>
# Copyright (C) 2018 Nathaniel Maia  <natemaia10@gmail.com>
# Renamed and rewritten for ArchLabs and zenity

readonly KBSCRIPT="ob-kb"
readonly CFG_DIR="$HOME/.config/openbox"
readonly RCPATH="$CFG_DIR/rc.xml"
readonly KBTEXT="$CFG_DIR/kbinds.txt"
readonly HELP='\tal-kb-pipemenu an Openbox Pipe Menu for displaying keybinds
\tIt should normally be called from an openbox menu.
\nOptions (usually passed from the menu):
\t-h --help   show this message
\t--keybinds  display keybindings defined in rc.xml as a menu
\t(The keybinds in the menu are clickable, except for the Openbox
\tcommands, which just exit the menu.)
\t--rcedit    backup and edit rc.xml
\nIf al-keyboard-pipemenu is called with no options (the usual method),
it will output an xml openbox pipemenu for displaying keybindings.
\tNOTE: Some of the functionality of this pipemenu depends on the script
/usr/bin/al-kb which is provided by the package "archlabs-utilities"'

case "$@" in
    -h|--help) echo -e "$HELP" ; exit 0
esac

if ! . "/usr/lib/archlabs/common/al-include.cfg" 2> /dev/null; then
    echo $"Error: Failed to locate /usr/lib/archlabs/common//al-include.cfg" >&2
    exit 1
fi

if ! type "$KBSCRIPT" &>/dev/null; then
    menuStart
    menuSeparator "$KBSCRIPT is not available. Try installing archlabs-pipemenus."
    menuEnd
    exit 1
fi

if [[ $1 = '--rcedit' ]]; then
    NOW=$(date +"%Y%m%d-%H%M")
    RCBKP="$RCPATH.$NOW"
    cp "$RCPATH" "$RCBKP"
    if hash exo-open &>/dev/null; then
        exo-open "$RCPATH"
    else
        termite -e "$EDITOR $RCPATH"
    fi
    exit 0
fi

if [[ $1 = '--keybinds' ]]; then
    "$KBSCRIPT" > /dev/null
    menuStart
    menuSeparator "Openbox window commands"
    while read -r a b c; do
        if [[ "$a" = "o" ]]; then
            curItem=$(printf "%-20s %s" "$b" "$c")
            menuItem "$curItem" "echo >/dev/null 2>&1"
        fi
    done < "$KBTEXT"

    menuSeparator
    menuSeparator "Run commands"
    while read -r a b c; do
        if [[ "$a" = "x" ]]; then
            curItem=$(printf "%-20s %s" "$b" "$c")
            menuItem "$curItem" "$c"
        fi
    done < "$KBTEXT"
    menuEnd
    exit 0
fi

menuStart
    menuItem "Backup and Edit rc.xml" "ob-kb-pipemenu --rcedit"
    menuSeparator
    menuItem "Display Keybinds in window" "ob-kb --gui"
    echo '        <menu execute="ob-kb-pipemenu --keybinds" id="Display keybinds" label="Display Keybinds in menu"/>'
menuEnd

exit 0

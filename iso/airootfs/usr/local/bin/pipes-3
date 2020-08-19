#!/usr/bin/env bash
# pipes.sh: Animated pipes terminal screensaver.
# Copyleft (ↄ) 2015 - Acidhub <acidhub@craft.net.br>
#              2015 - Pipeseroni - http://github.com/pipeseroni
#              2014 - Yu-Jie Lin <livibetter@gmail.com>
#              ???? - Mathew Simpson
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

VERSION=1.2

M=32768
p=3
f=75 s=13 r=2000 t=0
w=$(tput cols) h=$(tput lines)
# ab -> idx = a*4 + b
# 0: up, 1: right, 2: down, 3: left
# 00 means going up   , then going up   -> ┃
# 12 means going right, then going down -> ┓
sets=(
    "┃┏ ┓┛━┓  ┗┃┛┗ ┏━" # -t 0 "default"
    "│╭ ╮╯─╮  ╰│╯╰ ╭─" # -t 1 "round"
    "│┌ ┐┘─┐  └│┘└ ┌─" # -t 2 "weak"
    "║╔ ╗╝═╗  ╚║╝╚ ╔═" # -t 3 "double"
    "|+ ++-+  +|++ +-" # -t 4 "add/sub"
    "|/ \/-\  \|/\ /-" # -t 5 "It' something"
    ".. ....  .... .." # -t 6 "dots"
    ".o oo.o  o.oo o." # -t 7 "dot-O"
    "-\ /\|/  /-\/ \|" # -t 8 "railway"
    "▓≡▓≡≡▓≡  ≡▓≡≡▓≡▓" # -t 9 "blocks"
)
v=()
RNDSTART=0
BOLD=1
NOCOLOR=0

OPTIND=1
while getopts "p:t:f:s:r:RBChv" arg; do
case $arg in
    p) ((p=(OPTARG>0)?OPTARG:p));;
    t)
        if [[ "$OPTARG" = c???????????????? ]]; then
            V+=(${#sets[@]})
            sets+=("${OPTARG:1}")
        else
            ((OPTARG>=0 && OPTARG<${#sets[@]})) && V+=($OPTARG)
        fi
        ;;
    f) ((f=(OPTARG>19 && OPTARG<101)?OPTARG:f));;
    s) ((s=(OPTARG>4 && OPTARG<16 )?OPTARG:s));;
    r) ((r=(OPTARG>=0)?OPTARG:r));;
    R) RNDSTART=1;;
    B) BOLD=0;;
    C) NOCOLOR=1;;
    h) echo -e "Usage: $(basename $0) [OPTION]..."
        echo -e "Animated pipes terminal screensaver.\n"
        echo -e " -p [1-?]\tnumber of pipes (D=3)."
        echo -e " -t [0-$((${#sets[@]} - 1))]\ttype of pipes, can be used more than once (D=0)."
        echo -e " -t c[16 chars]\tcustom type of pipes."
        echo -e " -f [20-100]\tframerate (D=75)."
        echo -e " -s [5-15]\tprobability of a straight fitting (D=13)."
        echo -e " -r LIMIT\treset after x characters, 0 if no limit (D=2000)."
        echo -e " -R \t\trandom starting point."
        echo -e " -B \t\tno bold effect."
        echo -e " -C \t\tno color."
        echo -e " -h\t\thelp (this screen)."
        echo -e " -v\t\tprint version number.\n"
        exit 0;;
    v) echo "$(basename -- "$0") $VERSION"
        exit 0
    esac
done

# set default values if not by options
((${#V[@]})) || V=(0)

cleanup() {
    # clear up standard input
    read -t 0.001 && cat </dev/stdin>/dev/null

    # terminal has no smcup and rmcup capabilities
    ((FORCE_RESET)) && reset && exit 0

    tput rmcup
    tput cnorm
    stty echo
    ((NOCOLOR)) && echo -ne '\e[0m'
    exit 0
}
trap cleanup HUP TERM
trap 'break 2' INT

for (( i=1; i<=p; i++ )); do
    c[i]=$((i%8)) n[i]=0 l[i]=0
    ((x[i]=RNDSTART==1?RANDOM*w/32768:w/2))
    ((y[i]=RNDSTART==1?RANDOM*h/32768:h/2))
    v[i]=${V[${#V[@]} * RANDOM / M]}
done

stty -echo
tput smcup || FORCE_RESET=1
tput civis
tput clear
# any key press exits the loop and this script
while REPLY=; read -t 0.0$((1000/f)) -n 1; [[ -z $REPLY ]] ; do
    for (( i=1; i<=p; i++ )); do
        # New position:
        ((${l[i]}%2)) && ((x[i]+=-${l[i]}+2,1)) || ((y[i]+=${l[i]}-1))

        # Loop on edges (change color on loop):
        ((${x[i]}>w||${x[i]}<0||${y[i]}>h||${y[i]}<0)) && ((c[i]=RANDOM%8, v[i]=V[${#V[@]}*RANDOM/M]))
        ((x[i]=(x[i]+w)%w))
        ((y[i]=(y[i]+h)%h))

        # New random direction:
        ((n[i]=RANDOM%s-1))
        ((n[i]=(${n[i]}>1||${n[i]}==0)?${l[i]}:${l[i]}+${n[i]}))
        ((n[i]=(${n[i]}<0)?3:${n[i]}%4))

        # Print:
        tput cup ${y[i]} ${x[i]}
        echo -ne "\e[${BOLD}m"
        [[ $NOCOLOR == 0 ]] && echo -ne "\e[3${c[i]}m"
        echo -n "${sets[v[i]]:l[i]*4+n[i]:1}"
        l[i]=${n[i]}
    done
    ((r>0 && t*p>=r)) && tput reset && tput civis && t=0 || ((t++))
done

cleanup

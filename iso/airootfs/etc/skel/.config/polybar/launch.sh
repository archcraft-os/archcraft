#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the bar
STYLE="forest"

polybar main -c "$HOME"/.config/polybar/"$STYLE"/config.ini &

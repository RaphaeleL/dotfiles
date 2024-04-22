#!/usr/bin/env bash

# Terminate already running bar instances
polybar-msg cmd quit

# Launch bar
echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log

# for m in $(polybar --list-monitors | cut -d":" -f1); do
#     MONITOR=$m polybar --reload example --config=$HOME/.config/polybar/config.ini &
# done

polybar --reload example --config=$HOME/.config/polybar/config.ini &

echo "Bars launched..."




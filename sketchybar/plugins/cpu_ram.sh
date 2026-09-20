#!/usr/bin/env bash

BIN_DIR="$CONFIG_DIR/bin"
read -r CPU RAM < <("$BIN_DIR/get_sysinfo" 2>/dev/null)

[ -z "$CPU" ] && CPU="0"
[ -z "$RAM" ] && RAM="0.0G"

# Dynamic CPU color
if [ "$CPU" -ge 80 ]; then
    CPU_COLOR="0xfff38ba8" # Red
elif [ "$CPU" -ge 50 ]; then
    CPU_COLOR="0xfffab387" # Peach
else
    CPU_COLOR="0xff89dceb" # Sky
fi

sketchybar --set cpu label="${CPU}%" icon.color="$CPU_COLOR" \
           --set ram label="${RAM}"

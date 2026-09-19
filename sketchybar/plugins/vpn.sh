#!/usr/bin/env bash

if [ "$1" = "toggle" ]; then
    if pgrep -x Shadowrocket >/dev/null; then
        osascript -e 'tell application "Shadowrocket" to quit' 2>/dev/null
    else
        open -a Shadowrocket 2>/dev/null
    fi
    sleep 0.3
fi

if scutil --nc list | grep -q "(Connected)"; then
    STATUS="ON"
    ICON="󰖂"
    COLOR="0xffa6e3a1"
else
    STATUS="OFF"
    ICON="󰖂"
    COLOR="0xff6c7086"
fi

NAME="${NAME:-vpn}"
sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="$STATUS" label.color="$COLOR"

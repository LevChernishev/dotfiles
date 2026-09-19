#!/usr/bin/env bash

BIN_DIR="$CONFIG_DIR/bin"
read -r VOLUME MUTED < <("$BIN_DIR/get_volume" 2>/dev/null)

if [ -z "$VOLUME" ]; then
    VOLUME=50
    MUTED=0
fi

if [ "$MUTED" = "1" ] || [ "$VOLUME" = "0" ]; then
    ICON="󰖁"
    COLOR="0xff6c7086"
else
    COLOR="0xffcdd6f4"
    case "$VOLUME" in
        [6-9][0-9]|100) ICON="󰕾" ;;
        [3-5][0-9]) ICON="󰖀" ;;
        *) ICON="󰕿" ;;
    esac
fi

NAME="${NAME:-volume}"
sketchybar --set "$NAME" icon="$ICON" label="${VOLUME}%" icon.color="$COLOR"

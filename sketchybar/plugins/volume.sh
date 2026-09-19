#!/usr/bin/env bash

if [ "$SENDER" = "volume_change" ]; then
    VOLUME="$INFO"
else
    VOLUME=$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)
fi

MUTED=$(osascript -e 'output muted of (get volume settings)' 2>/dev/null)

if [ "$MUTED" = "true" ] || [ "$VOLUME" = "0" ]; then
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

sketchybar --set "$NAME" icon="$ICON" label="${VOLUME}%" icon.color="$COLOR"

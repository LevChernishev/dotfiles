#!/usr/bin/env bash

BATT_INFO=$(pmset -g batt 2>/dev/null)
PERCENTAGE=$(echo "$BATT_INFO" | grep -Eo "\d+%" | cut -d% -f1 | head -1)
AC_POWER=$(echo "$BATT_INFO" | grep -i 'AC Power')

if [ -z "$PERCENTAGE" ]; then
    PERCENTAGE="100"
fi

COLOR="0xffcdd6f4"

if [ -n "$AC_POWER" ]; then
    ICON=""
    COLOR="0xffa6e3a1"
else
    case "${PERCENTAGE}" in
        9[0-9]|100) ICON="" ;;
        [6-8][0-9]) ICON="" ;;
        [3-5][0-9]) ICON="" ;;
        [1-2][0-9]) ICON=""; COLOR="0xfffab387" ;;
        *) ICON=""; COLOR="0xfff38ba8" ;;
    esac
fi

sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%" icon.color="$COLOR"

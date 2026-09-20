#!/usr/bin/env bash

NAME="${NAME:-battery}"

if [ "$1" = "details" ] || [ "$1" = "toggle" ]; then
    BD=$(ioreg -r -c AppleSmartBattery -d 1 | grep '"BatteryData"')
    FCC=$(echo "$BD" | sed -E 's/.*"FullChargeCapacity"=([0-9]+).*/\1/')
    DC=$(echo "$BD" | sed -E 's/.*"DesignCapacity"=([0-9]+).*/\1/')
    CYCLES=$(ioreg -r -c AppleSmartBattery -d 1 | grep '"CycleCount" =' | head -1 | awk '{print $3}')
    if [ -n "$DC" ] && [ "$DC" -gt 0 ]; then
        HEALTH=$(( FCC * 100 / DC ))
    else
        HEALTH=100
    fi
    
    BATT_INFO=$(pmset -g batt 2>/dev/null)
    if echo "$BATT_INFO" | grep -qi 'AC Power'; then
        CHARGING_STATUS="Питание: Сеть (AC)"
    else
        CHARGING_STATUS="Питание: Аккумулятор"
    fi

    sketchybar --set battery.health label="Здоровье: ${HEALTH}% (${FCC}/${DC} mAh)" \
               --set battery.cycles label="Циклы: ${CYCLES}" \
               --set battery.source label="$CHARGING_STATUS"
    exit 0
fi

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
        9[0-9]|100) ICON=""; COLOR="0xffa6e3a1" ;;
        [6-8][0-9]) ICON=""; COLOR="0xffcdd6f4" ;;
        [4-5][0-9]) ICON=""; COLOR="0xffcdd6f4" ;;
        [2-3][0-9]) ICON=""; COLOR="0xfffab387" ;;
        *)          ICON="󰂃"; COLOR="0xfff38ba8" ;;
    esac
fi

sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%" icon.color="$COLOR"

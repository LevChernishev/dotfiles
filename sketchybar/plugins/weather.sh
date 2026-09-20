#!/usr/bin/env bash

CACHE_FILE="/tmp/sketchybar_weather.cache"
CACHE_AGE=1800 # 30 minutes
NOW=$(date +%s)

FETCH_NEW=0
if [ ! -f "$CACHE_FILE" ]; then
    FETCH_NEW=1
else
    LAST_MOD=$(stat -f %m "$CACHE_FILE" 2>/dev/null || stat -c %Y "$CACHE_FILE" 2>/dev/null)
    if [ $((NOW - LAST_MOD)) -gt $CACHE_AGE ]; then
        FETCH_NEW=1
    fi
fi

if [ "$FETCH_NEW" -eq 1 ]; then
    DATA=$(curl -s --connect-timeout 2 "wttr.in/?format=%c+%t&m" 2>/dev/null)
    # Check if data looks like weather (contains °C)
    if echo "$DATA" | grep -q '°C'; then
        # Clean extra spaces
        CLEANED=$(echo "$DATA" | xargs)
        echo "$CLEANED" > "$CACHE_FILE"
    fi
fi

if [ -f "$CACHE_FILE" ]; then
    read -r WEATHER < "$CACHE_FILE"
    if [ -n "$WEATHER" ]; then
        sketchybar --set weather drawing=on label="$WEATHER"
        exit 0
    fi
fi

sketchybar --set weather drawing=off

#!/usr/bin/env bash

NAME="${NAME:-clock}"

if [ "$1" = "toggle" ] || [ "$1" = "update" ]; then
    CAL_HEADER="$(date '+%A, %d %B %Y')"
    sketchybar --set cal.header label="$CAL_HEADER"

    i=1
    cal | sed 's/_ //g' | while IFS= read -r line; do
        [ -z "$line" ] && continue
        sketchybar --set "cal.r.$i" label="$line" drawing=on
        i=$((i+1))
    done
    while [ "$i" -le 8 ]; do
        sketchybar --set "cal.r.$i" drawing=off
        i=$((i+1))
    done
    exit 0
fi

sketchybar --set "$NAME" icon="" label="$(date '+%H:%M')"

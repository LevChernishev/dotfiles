#!/usr/bin/env bash

NAME="${NAME:-clock}"

if [ "$1" = "toggle" ] || [ "$1" = "update" ]; then
    CAL_HEADER="$(date '+%A, %d %B %Y')"
    args=(--set cal.header label="$CAL_HEADER")

    idx=1
    while IFS= read -r line; do
        if [ -n "$line" ] && [ "$idx" -le 8 ]; then
            args+=(--set "cal.r.$idx" label="$line" drawing=on)
            idx=$((idx+1))
        fi
    done < <(cal | sed 's/_ //g')

    while [ "$idx" -le 8 ]; do
        args+=(--set "cal.r.$idx" drawing=off)
        idx=$((idx+1))
    done

    sketchybar "${args[@]}"
    exit 0
fi

sketchybar --set "$NAME" icon="" label="$(date '+%H:%M')"

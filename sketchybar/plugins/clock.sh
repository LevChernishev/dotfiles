#!/usr/bin/env bash

NAME="${NAME:-clock}"

if [ "$1" = "toggle" ] || [ "$1" = "update" ]; then
    CAL_HEADER="$(date '+%A, %d %B %Y')"
    # Format cal output cleanly
    CAL_VIEW="$(cal | sed 's/_ //g')"
    sketchybar --set calendar.header label="$CAL_HEADER" \
               --set calendar.view label="$CAL_VIEW"
    exit 0
fi

sketchybar --set "$NAME" icon="" label="$(date '+%H:%M')"

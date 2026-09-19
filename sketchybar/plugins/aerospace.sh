#!/usr/bin/env bash

# $1 is workspace ID
if [ -z "$FOCUSED_WORKSPACE" ]; then
    FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null)
fi

OCCUPIED=$(aerospace list-workspaces --monitor all --empty no 2>/dev/null | grep -x "$1")

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set "$NAME" \
        drawing=on \
        background.drawing=on \
        background.color=0xffcba6f7 \
        icon.color=0xff11111b
elif [ -n "$OCCUPIED" ]; then
    sketchybar --set "$NAME" \
        drawing=on \
        background.drawing=on \
        background.color=0x33ffffff \
        icon.color=0xffcdd6f4
else
    # Hide empty inactive workspaces to keep the bar ultra-clean
    sketchybar --set "$NAME" drawing=off
fi

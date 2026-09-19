#!/usr/bin/env bash

if [ -z "$FOCUSED_WORKSPACE" ]; then
    FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null)
fi

OCCUPIED=$(aerospace list-workspaces --monitor all --empty no 2>/dev/null | grep -x "$1")

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set "$NAME" \
        background.drawing=on \
        background.color=0xffcba6f7 \
        icon.color=0xff11111b
elif [ -n "$OCCUPIED" ]; then
    sketchybar --set "$NAME" \
        background.drawing=on \
        background.color=0x4445475a \
        icon.color=0xffcdd6f4
else
    sketchybar --set "$NAME" \
        background.drawing=off \
        icon.color=0xff585b70
fi

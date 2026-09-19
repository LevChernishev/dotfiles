#!/usr/bin/env bash

FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"
OCCUPIED=($(aerospace list-workspaces --monitor all --empty no 2>/dev/null))

ARGS=()

for sid in 1 2 3 4 5 6 7 8 9; do
    if [ "$sid" = "$FOCUSED" ]; then
        ARGS+=(--set "space.$sid" \
            drawing=on \
            background.drawing=on \
            background.color=0xffcba6f7 \
            icon.color=0xff11111b)
    elif [[ " ${OCCUPIED[*]} " =~ " ${sid} " ]]; then
        ARGS+=(--set "space.$sid" \
            drawing=on \
            background.drawing=on \
            background.color=0x22ffffff \
            icon.color=0xffcdd6f4)
    else
        ARGS+=(--set "space.$sid" drawing=off)
    fi
done

sketchybar "${ARGS[@]}"

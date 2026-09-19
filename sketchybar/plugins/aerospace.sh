#!/usr/bin/env bash

FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"
[ -z "$FOCUSED" ] && FOCUSED="1"

ARGS=()

for sid in 1 2 3 4 5 6 7 8 9; do
    if [ "$sid" = "$FOCUSED" ]; then
        ARGS+=(--set "space.$sid" \
            background.drawing=on \
            background.color=0xffcba6f7 \
            icon.color=0xff11111b)
    else
        ARGS+=(--set "space.$sid" \
            background.drawing=on \
            background.color=0x22ffffff \
            icon.color=0xffcdd6f4)
    fi
done

sketchybar "${ARGS[@]}"


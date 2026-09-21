#!/usr/bin/env bash

BIN_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}/bin"

if [ "$1" = "toggle" ]; then
    "$BIN_DIR/get_layout" toggle >/dev/null 2>&1
    exit 0
fi

LAYOUT=$("$BIN_DIR/get_layout" 2>/dev/null)
[ -z "$LAYOUT" ] && LAYOUT="EN"

CACHE_FILE="/tmp/.sketchybar_layout"
if [ -f "$CACHE_FILE" ]; then
    read -r PREV_LAYOUT < "$CACHE_FILE"
    if [ "$PREV_LAYOUT" = "$LAYOUT" ]; then
        exit 0
    fi
fi

echo "$LAYOUT" > "$CACHE_FILE"
sketchybar --set "${NAME:-keyboard}" label="$LAYOUT"

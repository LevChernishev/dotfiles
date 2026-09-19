#!/usr/bin/env bash

if [ "$1" = "toggle" ]; then
    LAYOUT=$("$CONFIG_DIR/bin/get_layout" toggle)
else
    LAYOUT=$("$CONFIG_DIR/bin/get_layout")
fi

sketchybar --set "$NAME" label="$LAYOUT"

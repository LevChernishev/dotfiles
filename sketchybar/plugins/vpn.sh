#!/usr/bin/env bash

NAME="${NAME:-vpn}"
CACHE_FILE="$HOME/.config/shadowrocket/current_server"
PREF_PLIST="/Users/lev/Library/Group Containers/group.com.liguangming.Shadowrocket/Library/Preferences/group.com.liguangming.Shadowrocket.plist"

format_server_name() {
    local raw="$1"
    if [ -z "$raw" ]; then
        echo "ON"
        return
    fi
    local cleaned="${raw//-lev/}"
    echo "$cleaned"
}

if [ "$1" = "toggle" ]; then
    if scutil --nc status "Shadowrocket" 2>/dev/null | grep -q "^Connected"; then
        scutil --nc stop "Shadowrocket"
    else
        scutil --nc start "Shadowrocket"
    fi
    sleep 0.2
fi

IS_CONNECTED=$(scutil --nc status "Shadowrocket" 2>/dev/null | grep -q "^Connected" && echo "yes" || echo "no")

if [ "$IS_CONNECTED" = "yes" ]; then
    # Try reading from plutil if accessible, otherwise fall back to cache
    RAW_SERVER=$(plutil -p "$PREF_PLIST" 2>/dev/null | grep -o '"group.com.liguangming.SelectedServerName" => ".*"' | cut -d'"' -f4)
    if [ -n "$RAW_SERVER" ]; then
        echo "$RAW_SERVER" > "$CACHE_FILE"
    elif [ -f "$CACHE_FILE" ]; then
        RAW_SERVER=$(cat "$CACHE_FILE")
    fi

    STATUS=$(format_server_name "$RAW_SERVER")
    ICON="󰖂"
    COLOR="0xffa6e3a1" # Catppuccin Green
else
    STATUS="OFF"
    ICON="󰖂"
    COLOR="0xff6c7086" # Catppuccin Gray
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="$STATUS" label.color="$COLOR"

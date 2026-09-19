#!/usr/bin/env bash

API="http://127.0.0.1:9090"

handle_toggle() {
    local button="$1"
    local current
    current=$(curl -s --max-time 0.5 "$API/proxies/proxy" 2>/dev/null | jq -r .now 2>/dev/null)

    if [ -n "$current" ] && [ "$current" != "null" ]; then
        if [ "$button" = "right" ]; then
            # Right-click: switch between VLESS and Hysteria2
            if [ "$current" = "Sweden VLESS-lev" ]; then
                curl -s -X PUT "$API/proxies/proxy" -d '{"name":"Sweden Hysteria2"}' >/dev/null
            else
                curl -s -X PUT "$API/proxies/proxy" -d '{"name":"Sweden VLESS-lev"}' >/dev/null
            fi
        else
            # Left-click: toggle ON / OFF
            if [ "$current" = "direct" ]; then
                curl -s -X PUT "$API/proxies/proxy" -d '{"name":"Sweden VLESS-lev"}' >/dev/null
            else
                curl -s -X PUT "$API/proxies/proxy" -d '{"name":"direct"}' >/dev/null
            fi
        fi
    else
        # If sing-box not running yet, toggle Shadowrocket
        if pgrep -x Shadowrocket >/dev/null; then
            osascript -e 'tell application "Shadowrocket" to quit' 2>/dev/null
        else
            open -a Shadowrocket 2>/dev/null
        fi
    fi
    sleep 0.1
}

if [ "$1" = "toggle" ]; then
    handle_toggle "$BUTTON"
fi

# Check sing-box first
CURRENT=$(curl -s --max-time 0.3 "$API/proxies/proxy" 2>/dev/null | jq -r .now 2>/dev/null)

if [ -n "$CURRENT" ] && [ "$CURRENT" != "null" ]; then
    if [ "$CURRENT" != "direct" ]; then
        STATUS="ON"
        ICON="󰖂"
        COLOR="0xffa6e3a1" # Catppuccin Green
    else
        STATUS="OFF"
        ICON="󰖂"
        COLOR="0xff6c7086" # Catppuccin Gray
    fi
elif scutil --nc list | grep -q "(Connected)"; then
    STATUS="ON"
    ICON="󰖂"
    COLOR="0xffa6e3a1" # Catppuccin Green
else
    STATUS="OFF"
    ICON="󰖂"
    COLOR="0xff6c7086" # Catppuccin Gray
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="$STATUS" label.color="$COLOR"

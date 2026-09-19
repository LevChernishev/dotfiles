#!/usr/bin/env bash

API="http://127.0.0.1:9090"
CACHE_FILE="/tmp/sing-box-last-proxy"

format_server_name() {
    local raw="$1"
    case "$raw" in
        "Sweden VLESS-lev") echo "SE · VLESS" ;;
        "Sweden Hysteria2") echo "SE · Hy2" ;;
        "direct"|"")        echo "OFF" ;;
        *)
            local cleaned="$raw"
            cleaned="${cleaned//-lev/}"
            cleaned="${cleaned//Sweden/SE}"
            cleaned="${cleaned//Germany/DE}"
            cleaned="${cleaned//Finland/FI}"
            cleaned="${cleaned//Netherlands/NL}"
            echo "$cleaned"
            ;;
    esac
}

handle_toggle() {
    local button="$1"
    local current
    current=$(curl -s --max-time 0.5 "$API/proxies/proxy" 2>/dev/null | jq -r .now 2>/dev/null)

    if [ -n "$current" ] && [ "$current" != "null" ]; then
        if [ "$button" = "right" ]; then
            # Right-click: cycle to next server among all non-direct proxies
            local all_proxies=()
            while IFS= read -r line; do
                [ -n "$line" ] && all_proxies+=("$line")
            done < <(curl -s --max-time 0.5 "$API/proxies/proxy" 2>/dev/null | jq -r '.all[]' | grep -v '^direct$')

            local count=${#all_proxies[@]}
            if [ "$count" -gt 1 ]; then
                local next_proxy="${all_proxies[0]}"
                for i in "${!all_proxies[@]}"; do
                    if [ "${all_proxies[$i]}" = "$current" ]; then
                        local next_idx=$(( (i + 1) % count ))
                        next_proxy="${all_proxies[$next_idx]}"
                        break
                    fi
                done
                curl -s -X PUT "$API/proxies/proxy" -d "{\"name\":\"$next_proxy\"}" >/dev/null
                echo "$next_proxy" > "$CACHE_FILE"
            fi
        else
            # Left-click: toggle ON / OFF
            if [ "$current" = "direct" ]; then
                local last_proxy="Sweden VLESS-lev"
                [ -f "$CACHE_FILE" ] && last_proxy=$(cat "$CACHE_FILE")
                curl -s -X PUT "$API/proxies/proxy" -d "{\"name\":\"$last_proxy\"}" >/dev/null
            else
                echo "$current" > "$CACHE_FILE"
                curl -s -X PUT "$API/proxies/proxy" -d '{"name":"direct"}' >/dev/null
            fi
        fi
    else
        # Fallback: if sing-box is not running, toggle Shadowrocket
        if pgrep -x Shadowrocket >/dev/null; then
            osascript -e 'tell application "Shadowrocket" to quit' 2>/dev/null
        else
            open -a Shadowrocket 2>/dev/null
        fi
    fi
    sleep 0.1
}

# Handle click events from mouse.clicked or toggle argument
if [ "$SENDER" = "mouse.clicked" ] || [ "$1" = "toggle" ]; then
    btn="${BUTTON:-left}"
    if [ -n "$INFO" ]; then
        parsed_btn=$(echo "$INFO" | jq -r .button 2>/dev/null)
        [ -n "$parsed_btn" ] && [ "$parsed_btn" != "null" ] && btn="$parsed_btn"
    fi
    handle_toggle "$btn"
fi

# Query current status from sing-box API
CURRENT=$(curl -s --max-time 0.3 "$API/proxies/proxy" 2>/dev/null | jq -r .now 2>/dev/null)

if [ -n "$CURRENT" ] && [ "$CURRENT" != "null" ]; then
    if [ "$CURRENT" != "direct" ]; then
        STATUS=$(format_server_name "$CURRENT")
        ICON="󰖂"
        COLOR="0xffa6e3a1" # Catppuccin Green
    else
        STATUS="OFF"
        ICON="󰖂"
        COLOR="0xff6c7086" # Catppuccin Gray
    fi
elif scutil --nc list | grep -q "(Connected)"; then
    STATUS="SR (ON)"
    ICON="󰖂"
    COLOR="0xffa6e3a1" # Catppuccin Green
else
    STATUS="OFF"
    ICON="󰖂"
    COLOR="0xff6c7086" # Catppuccin Gray
fi

NAME="${NAME:-vpn}"
sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="$STATUS" label.color="$COLOR"

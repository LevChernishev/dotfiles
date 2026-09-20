#!/usr/bin/env bash

APP="${INFO:-}"

if [ -z "$APP" ]; then
    APP="$(osascript -e 'tell application "System Events" to get name of first process whose frontmost is true' 2>/dev/null)"
fi

[ -z "$APP" ] && exit 0

case "$APP" in
    "Google Chrome"|"Chrome")                  ICON="󰊯" ;;
    "Antigravity")                             ICON="󰚩" ;;
    "Safari")                                  ICON="󰈹" ;;
    "Ghostty"|"Terminal"|"iTerm2"|"Alacritty") ICON="" ;;
    "Zed"|"Code"|"Cursor"|"Neovim")            ICON="󰨞" ;;
    "Telegram")                                ICON="" ;;
    "Finder")                                  ICON="󰀶" ;;
    "Spotify")                                 ICON="󰓇" ;;
    "Discord")                                 ICON="󰙯" ;;
    "Mail")                                    ICON="󰇮" ;;
    "Settings"|"System Settings")              ICON="󰒓" ;;
    "Notes")                                   ICON="󱞁" ;;
    "Postgres"|"DBeaver")                      ICON="󰆼" ;;
    *)                                         ICON="󰘔" ;;
esac

sketchybar --set front_app icon="$ICON" label="$APP"
"$CONFIG_DIR/plugins/space_windows.sh" &

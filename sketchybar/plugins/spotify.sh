#!/bin/zsh

SCRIPT_PATH="$CONFIG_DIR/bin/get_spotify.scpt"
if [[ ! -f "$SCRIPT_PATH" ]]; then
  SCRIPT_PATH="/Users/lev/.config/sketchybar/bin/get_spotify.scpt"
fi

TITLE=$(osascript "$SCRIPT_PATH" 2>/dev/null)

if [[ -n "$TITLE" ]]; then
  CLEAN="${TITLE#Spotify - }"
  CLEAN="${CLEAN#Spotify – }"
  if (( ${#CLEAN} > 32 )); then
    DISPLAY_TITLE="${CLEAN[1,30]}…"
  else
    DISPLAY_TITLE="$CLEAN"
  fi
  /opt/homebrew/bin/sketchybar --set spotify drawing=on label="$DISPLAY_TITLE"
else
  /opt/homebrew/bin/sketchybar --set spotify drawing=off
fi

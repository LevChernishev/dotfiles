#!/bin/zsh

RAW=$(/opt/homebrew/bin/nowplaying-cli get --json title artist playbackRate clientBundleIdentifier 2>/dev/null)

if [[ -z "$RAW" ]]; then
  /opt/homebrew/bin/sketchybar --set media drawing=off 2>/dev/null || /opt/homebrew/bin/sketchybar --set spotify drawing=off 2>/dev/null
  exit 0
fi

# Parse safely with jq into tab-separated variables
IFS=$'\t' read -r TITLE ARTIST RATE BUNDLE <<< "$(/opt/homebrew/bin/jq -r '
  if .title == null or .title == "" then 
    "EMPTY" 
  else 
    "\(.title)\t\(.artist // "")\t\(.playbackRate // 0)\t\(.clientBundleIdentifier // "")" 
  end' <<< "$RAW")"

if [[ "$TITLE" == "EMPTY" || -z "$TITLE" ]]; then
  /opt/homebrew/bin/sketchybar --set media drawing=off 2>/dev/null || /opt/homebrew/bin/sketchybar --set spotify drawing=off 2>/dev/null
  exit 0
fi

# Clean up common web suffixes / prefixes
TITLE="${TITLE% - YouTube}"
TITLE="${TITLE% – YouTube}"
TITLE="${TITLE#Spotify - }"
TITLE="${TITLE#Spotify – }"

# Detect app and select icon + accent color
if [[ "$BUNDLE" == *"spotify"* ]] || [[ "$BUNDLE" == *"pjibgclleladliembfgfagdaldikeohf"* ]] || [[ "$TITLE" == *"Spotify"* ]]; then
  APP_ICON="󰓇"
  ACTIVE_COLOR="0xffa6e3a1" # Catppuccin Green
elif [[ "$BUNDLE" == *"iina"* ]] || [[ "$BUNDLE" == *"vlc"* ]] || [[ "$BUNDLE" == *"QuickTime"* ]]; then
  APP_ICON="󰿎"
  ACTIVE_COLOR="0xffb4befe" # Catppuccin Lavender
elif [[ "$TITLE" == *"YouTube"* ]] || [[ "$ARTIST" == *"YouTube"* ]] || [[ "$BUNDLE" == *"chrome"* && "$TITLE" == *"[YouTube]"* ]]; then
  APP_ICON=""
  ACTIVE_COLOR="0xfff38ba8" # Catppuccin Red
elif [[ "$BUNDLE" == *"Music"* ]]; then
  APP_ICON="󰎆"
  ACTIVE_COLOR="0xfff38ba8" # Apple Music pink/red
else
  APP_ICON="󰝚"
  ACTIVE_COLOR="0xff89dceb" # Catppuccin Sky
fi

# Compose display text: "Title • Artist" or "Title"
if [[ -n "$ARTIST" && "$ARTIST" != "$TITLE" && "$ARTIST" != "YouTube" ]]; then
  DISPLAY_TEXT="${TITLE} • ${ARTIST}"
else
  DISPLAY_TEXT="${TITLE}"
fi

# Truncate if too long (max 30 chars)
if (( ${#DISPLAY_TEXT} > 30 )); then
  DISPLAY_TEXT="${DISPLAY_TEXT[1,28]}…"
fi

# Target item name (support both media and spotify)
ITEM="media"
if ! /opt/homebrew/bin/sketchybar --query media >/dev/null 2>&1; then
  ITEM="spotify"
fi

if [[ "$RATE" == "1" ]]; then
  # PLAYING: Bright colors, active border, playing app icon
  /opt/homebrew/bin/sketchybar --set "$ITEM" \
    drawing=on \
    icon="$APP_ICON" \
    icon.color="$ACTIVE_COLOR" \
    background.border_color="$ACTIVE_COLOR" \
    background.border_width=1 \
    label="$DISPLAY_TEXT" \
    label.color=0xffcdd6f4
else
  # PAUSED: DO NOT HIDE! Show pause indicator, dimmed colors, preserve title
  /opt/homebrew/bin/sketchybar --set "$ITEM" \
    drawing=on \
    icon="󰏤" \
    icon.color=0x88fab387 \
    background.border_color=0x22ffffff \
    background.border_width=1 \
    label="$DISPLAY_TEXT" \
    label.color=0x66cdd6f4
fi

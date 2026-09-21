#!/bin/zsh

ITEM="spotify"
if /opt/homebrew/bin/sketchybar --query media >/dev/null 2>&1; then
  ITEM="media"
fi

# 1. OPTIMISTIC INSTANT CLICK HANDLER (< 10ms)
if [[ "$1" == "click" ]]; then
  QUERY=$(/opt/homebrew/bin/sketchybar --query "$ITEM" 2>/dev/null)
  if [[ "$QUERY" == *'"value": "󰏤"'* ]]; then
    # Was paused -> immediately flip to playing state
    /opt/homebrew/bin/sketchybar --set "$ITEM" icon="󰓇" icon.color=0xffa6e3a1 background.border_color=0xffa6e3a1 label.color=0xffcdd6f4
  else
    # Was playing -> immediately flip to paused state
    /opt/homebrew/bin/sketchybar --set "$ITEM" icon="󰏤" icon.color=0x88fab387 background.border_color=0x22ffffff label.color=0x66cdd6f4
  fi
  # Dispatch toggle asynchronously in background, then re-sync
  ( /opt/homebrew/bin/nowplaying-cli togglePlayPause && sleep 0.15 && /Users/lev/.config/sketchybar/plugins/media.sh sync ) >/dev/null 2>&1 &
  exit 0
fi

# 2. QUERY NOW PLAYING (Pure zsh array parsing without jq)
RAW=("${(@f)$(/opt/homebrew/bin/nowplaying-cli get title artist playbackRate clientBundleIdentifier 2>/dev/null)}")

TITLE="${RAW[1]}"
ARTIST="${RAW[2]}"
RATE="${RAW[3]}"
BUNDLE="${RAW[4]}"

if [[ "$TITLE" == "null" || -z "$TITLE" ]]; then
  /opt/homebrew/bin/sketchybar --set "$ITEM" drawing=off
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
if [[ -n "$ARTIST" && "$ARTIST" != "null" && "$ARTIST" != "$TITLE" && "$ARTIST" != "YouTube" ]]; then
  DISPLAY_TEXT="${TITLE} • ${ARTIST}"
else
  DISPLAY_TEXT="${TITLE}"
fi

# Truncate if too long (max 28 chars)
if (( ${#DISPLAY_TEXT} > 28 )); then
  DISPLAY_TEXT="${DISPLAY_TEXT[1,26]}…"
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
  # PAUSED: DO NOT HIDE! Show pause indicator, dimmed colors, keep track name
  /opt/homebrew/bin/sketchybar --set "$ITEM" \
    drawing=on \
    icon="󰏤" \
    icon.color=0x88fab387 \
    background.border_color=0x22ffffff \
    background.border_width=1 \
    label="$DISPLAY_TEXT" \
    label.color=0x66cdd6f4
fi

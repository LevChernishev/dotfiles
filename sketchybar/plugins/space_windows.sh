#!/bin/zsh

get_icon() {
  case "$1" in
    "Google Chrome"|"Chrome")                  echo "󰊯" ;;
    "Antigravity")                             echo "󰚩" ;;
    "Safari")                                  echo "󰈹" ;;
    "Ghostty"|"Terminal"|"iTerm2"|"Alacritty") echo "" ;;
    "Zed"|"Code"|"Cursor"|"Neovim")            echo "󰨞" ;;
    "Telegram"|"Telegram Web")                 echo "" ;;
    "Finder")                                  echo "󰀶" ;;
    "Spotify")                                 echo "󰓇" ;;
    "Discord")                                 echo "󰙯" ;;
    "Mail")                                    echo "󰇮" ;;
    "Postgres"|"DBeaver")                      echo "󰆼" ;;
    "Obsidian")                                echo "󱞁" ;;
    *)                                         echo "󰘔" ;;
  esac
}

typeset -A ws_icons

while IFS='|' read -r ws app; do
  [[ -z "$ws" ]] && continue
  ws="${ws// /}"
  app="${app## }"
  app="${app%% }"
  icon="$(get_icon "$app")"
  if [[ ! " ${ws_icons[$ws]} " == *" $icon "* ]]; then
    ws_icons[$ws]+=" $icon"
  fi
done < <(/opt/homebrew/bin/aerospace list-windows --all --format '%{workspace}|%{app-name}' 2>/dev/null)

FOCUSED="${AEROSPACE_FOCUSED_WORKSPACE:-$(/opt/homebrew/bin/aerospace list-workspaces --focused 2>/dev/null)}"
[[ -z "$FOCUSED" ]] && FOCUSED="1"

args=()

for sid in 1 2 3 4 5 6 7 8 9 S; do
  icons="${ws_icons[$sid]:-}"
  icons="${icons## }"
  icons="${icons%% }"

  if [[ "$sid" == "$FOCUSED" ]]; then
    # Active/Focused workspace: Solid Mauve highlight pill
    if [[ -n "$icons" ]]; then
      args+=(--set "space.$sid" drawing=on background.drawing=on background.color=0xffcba6f7 background.border_width=0 icon.color=0xff11111b label.color=0xff11111b label="$icons" label.drawing=on icon.padding_left=8 icon.padding_right=4 label.padding_right=8)
    else
      args+=(--set "space.$sid" drawing=on background.drawing=on background.color=0xffcba6f7 background.border_width=0 icon.color=0xff11111b label.color=0xff11111b label="" label.drawing=off icon.padding_left=8 icon.padding_right=8)
    fi
  elif [[ -n "$icons" ]]; then
    # Inactive workspace WITH windows: Dark pill with app icons
    args+=(--set "space.$sid" drawing=on background.drawing=on background.color=0xee181825 background.border_width=1 background.border_color=0x22ffffff icon.color=0xffcdd6f4 label.color=0xffcdd6f4 label="$icons" label.drawing=on icon.padding_left=8 icon.padding_right=4 label.padding_right=8)
  else
    # Inactive workspace WITHOUT windows (Empty): Dimmed subtle marker
    if [[ "$sid" == "S" ]]; then
      args+=(--set "space.$sid" drawing=off)
    else
      args+=(--set "space.$sid" drawing=on background.drawing=off background.border_width=0 icon.color=0x44cdd6f4 label="" label.drawing=off icon.padding_left=6 icon.padding_right=6)
    fi
  fi
done

if (( ${#args[@]} > 0 )); then
  /opt/homebrew/bin/sketchybar "${args[@]}"
fi

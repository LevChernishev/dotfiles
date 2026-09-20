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
  app="$(echo "$app" | xargs)"
  icon="$(get_icon "$app")"
  if [[ ! " ${ws_icons[$ws]} " == *" $icon "* ]]; then
    ws_icons[$ws]="${ws_icons[$ws]} $icon"
  fi
done < <(/opt/homebrew/bin/aerospace list-windows --all --format '%{workspace}|%{app-name}' 2>/dev/null)

args=()
for sid in 1 2 3 4 5 6 7 8 9; do
  icons="$(echo "${ws_icons[$sid]}" | xargs)"
  if [[ -n "$icons" ]]; then
    args+=(--set "space.$sid" label="$icons" label.drawing=on icon.padding_right=2 label.padding_right=8)
  else
    args+=(--set "space.$sid" label="" label.drawing=off icon.padding_right=8)
  fi
done

if (( ${#args[@]} > 0 )); then
  /opt/homebrew/bin/sketchybar "${args[@]}"
fi

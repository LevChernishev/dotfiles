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

echo " ${(k)ws_icons} " > /tmp/sketchybar_occupied_spaces

FOCUSED="${AEROSPACE_FOCUSED_WORKSPACE:-$(/opt/homebrew/bin/aerospace list-workspaces --focused 2>/dev/null)}"
[[ -z "$FOCUSED" ]] && FOCUSED="1"

FOCUSED_APP="$(/opt/homebrew/bin/aerospace list-windows --focused --format '%{app-name}' 2>/dev/null)"
FOCUSED_ICON=""
[[ -n "$FOCUSED_APP" ]] && FOCUSED_ICON="$(get_icon "$FOCUSED_APP")"

args=()

for sid in 1 2 3 4 5 6 7 8 9 S; do
  raw_icons="${ws_icons[$sid]:-}"
  raw_icons="${raw_icons## }"
  raw_icons="${raw_icons%% }"

  if [[ "$sid" == "$FOCUSED" ]]; then
    # Focused Workspace
    if [[ -n "$raw_icons" ]]; then
      if [[ -n "$FOCUSED_ICON" && " $raw_icons " == *" $FOCUSED_ICON "* ]]; then
        # Active app is in this focused workspace: highlight it in contrast with the space number
        icon_str="$sid  $FOCUSED_ICON"
        # Other apps in this workspace are inactive / dimmed
        other_icons=""
        for ic in ${(z)raw_icons}; do
          if [[ "$ic" != "$FOCUSED_ICON" ]]; then
            other_icons+="$ic "
          fi
        done
        other_icons="${other_icons%% }"

        if [[ -n "$other_icons" ]]; then
          args+=(--set "space.$sid" drawing=on background.drawing=on background.color=0xee181825 background.border_color=0xffcba6f7 background.border_width=1.5 icon="$icon_str" icon.color=0xffcba6f7 icon.padding_left=8 icon.padding_right=4 label="$other_icons" label.color=0x55cdd6f4 label.drawing=on label.padding_right=8)
        else
          args+=(--set "space.$sid" drawing=on background.drawing=on background.color=0xee181825 background.border_color=0xffcba6f7 background.border_width=1.5 icon="$icon_str" icon.color=0xffcba6f7 icon.padding_left=8 icon.padding_right=8 label="" label.drawing=off)
        fi
      else
        # Fallback if no focused icon match
        args+=(--set "space.$sid" drawing=on background.drawing=on background.color=0xee181825 background.border_color=0xffcba6f7 background.border_width=1.5 icon="$sid" icon.color=0xffcba6f7 icon.padding_left=8 icon.padding_right=4 label="$raw_icons" label.color=0xffcdd6f4 label.drawing=on label.padding_right=8)
      fi
    else
      # Empty focused workspace
      args+=(--set "space.$sid" drawing=on background.drawing=on background.color=0xee181825 background.border_color=0xffcba6f7 background.border_width=1.5 icon="$sid" icon.color=0xffcba6f7 icon.padding_left=8 icon.padding_right=8 label="" label.drawing=off)
    fi
  elif [[ -n "$raw_icons" ]]; then
    # Inactive Workspace with windows: all icons dimmed / low contrast
    args+=(--set "space.$sid" drawing=on background.drawing=on background.color=0xee181825 background.border_width=1 background.border_color=0x22ffffff icon="$sid" icon.color=0x88cdd6f4 icon.padding_left=8 icon.padding_right=4 label="$raw_icons" label.color=0x55cdd6f4 label.drawing=on label.padding_right=8)
  else
    # Inactive empty workspace
    if [[ "$sid" == "S" ]]; then
      args+=(--set "space.$sid" drawing=off)
    else
      args+=(--set "space.$sid" drawing=on background.drawing=off background.border_width=0 icon="$sid" icon.color=0x44cdd6f4 icon.padding_left=6 icon.padding_right=6 label="" label.drawing=off)
    fi
  fi
done

if (( ${#args[@]} > 0 )); then
  /opt/homebrew/bin/sketchybar "${args[@]}"
fi

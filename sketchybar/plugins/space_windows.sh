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

LOCK_FILE="/tmp/space_windows.lock"
PENDING_FILE="/tmp/space_windows.pending"

if [[ -f "$LOCK_FILE" ]]; then
  OLD_PID=$(<"$LOCK_FILE" 2>/dev/null)
  if [[ -n "$OLD_PID" ]] && kill -0 "$OLD_PID" 2>/dev/null; then
    touch "$PENDING_FILE"
    exit 0
  fi
fi

echo "$$" > "$LOCK_FILE"
trap 'rm -f "$LOCK_FILE" "$PENDING_FILE"' EXIT INT TERM

while true; do
  rm -f "$PENDING_FILE"
  typeset -A ws_icons

while IFS='|' read -r ws app; do
  [[ -z "$ws" ]] && continue
  ws="${ws// /}"
  app="${app## }"
  app="${app%% }"
  icon="$(get_icon "$app")"
  if [[ -z "${ws_icons[$ws]}" ]]; then
    ws_icons[$ws]="$icon"
  elif [[ ! " ${ws_icons[$ws]} " == *" $icon "* ]]; then
    ws_icons[$ws]+=" $icon"
  fi
done < <(/Users/lev/.config/sketchybar/bin/spatial_windows 2>/dev/null)

echo " ${(k)ws_icons} " > /tmp/sketchybar_occupied_spaces

FOCUSED_WS="${AEROSPACE_FOCUSED_WORKSPACE:-$(/opt/homebrew/bin/aerospace list-workspaces --focused 2>/dev/null)}"
[[ -z "$FOCUSED_WS" ]] && FOCUSED_WS="1"

args=()

for sid in 1 2 3 4 5 6 7 8 9 S; do
  icons="${ws_icons[$sid]:-}"

  if [[ "$sid" == "$FOCUSED_WS" ]]; then
    # Active workspace: High contrast Mauve (#cba6f7) accent border, bright number and icons
    if [[ -n "$icons" ]]; then
      args+=(
        --set "space.$sid"
              drawing=on
              background.drawing=on
              background.color=0xee181825
              background.border_color=0xffcba6f7
              background.border_width=1.5
              icon.color=0xffcba6f7
              icon.padding_left=8
              icon.padding_right=4
              label="$icons"
              label.color=0xffcba6f7
              label.drawing=on
              label.padding_right=8
      )
    else
      args+=(
        --set "space.$sid"
              drawing=on
              background.drawing=on
              background.color=0xee181825
              background.border_color=0xffcba6f7
              background.border_width=1.5
              icon.color=0xffcba6f7
              icon.padding_left=8
              icon.padding_right=8
              label=""
              label.drawing=off
      )
    fi
  elif [[ -n "$icons" ]]; then
    # Inactive workspace with windows: Muted number, dimmed icons (0x55cdd6f4)
    args+=(
      --set "space.$sid"
            drawing=on
            background.drawing=on
            background.color=0xee181825
            background.border_color=0x22ffffff
            background.border_width=1
            icon.color=0x88cdd6f4
            icon.padding_left=8
            icon.padding_right=4
            label="$icons"
            label.color=0x55cdd6f4
            label.drawing=on
            label.padding_right=8
    )
  else
    # Inactive empty workspace: subtle faint marker
    if [[ "$sid" == "S" ]]; then
      args+=(--set "space.$sid" drawing=off)
    else
      args+=(
        --set "space.$sid"
              drawing=on
              background.drawing=off
              background.border_width=0
              icon.color=0x44cdd6f4
              icon.padding_left=6
              icon.padding_right=6
              label=""
              label.drawing=off
      )
    fi
  fi
done

if (( ${#args[@]} > 0 )); then
  /opt/homebrew/bin/sketchybar "${args[@]}"
fi

  if [[ ! -f "$PENDING_FILE" ]]; then
    break
  fi
done

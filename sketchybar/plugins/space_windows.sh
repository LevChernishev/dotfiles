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

FOCUSED_WS="${AEROSPACE_FOCUSED_WORKSPACE:-$(/opt/homebrew/bin/aerospace list-workspaces --focused 2>/dev/null)}"
[[ -z "$FOCUSED_WS" ]] && FOCUSED_WS="1"

FOCUSED_WIN_ID="$(/opt/homebrew/bin/aerospace list-windows --focused --format '%{window-id}' 2>/dev/null)"

typeset -A ws_wids
typeset -A ws_apps

while IFS='|' read -r ws wid app; do
  [[ -z "$ws" || -z "$wid" ]] && continue
  ws="${ws// /}"
  wid="${wid// /}"
  app="${app## }"
  app="${app%% }"
  ws_wids[$ws]+="${wid},"
  ws_apps[$ws]+="${app},"
done < <(/opt/homebrew/bin/aerospace list-windows --all --format '%{workspace}|%{window-id}|%{app-name}' 2>/dev/null)

echo " ${(k)ws_wids} " > /tmp/sketchybar_occupied_spaces

args=()

for sid in 1 2 3 4 5 6 7 8 9 S; do
  wids_raw="${ws_wids[$sid]:-}"
  apps_raw="${ws_apps[$sid]:-}"

  wids=(${(s:,:)wids_raw})
  apps=(${(s:,:)apps_raw})
  count=${#wids[@]}

  if [[ "$sid" == "$FOCUSED_WS" ]]; then
    args+=(
      --set "space.$sid" drawing=on icon.color=0xffcba6f7
      --set "space.$sid.b" background.drawing=on background.color=0xee181825 background.border_color=0xffcba6f7 background.border_width=1.5
    )
  elif (( count > 0 )); then
    args+=(
      --set "space.$sid" drawing=on icon.color=0x88cdd6f4
      --set "space.$sid.b" background.drawing=on background.color=0xee181825 background.border_color=0x22ffffff background.border_width=1
    )
  else
    if [[ "$sid" == "S" ]]; then
      args+=(
        --set "space.$sid" drawing=off
        --set "space.$sid.b" background.drawing=off
      )
    else
      args+=(
        --set "space.$sid" drawing=on icon.color=0x44cdd6f4
        --set "space.$sid.b" background.drawing=off
      )
    fi
  fi

  if (( count == 0 )); then
    args+=(--set "space.$sid" icon.padding_right=8)
  else
    args+=(--set "space.$sid" icon.padding_right=4)
  fi

  for wid_slot in 1 2 3 4; do
    if (( wid_slot <= count )); then
      curr_wid="${wids[$wid_slot]}"
      curr_app="${apps[$wid_slot]}"
      icon="$(get_icon "$curr_app")"

      if [[ -n "$FOCUSED_WIN_ID" && "$curr_wid" == "$FOCUSED_WIN_ID" ]]; then
        color="0xffcba6f7"
      else
        color="0x55cdd6f4"
      fi

      if (( wid_slot == count )); then
        pad_r=8
      else
        pad_r=4
      fi

      args+=(
        --set "space.$sid.w$wid_slot"
              drawing=on
              label="$icon"
              label.color="$color"
              label.padding_right="$pad_r"
      )
    else
      args+=(--set "space.$sid.w$wid_slot" drawing=off)
    fi
  done
done

if (( ${#args[@]} > 0 )); then
  /opt/homebrew/bin/sketchybar "${args[@]}"
fi

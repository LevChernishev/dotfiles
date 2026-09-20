#!/bin/zsh

# Query Spotify tab title in Google Chrome
TITLE=$(osascript -e '
tell application "Google Chrome"
	if not (it is running) then return ""
	repeat with w in windows
		repeat with t in tabs of w
			set u to URL of t
			if u starts with "https://open.spotify.com" then
				set sTitle to title of t
				if sTitle contains " • " then
					return sTitle
				else
					return ""
				end if
			end if
		end repeat
	end repeat
	return ""
end tell
' 2>/dev/null)

if [[ -n "$TITLE" ]]; then
  # Clean title (remove "Spotify - " prefix if present)
  CLEAN="${TITLE#Spotify - }"
  CLEAN="${CLEAN#Spotify – }"
  # Limit length for clean bar appearance
  if (( ${#CLEAN} > 30 )); then
    DISPLAY_TITLE="${CLEAN[1,28]}…"
  else
    DISPLAY_TITLE="$CLEAN"
  fi
  sketchybar --set spotify drawing=on label="$DISPLAY_TITLE"
else
  sketchybar --set spotify drawing=off
fi

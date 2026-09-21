#!/usr/bin/env bash

NAME="${NAME:-clock}"

TODAY=$(date '+%Y-%m-%d')
CACHE_FILE="/tmp/.sketchybar_clock_date"
CACHE_DATE=$(cat "$CACHE_FILE" 2>/dev/null)

if [ "$1" = "update" ] || [ "$TODAY" != "$CACHE_DATE" ]; then
    echo "$TODAY" > "$CACHE_FILE"
    DATE_RU=$(LC_TIME=ru_RU.UTF-8 date '+%A, %d %B %Y' 2>/dev/null)
    if [ -n "$DATE_RU" ]; then
        CAP_DATE="$(tr '[:lower:]' '[:upper:]' <<< "${DATE_RU:0:1}")${DATE_RU:1}"
    else
        CAP_DATE="$(date '+%A, %d %B %Y')"
    fi
    WEEK=$(date '+%-V' 2>/dev/null || date '+%V')
    DOY=$(date '+%-j' 2>/dev/null || date '+%j')
    SUB_TEXT="${WEEK}-я неделя • ${DOY}-й день года"

    sketchybar --set cal.header label="$CAP_DATE" \
               --set cal.sub label="$SUB_TEXT"
    [ "$1" = "update" ] && exit 0
fi

sketchybar --set "$NAME" icon="" label="$(date '+%H:%M')"

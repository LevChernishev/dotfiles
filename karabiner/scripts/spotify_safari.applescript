on run argv
    set action to "playpause"
    if (count of argv) > 0 then
        set action to item 1 of argv
    end if
    
    if application "Safari" is running then
        tell application "Safari"
            repeat with w in windows
                repeat with t in tabs of w
                    if URL of t contains "spotify.com" then
                        try
                            if action is "playpause" then
                                do JavaScript "var b = document.querySelector('[data-testid=control-button-playpause]'); if(b) b.click();" in t
                            else if action is "next" then
                                do JavaScript "var b = document.querySelector('[data-testid=control-button-skip-forward]'); if(b) b.click();" in t
                            else if action is "previous" then
                                do JavaScript "var b = document.querySelector('[data-testid=control-button-skip-back]'); if(b) b.click();" in t
                            end if
                        on error errMsg
                            display notification "Включите в Safari: Меню Разработка -> Разрешить JavaScript из событий Apple" with title "Spotify Media Keys"
                        end try
                        return
                    end if
                end repeat
            end repeat
        end tell
    end if
end run

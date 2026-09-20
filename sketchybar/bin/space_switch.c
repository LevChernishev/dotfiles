#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main(void) {
    char *prev = getenv("AEROSPACE_PREV_WORKSPACE");
    char *curr = getenv("AEROSPACE_FOCUSED_WORKSPACE");
    if (!curr || !curr[0]) return 0;

    char prev_item[64], curr_item[64];
    snprintf(curr_item, sizeof(curr_item), "space.%s", curr);

    if (prev && prev[0] && strcmp(prev, curr) != 0) {
        snprintf(prev_item, sizeof(prev_item), "space.%s", prev);
        char *args[] = {
            "/opt/homebrew/bin/sketchybar",
            "--set", prev_item,
            "background.color=0xee181825",
            "icon.color=0xffcdd6f4",
            "label.color=0xffcdd6f4",
            "background.border_width=1",
            "--set", curr_item,
            "background.color=0xffcba6f7",
            "icon.color=0xff11111b",
            "label.color=0xff11111b",
            "background.border_width=0",
            NULL
        };
        execv(args[0], args);
    } else {
        char *args[] = {
            "/opt/homebrew/bin/sketchybar",
            "--set", curr_item,
            "background.color=0xffcba6f7",
            "icon.color=0xff11111b",
            "label.color=0xff11111b",
            "background.border_width=0",
            NULL
        };
        execv(args[0], args);
    }
    return 0;
}

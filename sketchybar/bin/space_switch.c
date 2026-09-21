#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main(void) {
    char *curr = getenv("AEROSPACE_FOCUSED_WORKSPACE");
    char *prev = getenv("AEROSPACE_PREV_WORKSPACE");
    if (!curr || !curr[0]) return 0;

    char occupied[128] = " 1 2 3 ";
    FILE *f = fopen("/tmp/sketchybar_occupied_spaces", "r");
    if (f) {
        if (fgets(occupied, sizeof(occupied), f) == NULL) {
            strncpy(occupied, " 1 2 3 ", sizeof(occupied));
        }
        fclose(f);
    }

    char prev_token[16];
    int prev_occupied = 0;
    if (prev && prev[0]) {
        snprintf(prev_token, sizeof(prev_token), " %s ", prev);
        if (strstr(occupied, prev_token)) {
            prev_occupied = 1;
        }
    }

    char curr_item[32];
    snprintf(curr_item, sizeof(curr_item), "space.%s", curr);

    if (prev && prev[0] && strcmp(prev, curr) != 0) {
        char prev_item[32];
        snprintf(prev_item, sizeof(prev_item), "space.%s", prev);

        if (strcmp(prev, "S") == 0 && !prev_occupied) {
            char *args[] = {
                "/opt/homebrew/bin/sketchybar",
                "--set", prev_item, "drawing=off",
                "--set", curr_item,
                "drawing=on",
                "background.drawing=on",
                "background.color=0xee181825",
                "background.border_color=0xffcba6f7",
                "background.border_width=1.5",
                "icon.color=0xffcba6f7",
                "label.color=0xffcba6f7",
                NULL
            };
            execv(args[0], args);
        } else if (prev_occupied) {
            char *args[] = {
                "/opt/homebrew/bin/sketchybar",
                "--set", prev_item,
                "background.drawing=on",
                "background.color=0xee181825",
                "background.border_color=0x22ffffff",
                "background.border_width=1",
                "icon.color=0x88cdd6f4",
                "label.color=0x55cdd6f4",
                "--set", curr_item,
                "drawing=on",
                "background.drawing=on",
                "background.color=0xee181825",
                "background.border_color=0xffcba6f7",
                "background.border_width=1.5",
                "icon.color=0xffcba6f7",
                "label.color=0xffcba6f7",
                NULL
            };
            execv(args[0], args);
        } else {
            char *args[] = {
                "/opt/homebrew/bin/sketchybar",
                "--set", prev_item,
                "background.drawing=off",
                "background.border_width=0",
                "icon.color=0x44cdd6f4",
                "--set", curr_item,
                "drawing=on",
                "background.drawing=on",
                "background.color=0xee181825",
                "background.border_color=0xffcba6f7",
                "background.border_width=1.5",
                "icon.color=0xffcba6f7",
                "label.color=0xffcba6f7",
                NULL
            };
            execv(args[0], args);
        }
    } else {
        char *args[] = {
            "/opt/homebrew/bin/sketchybar",
            "--set", curr_item,
            "drawing=on",
            "background.drawing=on",
            "background.color=0xee181825",
            "background.border_color=0xffcba6f7",
            "background.border_width=1.5",
            "icon.color=0xffcba6f7",
            "label.color=0xffcba6f7",
            NULL
        };
        execv(args[0], args);
    }

    return 0;
}

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main(void) {
    char *curr = getenv("AEROSPACE_FOCUSED_WORKSPACE");
    char *prev = getenv("AEROSPACE_PREV_WORKSPACE");
    if (!curr || !curr[0]) return 0;

    // Check which workspaces currently have windows
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

    char curr_item[32], curr_b[32];
    snprintf(curr_item, sizeof(curr_item), "space.%s", curr);
    snprintf(curr_b, sizeof(curr_b), "space.%s.b", curr);

    if (prev && prev[0] && strcmp(prev, curr) != 0) {
        char prev_item[32], prev_b[32];
        snprintf(prev_item, sizeof(prev_item), "space.%s", prev);
        snprintf(prev_b, sizeof(prev_b), "space.%s.b", prev);

        if (strcmp(prev, "S") == 0 && !prev_occupied) {
            char *args[] = {
                "/opt/homebrew/bin/sketchybar",
                "--set", prev_item, "drawing=off",
                "--set", prev_b, "background.drawing=off",
                "--set", curr_item, "drawing=on", "icon.color=0xffcba6f7",
                "--set", curr_b, "background.drawing=on", "background.border_color=0xffcba6f7", "background.border_width=1.5",
                NULL
            };
            execv(args[0], args);
        } else if (prev_occupied) {
            char *args[] = {
                "/opt/homebrew/bin/sketchybar",
                "--set", prev_item, "icon.color=0x88cdd6f4",
                "--set", prev_b, "background.drawing=on", "background.border_color=0x22ffffff", "background.border_width=1",
                "--set", curr_item, "drawing=on", "icon.color=0xffcba6f7",
                "--set", curr_b, "background.drawing=on", "background.border_color=0xffcba6f7", "background.border_width=1.5",
                NULL
            };
            execv(args[0], args);
        } else {
            char *args[] = {
                "/opt/homebrew/bin/sketchybar",
                "--set", prev_item, "icon.color=0x44cdd6f4",
                "--set", prev_b, "background.drawing=off",
                "--set", curr_item, "drawing=on", "icon.color=0xffcba6f7",
                "--set", curr_b, "background.drawing=on", "background.border_color=0xffcba6f7", "background.border_width=1.5",
                NULL
            };
            execv(args[0], args);
        }
    } else {
        char *args[] = {
            "/opt/homebrew/bin/sketchybar",
            "--set", curr_item, "drawing=on", "icon.color=0xffcba6f7",
            "--set", curr_b, "background.drawing=on", "background.border_color=0xffcba6f7", "background.border_width=1.5",
            NULL
        };
        execv(args[0], args);
    }

    return 0;
}

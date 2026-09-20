#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

int main(void) {
    char *curr = getenv("AEROSPACE_FOCUSED_WORKSPACE");
    if (!curr || !curr[0]) return 0;

    char curr_item[64];
    snprintf(curr_item, sizeof(curr_item), "space.%s", curr);

    char *args[] = {
        "/opt/homebrew/bin/sketchybar",
        "--set", "/space\\..*/",
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
    return 0;
}

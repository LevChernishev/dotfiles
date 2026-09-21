#include <CoreGraphics/CoreGraphics.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define MAX_WINS 256
#define CACHE_FILE "/tmp/aerospace_x_cache.txt"

typedef struct {
    int wid;
    float x;
    char app[64];
    char ws[16];
} WinInfo;

typedef struct {
    int wid;
    float x;
} CachedX;

static CachedX g_cache[MAX_WINS];
static int g_cache_count = 0;

static void load_cache(void) {
    FILE *f = fopen(CACHE_FILE, "r");
    if (!f) return;
    int wid; float x;
    while (g_cache_count < MAX_WINS && fscanf(f, "%d %f", &wid, &x) == 2) {
        g_cache[g_cache_count].wid = wid;
        g_cache[g_cache_count].x = x;
        g_cache_count++;
    }
    fclose(f);
}

static void update_cache_x(int wid, float x) {
    for (int i = 0; i < g_cache_count; i++) {
        if (g_cache[i].wid == wid) {
            g_cache[i].x = x;
            return;
        }
    }
    if (g_cache_count < MAX_WINS) {
        g_cache[g_cache_count].wid = wid;
        g_cache[g_cache_count].x = x;
        g_cache_count++;
    }
}

static float get_cached_x(int wid) {
    for (int i = 0; i < g_cache_count; i++) {
        if (g_cache[i].wid == wid) {
            return g_cache[i].x;
        }
    }
    return 0.0f;
}

static void save_cache(void) {
    FILE *f = fopen(CACHE_FILE, "w");
    if (!f) return;
    for (int i = 0; i < g_cache_count; i++) {
        fprintf(f, "%d %.1f\n", g_cache[i].wid, g_cache[i].x);
    }
    fclose(f);
}

static int cmp_win(const void *a, const void *b) {
    const WinInfo *w1 = (const WinInfo *)a;
    const WinInfo *w2 = (const WinInfo *)b;
    int c = strcmp(w1->ws, w2->ws);
    if (c != 0) return c;
    if (w1->x < w2->x) return -1;
    if (w1->x > w2->x) return 1;
    return 0;
}

int main(void) {
    load_cache();

    // 1. Get window list from aerospace. This also provides ~70ms settling time for WindowServer.
    FILE *p = popen("/opt/homebrew/bin/aerospace list-windows --all --format '%{workspace}|%{window-id}|%{app-name}'", "r");
    if (!p) return 1;

    WinInfo wins[MAX_WINS];
    int count = 0;
    char line[256];
    while (fgets(line, sizeof(line), p) && count < MAX_WINS) {
        char *ws = strtok(line, "|\n");
        char *wid_str = strtok(NULL, "|\n");
        char *app = strtok(NULL, "|\n");
        if (ws && wid_str && app) {
            wins[count].wid = atoi(wid_str);
            strncpy(wins[count].ws, ws, sizeof(wins[count].ws) - 1);
            strncpy(wins[count].app, app, sizeof(wins[count].app) - 1);
            count++;
        }
    }
    pclose(p);

    // Short 20ms pause ensuring WindowServer has rendered frame updates after a move
    usleep(20000);

    // 2. Query live onscreen window coordinates
    CGRect main_screen = CGDisplayBounds(CGMainDisplayID());
    float max_x = (main_screen.size.width > 0) ? (main_screen.size.width - 80.0f) : 1900.0f;

    CFArrayRef list = CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly, kCGNullWindowID);
    if (list) {
        CFIndex n = CFArrayGetCount(list);
        for (CFIndex i = 0; i < n; i++) {
            CFDictionaryRef win = (CFDictionaryRef)CFArrayGetValueAtIndex(list, i);
            int layer = 0;
            CFNumberRef num = (CFNumberRef)CFDictionaryGetValue(win, kCGWindowLayer);
            if (num) CFNumberGetValue(num, kCFNumberIntType, &layer);
            if (layer != 0) continue;

            CFDictionaryRef b = (CFDictionaryRef)CFDictionaryGetValue(win, kCGWindowBounds);
            CGRect r;
            if (b && CGRectMakeWithDictionaryRepresentation(b, &r)) {
                if (r.origin.x >= 0 && r.origin.x < max_x && r.size.width > 150) {
                    int wid = 0;
                    num = (CFNumberRef)CFDictionaryGetValue(win, kCGWindowNumber);
                    if (num) CFNumberGetValue(num, kCFNumberIntType, &wid);
                    if (wid > 0) {
                        update_cache_x(wid, r.origin.x);
                    }
                }
            }
        }
        CFRelease(list);
    }

    save_cache();

    for (int i = 0; i < count; i++) {
        wins[i].x = get_cached_x(wins[i].wid);
    }

    qsort(wins, count, sizeof(WinInfo), cmp_win);

    for (int i = 0; i < count; i++) {
        printf("%s|%s\n", wins[i].ws, wins[i].app);
    }
    return 0;
}

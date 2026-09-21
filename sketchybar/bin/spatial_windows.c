#include <CoreGraphics/CoreGraphics.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_WINS 256
#define CACHE_FILE "/tmp/aerospace_x_cache.txt"

typedef struct {
    int wid;
    float x;
    char app[64];
    char ws[16];
} WinInfo;

static float get_cached_x(int wid) {
    FILE *f = fopen(CACHE_FILE, "r");
    if (!f) return 0.0f;
    int id; float x;
    while (fscanf(f, "%d %f", &id, &x) == 2) {
        if (id == wid) {
            fclose(f);
            return x;
        }
    }
    fclose(f);
    return 0.0f;
}

static void save_x_cache(int wid, float x) {
    int ids[MAX_WINS]; float xs[MAX_WINS]; int count = 0;
    FILE *f = fopen(CACHE_FILE, "r");
    int found = 0;
    if (f) {
        while (count < MAX_WINS && fscanf(f, "%d %f", &ids[count], &xs[count]) == 2) {
            if (ids[count] == wid) {
                xs[count] = x;
                found = 1;
            }
            count++;
        }
        fclose(f);
    }
    if (!found && count < MAX_WINS) {
        ids[count] = wid;
        xs[count] = x;
        count++;
    }
    f = fopen(CACHE_FILE, "w");
    if (f) {
        for (int i = 0; i < count; i++) {
            fprintf(f, "%d %.1f\n", ids[i], xs[i]);
        }
        fclose(f);
    }
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
                if (r.origin.x >= 0 && r.origin.x < 1900 && r.size.width > 200) {
                    int wid = 0;
                    num = (CFNumberRef)CFDictionaryGetValue(win, kCGWindowNumber);
                    if (num) CFNumberGetValue(num, kCFNumberIntType, &wid);
                    if (wid > 0) {
                        save_x_cache(wid, r.origin.x);
                    }
                }
            }
        }
        CFRelease(list);
    }

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
            wins[count].x = get_cached_x(wins[count].wid);
            count++;
        }
    }
    pclose(p);

    qsort(wins, count, sizeof(WinInfo), cmp_win);

    for (int i = 0; i < count; i++) {
        printf("%s|%s\n", wins[i].ws, wins[i].app);
    }
    return 0;
}

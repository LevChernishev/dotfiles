#include <Carbon/Carbon.h>
#include <stdio.h>
#include <string.h>
#include <sys/time.h>
#include <sys/file.h>
#include <unistd.h>
#include <fcntl.h>

#define DEBOUNCE_MS 200

int main(int argc, char *argv[]) {
    if (argc > 1 && strcmp(argv[1], "toggle") == 0) {
        int throttle_fd = open("/tmp/.get_layout_throttle", O_RDWR | O_CREAT, 0644);
        if (throttle_fd >= 0) {
            if (flock(throttle_fd, LOCK_EX) == 0) {
                struct timeval last_tv = {0, 0};
                ssize_t n = read(throttle_fd, &last_tv, sizeof(last_tv));
                struct timeval now;
                gettimeofday(&now, NULL);

                if (n == sizeof(last_tv)) {
                    long elapsed_ms = (now.tv_sec - last_tv.tv_sec) * 1000 + (now.tv_usec - last_tv.tv_usec) / 1000;
                    if (elapsed_ms >= 0 && elapsed_ms < DEBOUNCE_MS) {
                        flock(throttle_fd, LOCK_UN);
                        close(throttle_fd);
                        return 0;
                    }
                }

                lseek(throttle_fd, 0, SEEK_SET);
                write(throttle_fd, &now, sizeof(now));
                flock(throttle_fd, LOCK_UN);
            }
            close(throttle_fd);
        }

        TISInputSourceRef currentSource = TISCopyCurrentKeyboardInputSource();
        CFStringRef sourceID = (CFStringRef)TISGetInputSourceProperty(currentSource, kTISPropertyInputSourceID);
        char current[256] = {0};
        if (sourceID) CFStringGetCString(sourceID, current, sizeof(current), kCFStringEncodingUTF8);
        CFRelease(currentSource);

        const void *filterKeys[] = { kTISPropertyInputSourceCategory };
        const void *filterVals[] = { kTISCategoryKeyboardInputSource };
        CFDictionaryRef filterDict = CFDictionaryCreate(NULL, filterKeys, filterVals, 1, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        CFArrayRef sourceList = TISCreateInputSourceList(filterDict, false);
        CFRelease(filterDict);

        CFIndex count = sourceList ? CFArrayGetCount(sourceList) : 0;
        for (CFIndex i = 0; i < count; i++) {
            TISInputSourceRef source = (TISInputSourceRef)CFArrayGetValueAtIndex(sourceList, i);
            CFBooleanRef selectable = (CFBooleanRef)TISGetInputSourceProperty(source, kTISPropertyInputSourceIsSelectCapable);
            if (selectable && CFBooleanGetValue(selectable)) {
                CFStringRef sid = (CFStringRef)TISGetInputSourceProperty(source, kTISPropertyInputSourceID);
                char buf[256] = {0};
                if (sid) CFStringGetCString(sid, buf, sizeof(buf), kCFStringEncodingUTF8);
                if (strstr(current, "Russian") && (strstr(buf, "ABC") || strstr(buf, "US") || strstr(buf, "en"))) {
                    TISSelectInputSource(source);
                    break;
                } else if (!strstr(current, "Russian") && (strstr(buf, "Russian") || strstr(buf, "ru"))) {
                    TISSelectInputSource(source);
                    break;
                }
            }
        }
        if (sourceList) CFRelease(sourceList);
        return 0;
    }

    TISInputSourceRef currentSource = TISCopyCurrentKeyboardInputSource();
    if (!currentSource) { printf("EN\n"); return 0; }
    CFStringRef sourceID = (CFStringRef)TISGetInputSourceProperty(currentSource, kTISPropertyInputSourceID);
    if (sourceID) {
        char buffer[256];
        if (CFStringGetCString(sourceID, buffer, sizeof(buffer), kCFStringEncodingUTF8)) {
            if (strstr(buffer, "Russian") || strstr(buffer, "ru")) {
                printf("RU\n");
            } else {
                printf("EN\n");
            }
        } else {
            printf("EN\n");
        }
    } else {
        printf("EN\n");
    }
    CFRelease(currentSource);
    return 0;
}

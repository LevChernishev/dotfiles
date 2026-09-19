#include <Carbon/Carbon.h>
#include <stdio.h>
#include <string.h>

int main(int argc, char *argv[]) {
    if (argc > 1 && strcmp(argv[1], "toggle") == 0) {
        TISInputSourceRef currentSource = TISCopyCurrentKeyboardInputSource();
        CFStringRef sourceID = (CFStringRef)TISGetInputSourceProperty(currentSource, kTISPropertyInputSourceID);
        char current[256] = {0};
        if (sourceID) CFStringGetCString(sourceID, current, sizeof(current), kCFStringEncodingUTF8);
        CFRelease(currentSource);

        CFArrayRef sourceList = TISCreateInputSourceList(NULL, false);
        CFIndex count = CFArrayGetCount(sourceList);
        for (CFIndex i = 0; i < count; i++) {
            TISInputSourceRef source = (TISInputSourceRef)CFArrayGetValueAtIndex(sourceList, i);
            CFStringRef cat = (CFStringRef)TISGetInputSourceProperty(source, kTISPropertyInputSourceCategory);
            if (cat && CFStringCompare(cat, kTISCategoryKeyboardInputSource, 0) == kCFCompareEqualTo) {
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
        }
        CFRelease(sourceList);
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

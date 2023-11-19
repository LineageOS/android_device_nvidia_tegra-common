#include "rm-wrapper.h"

#include <stdarg.h>
#include <dlfcn.h>
#include <string.h>
#include <math.h>
#include <unistd.h>
#include <android/log.h>

#if (ENABLE_ANDROID_LOGGING == 0)

#define __android_log_print_case(x) \
    case ANDROID_LOG_##x: \
        printf(#x); \
        break;

int __android_log_print(int prio, const char *tag, const char *fmt, ...) {
    if (prio < MINIMUM_LOGGING_LEVEL)
        return -1;
    
    va_list args;
    va_start(args, fmt);
    
    switch (prio) {
    __android_log_print_case(VERBOSE)
    __android_log_print_case(DEBUG)
    __android_log_print_case(INFO)
    __android_log_print_case(WARN)
    __android_log_print_case(ERROR)
    __android_log_print_case(FATAL)
    default:
        printf("???");
    }
    printf("/%s(%d): ", tag, getpid());
    
    // Make sure we don't have extra newlines
    size_t fmt_len = strlen(fmt);
    char* fmt_cpy = malloc(fmt_len);
    strcpy(fmt_cpy, fmt);
    while (fmt_len > 0 && fmt_cpy[fmt_len - 1] == '\n')
        fmt_cpy[--fmt_len] = 0;
    vprintf(fmt_cpy, args);
    
    printf("\n");
    va_end(args);
    return 0;
}

#endif

int (*ts_main_init)();
int (*ts_main_resume)();
int (*ts_main_calc)();

int main() {
    void* dl = dlopen("ts.default.so", RTLD_NOW | RTLD_GLOBAL);
    if (!dl) {
        printf("Failed to load library: %s\n", dlerror());
        return 1;
    }
    
    ts_main_init = dlsym(dl, "ts_main_init");
    if (!ts_main_init) {
        printf("Failed to find ts_main_init: %s\n", dlerror());
        return 1;
    }
    ts_main_resume = dlsym(dl, "ts_main_resume");
    if (!ts_main_resume) {
        printf("Failed to find ts_main_resume: %s\n", dlerror());
        return 1;
    }
    ts_main_calc = dlsym(dl, "ts_main_calc");
    if (!ts_main_calc) {
        printf("Failed to find ts_main_calc: %s\n", dlerror());
        return 1;
    }
    
    ts_main_init();
    ts_main_resume();
    while (1) {
        ts_main_calc();
        sleep(5);
    }
}

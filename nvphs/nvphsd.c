#include <dlfcn.h>
#include <stdio.h>
#include <unistd.h>

int (*phsmain)();

int main() {
    void* dl = dlopen("libnvphsd.so", RTLD_NOW | RTLD_GLOBAL);
    if (!dl) {
        printf("Failed to load library: %s\n", dlerror());
        return 1;
    }

    phsmain = dlsym(dl, "phsmain");
    if (!phsmain) {
        printf("Failed to find phsmain: %s\n", dlerror());
        return 1;
    }

    phsmain();
}

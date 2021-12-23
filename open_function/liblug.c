#define _GNU_SOURCE
#include <dlfcn.h>

typedef int (*orig_open_f_type)(const char *pathname, int flags);

int open(const char *pathname, int flags, ...) {
  printf("Just tried to open %s\n", pathname);

  orig_open_f_type orig_open;
  orig_open = (orig_open_f_type)dlsym(RTLD_NEXT,"open");
  return orig_open(pathname,flags);
}

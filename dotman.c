#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <unistd.h>
#include <sys/stat.h>

// ================= CONFIG =================

typedef struct {
    const char* home;
    const char* dotfiles_dir;
    const char* os;   // "linux" | "macos"
} Config;

Config config = {0};

// ================= MANIFEST =================

typedef enum {
    TOOL_LINK,
    TOOL_GIT
} ToolType;

typedef struct {
    char name[64];
    char target[PATH_MAX];
    char source[PATH_MAX];
    char os[16];
    ToolType type;
} Entry;

#define MAX_ENTRIES 256

// ================= OS DETECTION =================

const char* detect_os() {
    static char buf[64];

    FILE* f = popen("uname -s", "r");
    if (!f) return "unknown";

    if (fgets(buf, sizeof(buf), f)) {
        buf[strcspn(buf, "\n")] = 0;
    }
    pclose(f);

    if (strcmp(buf, "Darwin") == 0) return "macos";
    if (strcmp(buf, "Linux") == 0) return "linux";

    return "unknown";
}

// ================= UTILS =================

void mkdir_p(const char* path) {
    char tmp[PATH_MAX];
    snprintf(tmp, sizeof(tmp), "%s", path);

    for (char* p = tmp + 1; *p; p++) {
        if (*p == '/') {
            *p = 0;
            mkdir(tmp, 0755);
            *p = '/';
        }
    }
    mkdir(tmp, 0755);
}

void ensure_parent(const char* path) {
    char tmp[PATH_MAX];
    snprintf(tmp, sizeof(tmp), "%s", path);

    char* slash = strrchr(tmp, '/');
    if (slash) {
        *slash = '\0';
        mkdir_p(tmp);
    }
}

// ================= OPS =================

void do_link(Entry* e) {
    char target[PATH_MAX];
    char source[PATH_MAX];

    snprintf(target, sizeof(target), "%s/%s", config.home, e->target);
    snprintf(source, sizeof(source), "%s/%s", config.dotfiles_dir, e->source);

    struct stat st;
    if (lstat(target, &st) == 0) {
        printf("update %s\n", e->name);
        char cmd[PATH_MAX + 32];
        snprintf(cmd, sizeof(cmd), "rm -rf \"%s\"", target);
        system(cmd);
    } else {
        printf("link %s\n", e->name);
    }

    ensure_parent(target);
    symlink(source, target);
}

void do_git(Entry* e) {
    char target[PATH_MAX];
    snprintf(target, sizeof(target), "%s/%s", config.home, e->target);

    struct stat st;
    if (stat(target, &st) == 0) {
        printf("update %s\n", e->name);

        char cmd[PATH_MAX + 128];
        snprintf(cmd, sizeof(cmd),
                 "git -C \"%s\" pull --quiet", target);
        system(cmd);
    } else {
        printf("clone %s\n", e->name);

        ensure_parent(target);

        char cmd[PATH_MAX + 256];
        snprintf(cmd, sizeof(cmd),
                 "git clone --depth=1 \"%s\" \"%s\"",
                 e->source, target);
        system(cmd);
    }
}

// ================= MANIFEST =================

int load_manifest(const char* path, Entry* entries) {
    FILE* f = fopen(path, "r");
    if (!f) {
        perror("Manifest");
        return 0;
    }

    char line[1024];
    int count = 0;

    while (fgets(line, sizeof(line), f)) {
        if (line[0] == '#' || line[0] == '\n') continue;

        char* name   = strtok(line, "|");
        char* target = strtok(NULL, "|");
        char* source = strtok(NULL, "|");
        char* type   = strtok(NULL, "|");
        char* os     = strtok(NULL, "|\n");

        if (!name || !target || !source || !type) continue;

        Entry* e = &entries[count++];

        strncpy(e->name, name, sizeof(e->name));
        strncpy(e->target, target, sizeof(e->target));
        strncpy(e->source, source, sizeof(e->source));

        e->type = (strcmp(type, "git") == 0) ? TOOL_GIT : TOOL_LINK;

        if (os) {
            strncpy(e->os, os, sizeof(e->os));
        } else {
            strcpy(e->os, "all");
        }
    }

    fclose(f);
    return count;
}

// ================= FILTER =================

int should_run(Entry* e) {
    if (strcmp(e->os, "all") == 0) return 1;
    return strcmp(e->os, config.os) == 0;
}

// ================= EXEC =================

void run_entry(Entry* e) {
    if (!should_run(e)) return;

    if (e->type == TOOL_LINK) {
        do_link(e);
    } else {
        do_git(e);
    }
}

void run_all(Entry* entries, int count) {
    for (int i = 0; i < count; i++) {
        run_entry(&entries[i]);
    }
}

void run_selected(Entry* entries, int count, int argc, char** argv) {
    for (int a = 0; a < argc; a++) {
        const char* name = argv[a];
        int found = 0;

        for (int i = 0; i < count; i++) {
            if (strcmp(entries[i].name, name) == 0) {
                found = 1;
                if (should_run(&entries[i])) {
                    run_entry(&entries[i]);
                } else {
                    printf("skip %s (os mismatch)\n", name);
                }
                break;
            }
        }

        if (!found) {
            printf("not found: %s\n", name);
        }
    }
}

// ================= MAIN =================

int main(int argc, char** argv) {
    config.home = getenv("HOME");
    config.os = detect_os();

    static char dotfiles[PATH_MAX];
    snprintf(dotfiles, sizeof(dotfiles), "%s/workspace/dotfiles", config.home);
    config.dotfiles_dir = dotfiles;

    Entry entries[MAX_ENTRIES];
    int count = load_manifest("Manifest", entries);

    if (count == 0) {
        printf("empty manifest\n");
        return 1;
    }

    if (argc == 1) {
        run_all(entries, count);
    } else {
        run_selected(entries, count, argc - 1, argv + 1);
    }

    return 0;
}

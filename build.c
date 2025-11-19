#define SHL_IMPLEMENTATION
#define SHL_STRIP_PREFIX
#include "./build.h"

#include <unistd.h>
#include <limits.h>

// Configuration
typedef struct {
    const char* os;
    const char* distro;
    const char* platform;
    const char* dotfiles_dir;
    const char* home;
    bool dry_run;
} Config;

// Colors
#define YELLOW "\033[0;33m"
#define GREEN  "\033[0;32m"
#define RED    "\033[0;31m"
#define BLUE   "\033[0;34m"
#define CYAN   "\033[0;36m"
#define MAGENTA "\033[0;35m"
#define BOLD   "\033[1m"
#define DIM    "\033[2m"
#define NC     "\033[0m"

Config config = {0};

void detect_platform() {
    config.home = getenv("HOME");
    
    Cmd cmd_os = {0};
    push(&cmd_os, "uname", "-s");
    FILE* pipe_os = popen("uname -s", "r");
    if (pipe_os) {
        static char os_buf[256];
        if (fgets(os_buf, sizeof(os_buf), pipe_os)) {
            os_buf[strcspn(os_buf, "\n")] = 0;
            config.os = os_buf;
        }
        pclose(pipe_os);
    }
    
    if (strcmp(config.os, "Linux") == 0) {
        FILE* os_release = popen(". /etc/os-release 2>/dev/null && echo $ID", "r");
        if (os_release) {
            static char distro_buf[256];
            if (fgets(distro_buf, sizeof(distro_buf), os_release)) {
                distro_buf[strcspn(distro_buf, "\n")] = 0;
                config.distro = distro_buf;
            }
            pclose(os_release);
        }
        
        if (strcmp(config.distro, "fedora") == 0) {
            config.platform = "fedora";
            static char dotfiles_linux[PATH_MAX];
            snprintf(dotfiles_linux, sizeof(dotfiles_linux), "%s/dev/code/dotfiles", config.home);
            config.dotfiles_dir = dotfiles_linux;
        } else {
            config.platform = "unsupported";
            static char dotfiles_default[PATH_MAX];
            snprintf(dotfiles_default, sizeof(dotfiles_default), "%s/dotfiles", config.home);
            config.dotfiles_dir = dotfiles_default;
        }
    } else if (strcmp(config.os, "Darwin") == 0) {
        config.platform = "mac";
        static char dotfiles_mac[PATH_MAX];
        snprintf(dotfiles_mac, sizeof(dotfiles_mac), "%s/Projects/dotfiles", config.home);
        config.dotfiles_dir = dotfiles_mac;
    } else {
        config.platform = "unsupported";
        static char dotfiles_default[PATH_MAX];
        snprintf(dotfiles_default, sizeof(dotfiles_default), "%s/dotfiles", config.home);
        config.dotfiles_dir = dotfiles_default;
    }
}

void print_header(const char* text) {
    // int len = strlen(text);
    // printf("\n" BOLD CYAN "╭");
    // for (int i = 0; i < len + 2; i++) printf("─");
    printf(BOLD CYAN "\n%s\n\n"NC, text);
    // printf("╮\n│ %s   │\n╰", text);
    // for (int i = 0; i < len + 2; i++) printf("─");
    // printf("╯" NC "\n\n");
}

void pretty_print(const char* name, const char* status) {
    int name_length = strlen(name);
    int width = 35 - name_length;
    if (width < 0) width = 0;
    
    printf("  " BOLD "%s" NC " ", name);
    printf(DIM);
    for (int i = 0; i < width; i++) {
        printf("·");
    }
    printf(NC " %s\n", status);
}

bool check_dotfiles() {
    struct stat st;
    if (stat(config.dotfiles_dir, &st) != 0) {
        printf("[ERROR] dotfiles directory not found: %s\n", config.dotfiles_dir);
        return false;
    }
    return true;
}

char* get_real_path(const char* path) {
    static char resolved[PATH_MAX];
    if (realpath(path, resolved) == NULL) {
        return NULL;
    }
    return resolved;
}

char* get_symlink_target(const char* path) {
    static char target[PATH_MAX];
    ssize_t len = readlink(path, target, sizeof(target) - 1);
    if (len < 0) {
        return NULL;
    }
    target[len] = '\0';
    return target;
}

void do_symlink(const char* name, const char* target_rel, const char* source_rel) {
    if (!check_dotfiles()) return;
    
    static char target_full[PATH_MAX];
    static char source_full[PATH_MAX];
    snprintf(target_full, sizeof(target_full), "%s/%s", config.home, target_rel);
    snprintf(source_full, sizeof(source_full), "%s/%s", config.dotfiles_dir, source_rel);
    
    char* source_real = get_real_path(source_full);
    if (!source_real) {
        pretty_print(name, RED "✗ missing" NC);
        return;
    }
    
    struct stat st;
    bool target_exists = (lstat(target_full, &st) == 0);
    bool is_symlink = target_exists && S_ISLNK(st.st_mode);
    
    if (is_symlink) {
        char* link_target = get_symlink_target(target_full);
        if (link_target) {
            char* link_real = get_real_path(link_target);
            if (link_real && strcmp(link_real, source_real) == 0) {
                pretty_print(name, GREEN "✓ linked" NC);
                return;
            }
        }
    }
    
    if (target_exists || is_symlink) {
        pretty_print(name, YELLOW "↻ updating" NC);
        if (!config.dry_run) {
            Cmd rm = {0};
            push(&rm, "rm", "-rf", target_full);
            run_always(&rm);
            
            char* target_dir = strdup(target_full);
            char* last_slash = strrchr(target_dir, '/');
            if (last_slash) {
                *last_slash = '\0';
                mkdir_if_not_exists(target_dir);
            }
            free(target_dir);
            
            symlink(source_full, target_full);
        }
    } else {
        pretty_print(name, CYAN "✚ linking" NC);
        if (!config.dry_run) {
            char* target_dir = strdup(target_full);
            char* last_slash = strrchr(target_dir, '/');
            if (last_slash) {
                *last_slash = '\0';
                mkdir_if_not_exists(target_dir);
            }
            free(target_dir);
            
            symlink(source_full, target_full);
        }
    }
}

void do_git_clone(const char* name, const char* target_rel, const char* repo_url) {
    if (!check_dotfiles()) return;
    
    static char target_full[PATH_MAX];
    snprintf(target_full, sizeof(target_full), "%s/%s", config.home, target_rel);
    
    static char git_dir[PATH_MAX];
    snprintf(git_dir, sizeof(git_dir), "%s/.git", target_full);
    
    struct stat st;
    bool git_exists = (stat(git_dir, &st) == 0);
    bool target_exists = (stat(target_full, &st) == 0);
    
    if (git_exists) {
        pretty_print(name, BLUE "↻ updating" NC);
        if (!config.dry_run) {
            Cmd pull = {0};
            push(&pull, "git", "-C", target_full, "pull", "--quiet");
            if (!run_always(&pull)) {
                pretty_print(name, RED "✗ update failed" NC);
            }
        }
    } else if (target_exists) {
        pretty_print(name, YELLOW "⚠ cleaning" NC);
        if (!config.dry_run) {
            Cmd rm = {0};
            push(&rm, "rm", "-rf", target_full);
            run_always(&rm);
            
            char* target_dir = strdup(target_full);
            char* last_slash = strrchr(target_dir, '/');
            if (last_slash) {
                *last_slash = '\0';
                mkdir_if_not_exists(target_dir);
            }
            free(target_dir);
            
            Cmd clone = {0};
            push(&clone, "git", "clone", "--quiet", "--depth=1", repo_url, target_full);
            if (!run_always(&clone)) {
                pretty_print(name, RED "✗ clone failed" NC);
            } else {
                pretty_print(name, GREEN "✓ cloned" NC);
            }
        }
    } else {
        pretty_print(name, CYAN "⬇ cloning" NC);
        if (!config.dry_run) {
            char* target_dir = strdup(target_full);
            char* last_slash = strrchr(target_dir, '/');
            if (last_slash) {
                *last_slash = '\0';
                mkdir_if_not_exists(target_dir);
            }
            free(target_dir);
            
            Cmd clone = {0};
            push(&clone, "git", "clone", "--quiet", "--depth=1", repo_url, target_full);
            if (!run_always(&clone)) {
                pretty_print(name, RED "✗ clone failed" NC);
            }
        }
    }
}

void setup_i3wm() {
    do_symlink("i3wm", ".config/i3/config", "i3wm/i3/config");
    do_symlink("i3wm status", ".config/i3status/config", "i3wm/i3status/config");
}

void setup_polybar() {
    do_symlink("polybar", ".config/polybar/config.ini", "polybar/config.ini");
    do_symlink("polybar launcher", ".config/polybar/launch.sh", "polybar/launch.sh");
}

void setup_bspwm() {
    setup_polybar();
    do_symlink("bspwm", ".config/bspwm/bspwmrc", "bspwm/bspwmrc");
    do_symlink("sxhkd", ".config/sxhkd/sxhkdrc", "sxhkd/sxhkdrc");
}

void setup_xterm() {
    do_symlink("xterm", ".Xresources", "xterm/.Xresources");
}

void setup_ghostty() {
    if (strcmp(config.platform, "fedora") == 0) {
        do_symlink("ghostty", ".config/ghostty/config", "ghostty/config_linux");
    } else if (strcmp(config.platform, "mac") == 0) {
        do_symlink("ghostty", ".config/ghostty/config", "ghostty/config_macos");
    } else {
        printf("unsupported platform\n");
    }
}

void setup_vim() {
    do_symlink("vim", ".vimrc", "vim/.vimrc");
}

void setup_zsh() {
    if (strcmp(config.platform, "mac") == 0) {
        do_symlink("zsh", ".zshrc", "zsh/.zshrc.mac");
    } else {
        do_symlink("zsh", ".zshrc", "zsh/.zshrc");
    }
    do_symlink("zsh plugins", ".oh-my-zsh/plugins/", "zsh/plugins");
}

void setup_bash() {
    do_symlink("bash", ".bashrc", "bash/.bashrc");
}

void setup_tmux() {
    do_symlink("tmux", ".tmux.conf", "tmux/.tmux.conf");
}

void setup_emacs() {
    do_git_clone("emacs", ".emacs.d", "https://github.com/RaphaeleL/.emacs.d");
}

void setup_nvim() {
    do_git_clone("nvim", ".config/nvim", "https://github.com/RaphaeleL/nvim");
}

void setup_lazygit() {
    do_symlink("lazygit", ".config/lazygit/config.yml", "lazygit/config.yml");
}

void install_fedora() {
    print_header("📦 Installing Packages (DNF)");
    if (!config.dry_run) {
        printf("  " DIM "→ Enabling ghostty COPR..." NC "\n");
        Cmd copr = {0};
        push(&copr, "sudo", "dnf", "copr", "enable", "pgdev/ghostty", "-y", ">/tmp/dotfiles-install.log", "2>&1");
        bool copr_ok = run_always(&copr);
        if (!copr_ok) {
            printf("  " YELLOW "  ⚠ COPR might already be enabled (continuing...)" NC "\n");
        }
        
        printf("  " DIM "→ Installing packages..." NC "\n");
        Cmd install = {0};
        push(&install, "sudo", "dnf", "install", "zsh", "tmux", "i3", "bspwm", 
             "sxhkd", "zig", "git", "lazygit", "ghostty", "-y", ">>/tmp/dotfiles-install.log", "2>&1");
        bool install_ok = run_always(&install);
        if (!install_ok) {
            printf("  " YELLOW "  ⚠ Some packages might already be installed (continuing...)" NC "\n");
        }
        
        printf("  " DIM "→ Checking Oh My Zsh..." NC "\n");
        char omz_path[PATH_MAX];
        snprintf(omz_path, sizeof(omz_path), "%s/.oh-my-zsh", config.home);
        if (access(omz_path, F_OK) == 0) {
            printf("  " GREEN "  ✓ Oh My Zsh already installed" NC "\n");
        } else {
            printf("  " DIM "  → Installing Oh My Zsh..." NC "\n");
            Cmd omz = {0};
            push(&omz, "sh", "-c", 
                 "\"RUNZSH=no CHSH=no $(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\"", 
                 ">>/tmp/dotfiles-install.log", "2>&1");
            run_always(&omz);
        }
        printf("\n");
    } else {
        printf("  " DIM "→ Would enable ghostty COPR" NC "\n");
        printf("  " DIM "→ Would install: zsh, tmux, i3, bspwm, sxhkd, zig, git, lazygit, ghostty" NC "\n");
        printf("  " DIM "→ Would install Oh My Zsh" NC "\n\n");
    }
}

void install_mac() {
    print_header("🍺 Installing Packages (Homebrew)");
    if (!config.dry_run) {
        printf("  " DIM "→ Installing cask packages..." NC "\n");
        Cmd cask = {0};
        push(&cask, "brew", "install", "--quiet", "--cask", "ghostty", ">/tmp/dotfiles-install.log", "2>&1");
        bool cask_ok = run_always(&cask);
        if (!cask_ok) {
            printf("  " YELLOW "  ⚠ Ghostty might already be installed (continuing...)" NC "\n");
        }
        
        printf("  " DIM "→ Installing packages..." NC "\n");
        Cmd install = {0};
        push(&install, "brew", "install", "--quiet", "zsh", "tmux", "zig", "git", "lazygit", ">>/tmp/dotfiles-install.log", "2>&1");
        bool install_ok = run_always(&install);
        if (!install_ok) {
            printf("  " YELLOW "  ⚠ Some packages might already be installed (continuing...)" NC "\n");
        }
        
        printf("  " DIM "→ Checking Oh My Zsh..." NC "\n");
        static char omz_path[PATH_MAX];
        snprintf(omz_path, sizeof(omz_path), "%s/.oh-my-zsh", config.home);
        if (access(omz_path, F_OK) == 0) {
            printf("  " GREEN "  ✓ Oh My Zsh already installed" NC "\n");
        } else {
            printf("  " DIM "  → Installing Oh My Zsh..." NC "\n");
            Cmd omz = {0};
            push(&omz, "sh", "-c", 
                 "\"RUNZSH=no CHSH=no $(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\"",
                 ">>/tmp/dotfiles-install.log", "2>&1");
            run_always(&omz);
        }
        printf("\n");
    } else {
        printf("  " DIM "→ Would install cask: ghostty" NC "\n");
        printf("  " DIM "→ Would install: zsh, tmux, zig, git, lazygit" NC "\n");
        printf("  " DIM "→ Would install Oh My Zsh" NC "\n\n");
    }
}

void setup_fedora() {
    install_fedora();
    
    print_header("🔧 Setting Up Configurations");
    setup_nvim();
    setup_emacs();
    setup_tmux();
    setup_zsh();
    setup_i3wm();
    setup_bspwm();
    setup_ghostty();
    setup_vim();
    setup_xterm();
    setup_lazygit();
    
    printf("\n" BOLD GREEN "✓ Setup complete!" NC "\n\n");
}

void setup_mac() {
    install_mac();
    
    print_header("🔧 Setting Up Configurations");
    setup_nvim();
    setup_emacs();
    setup_tmux();
    setup_zsh();
    setup_ghostty();
    setup_vim();
    setup_lazygit();
    
    printf("\n" BOLD GREEN "✓ Setup complete!" NC "\n\n");
}

void print_help() {
    printf("\n");
    printf(BOLD CYAN "Dotfiles Manager" NC " - Automated configuration deployment\n\n");
    
    printf(BOLD "Usage:" NC "\n");
    printf("  ./build [--dry-run] <command>\n\n");
    
    printf(BOLD "Commands:" NC "\n");
    printf("  " BOLD "auto" NC "       Install and setup everything based on the OS\n");
    printf("  " BOLD "fedora" NC "     Setup for GNU/Linux Fedora\n");
    printf("  " BOLD "mac" NC "        Setup for macOS\n");
    printf("  " BOLD "support" NC "    Check if the OS is supported\n");
    printf("  " BOLD "status" NC "     Check current configuration status\n");
    printf("  " BOLD "tools" NC "      List available tools\n");
    printf("  " BOLD "help" NC "       Show this help message\n\n");
    
    printf(BOLD "Individual Tools:" NC "\n");
    printf("  i3wm, bspwm, polybar, xterm, ghostty, vim, zsh, bash\n");
    printf("  tmux, emacs, nvim, lazygit\n\n");
    
    printf(BOLD "Options:" NC "\n");
    printf("  " BOLD "--dry-run" NC "  Preview changes without modifying files\n\n");
    
    printf(BOLD "Examples:" NC "\n");
    printf("  ./build --dry-run auto   " DIM "# Test full setup" NC "\n");
    printf("  ./build mac              " DIM "# Install on macOS" NC "\n");
    printf("  ./build nvim             " DIM "# Setup only Neovim" NC "\n\n");
}

void print_tools() {
    print_header("🛠 Available Tools");
    
    printf(BOLD "Window Managers:" NC "\n");
    printf("  • i3wm       i3 window manager and i3status\n");
    printf("  • bspwm      BSPWM window manager with sxhkd\n");
    printf("  • polybar    Polybar status bar\n\n");
    
    printf(BOLD "Terminals:" NC "\n");
    printf("  • xterm      XTerm terminal configuration\n");
    printf("  • ghostty    Ghostty terminal emulator\n\n");
    
    printf(BOLD "Editors:" NC "\n");
    printf("  • vim        Vim configuration\n");
    printf("  • nvim       Neovim configuration (git)\n");
    printf("  • emacs      Emacs configuration (git)\n\n");
    
    printf(BOLD "Shells:" NC "\n");
    printf("  • zsh        Zsh shell configuration\n");
    printf("  • bash       Bash shell configuration\n\n");
    
    printf(BOLD "Tools:" NC "\n");
    printf("  • tmux       Tmux configuration\n");
    printf("  • lazygit    Lazygit configuration\n\n");
    
    printf(DIM "Use './build <tool_name>' to setup a specific tool\n" NC);
    printf("\n");
}

void print_status() {
    print_header("📊 Configuration Status");
    
    printf(BOLD "System:" NC "\n");
    printf("  OS:          %s\n", config.os);
    printf("  Platform:    %s\n", config.platform);
    printf("  Dotfiles:    %s\n", config.dotfiles_dir);
    printf("  Home:        %s\n\n", config.home);
    
    printf(BOLD "Configurations:" NC "\n");
    setup_nvim();
    setup_emacs();
    setup_tmux();
    setup_zsh();
    setup_ghostty();
    setup_vim();
    setup_lazygit();
    
    if (strcmp(config.platform, "fedora") == 0) {
        setup_i3wm();
        setup_bspwm();
        setup_xterm();
    }
    printf("\n");
}

void check_support() {
    print_header("🔍 Platform Support");
    
    if (strcmp(config.platform, "unsupported") == 0) {
        printf("  Platform:    " RED "✗ Not supported" NC "\n");
        printf("  OS:          %s\n", config.os);
        if (config.distro && strlen(config.distro) > 0) {
            printf("  Distro:      %s\n", config.distro);
        }
        printf("\n  Supported platforms: Fedora, macOS\n\n");
    } else {
        printf("  Platform:    " GREEN "✓ Supported" NC "\n");
        printf("  Detected:    %s (%s)\n", config.platform, config.os);
        printf("  Dotfiles:    %s\n\n", config.dotfiles_dir);
    }
}

int main(int argc_orig, char** argv_orig) {
    init_logger(LOG_ERROR, false, true);
    auto_rebuild_plus(__FILE__, "build.h");
    
    detect_platform();
    
    int argc = argc_orig;
    char** argv = argv_orig;
    
    shift(argc, argv); // skip program name
    
    if (argc == 0) {
        print_help();
        return EXIT_SUCCESS;
    }
    
    char* cmd = shift(argc, argv);
    
    if (strcmp(cmd, "--dry-run") == 0) {
        config.dry_run = true;
        printf(YELLOW "⚠ DRY-RUN MODE - No files will be modified\n" NC);
        if (argc > 0) {
            cmd = shift(argc, argv);
        } else {
            cmd = "auto";
        }
    }
    
    if (strcmp(cmd, "help") == 0 || strcmp(cmd, "--help") == 0 || strcmp(cmd, "-h") == 0) {
        print_help();
    } else if (strcmp(cmd, "tools") == 0) {
        print_tools();
    } else if (strcmp(cmd, "status") == 0) {
        print_status();
    } else if (strcmp(cmd, "support") == 0) {
        check_support();
    } else if (strcmp(cmd, "auto") == 0) {
        if (strcmp(config.platform, "fedora") == 0) {
            setup_fedora();
        } else if (strcmp(config.platform, "mac") == 0) {
            setup_mac();
        } else {
            printf("Your Platform is not supported yet.\n");
            return EXIT_FAILURE;
        }
    } else if (strcmp(cmd, "fedora") == 0) {
        setup_fedora();
    } else if (strcmp(cmd, "mac") == 0) {
        setup_mac();
    } else if (strcmp(cmd, "i3wm") == 0) {
        setup_i3wm();
    } else if (strcmp(cmd, "bspwm") == 0) {
        setup_bspwm();
    } else if (strcmp(cmd, "polybar") == 0) {
        setup_polybar();
    } else if (strcmp(cmd, "xterm") == 0) {
        setup_xterm();
    } else if (strcmp(cmd, "ghostty") == 0) {
        setup_ghostty();
    } else if (strcmp(cmd, "vim") == 0) {
        setup_vim();
    } else if (strcmp(cmd, "zsh") == 0) {
        setup_zsh();
    } else if (strcmp(cmd, "bash") == 0) {
        setup_bash();
    } else if (strcmp(cmd, "tmux") == 0) {
        setup_tmux();
    } else if (strcmp(cmd, "emacs") == 0) {
        setup_emacs();
    } else if (strcmp(cmd, "nvim") == 0) {
        setup_nvim();
    } else if (strcmp(cmd, "lazygit") == 0) {
        setup_lazygit();
    } else {
        printf("Unknown command: %s\n", cmd);
        print_help();
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}

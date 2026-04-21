# --- PROFILE ---

export PATH="$HOME/.local/bin/:$PATH";
export EDITOR='nvim'

# --- THEME ---

use_omz() {
    # this function decides whether to use an Oh My Zsh based settings or stay in a 
    # rather Plain and basic version of it. 

    local PLAIN=1
    local FANCY=0

    [ -n "$SSH_CONNECTION" ] && return $PLAIN
    [ -n "$TMUX" ] && return $PLAIN

    case "$TERM_PROGRAM" in
        iTerm.app) return $FANCY ;;
        Apple_Terminal) return $PLAIN ;;
        ghostty) return $FANCY ;;
        vscode) return $PLAIN ;;
    esac

    case "$TERM" in
        linux) return $PLAIN ;;
        xterm*|screen*|tmux*) return $FANCY ;;
    esac

    # we haven't returned out yet, thereby it must be a different terminal then above,
    # and thereby we are making it os depending.
    case "$(uname)" in
        Darwin) # macos -> depending on the current dark/light mode
            defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q Dark
            return $?
            ;;
        Linux) # linux -> default to fancy 
            return $FANCY
            ;;
    esac

    # still havn't returned out yet, so the default is plain 
    return $PLAIN
}

if use_omz; then
    export ZSH="$HOME/.oh-my-zsh"
    export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST
    (( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
    ZSH_HIGHLIGHT_STYLES[path]=none
    ZSH_HIGHLIGHT_STYLES[path_prefix]=none
    ZSH_THEME="robbyrussell"
    plugins=()
    source $ZSH/oh-my-zsh.sh
    autoload -U add-zsh-hook
    add-zsh-hook precmd load_syntax_highlighting
    load_syntax_highlighting() {
        source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        add-zsh-hook -d precmd load_syntax_highlighting
    }
    alias ls="eza -F"
    alias ll="eza -AF -ali"
else
    # export PS1="%n@%m %1~ %# " # default prompt
    export PS1='%~> '
    alias ls="ls -FG --color=never"
    alias ll="ls -AFGh -ali --color=never"
fi

# --- ALIAS ---

alias icloud='cd "/Users/raphaele/Library/Mobile Documents/com~apple~CloudDocs/"'
alias grep='grep --color=always'
alias path='echo "$PATH" | tr ":" "\n"' # Pretty Print the Path
alias sizes="du -sh ./* | sort" # get the sizes
alias remove="shred -f -n 512 --remove -x -z" # absolutely remove it (not reliable on modern filesystems (APFS, SSDs))
alias tmp='cd "$(mktemp -d)"' # Quick temp dir
alias back='cd -' # quick go to last dir
alias w='watch -t -n 1' # quick watch
mkcd() { [ -n "$1" ] && mkdir -p "$1" && cd "$1" } # Create and Jump a Dir
hist() { history | grep -i "$1" } # Grep the History
ff() { find . -type f -iname "*$1*" 2>/dev/null } # Faster Find File
fd() { find . -type d -iname "*$1*" 2>/dev/null } # Faster Find Dir
up() { cd "$(printf '../%.0s' $(seq 1 ${1:-1}))"; } # Faster Dir Up's
backup() { cp -r "$1" "$1.bak.$(date +%s)" } # Quick backup
port(){ lsof -i :"$1" } # used port

pk () { pgrep -if -- "$1" | grep -v grep | awk '{print $1}' | xargs kill -9 } # Kill Process
p () { pgrep -if -- "$1" | grep -v grep } # List Process

em() { emacs "$@" >/dev/null 2>&1 &; disown } # GUI Emacs
emd() { emacsclient -c "$@" >/dev/null 2>&1 &; disown } # GUI Emacs with Daemon
emt() { emacs "$@" -nw } # TTY Emacs
emdt() { emacsclient -c --nw "$@" } # TTY Emacs with Daemon
emdaemon() { emacs --daemon >/dev/null 2>&1 & disown } # Start Emacs Daemon

compress() { tar -czf "$1.tar.gz" "$1" }
extract () {
    [ -f "$1" ] || { echo "file not found"; return 1; }
    case $1 in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz)  tar xzf "$1" ;;
        *.bz2)     bunzip2 "$1" ;;
        *.rar)     unrar x "$1" ;;
        *.gz)      gunzip "$1" ;;
        *.tar)     tar xf "$1" ;;
        *.tbz2)    tar xjf "$1" ;;
        *.tgz)     tar xzf "$1" ;;
        *.zip)     unzip "$1" ;;
        *.Z)       uncompress "$1" ;;
        *.7z)      7z x "$1" ;;
        *) echo "cannot extract '$1'" ;;
    esac
}

prep() {
    local session=$1

    tmux rename-window -t "$session:1" dev

    tmux new-window -t "$session:" -n build
    tmux new-window -t "$session:" -n test -c "test"
    tmux new-window -t "$session:" -n git
    tmux new-window -t "$session:" -n ssh
    tmux new-window -t "$session:" -n log

    # TODO: still not working as i wish
    # tmux send-keys -t "$session:build.0" 'make all -B -j' C-m
    # tmux send-keys -t "$session:test.0" 'make all -B -j' C-m
    # tmux send-keys -t "$session:git.0" 'git status' C-m

}

fh() {
    local cmd
    cmd=$(fc -lnr 1 | sed 's/^[[:space:]]*//' | fzf --height 40% --border --tac --no-mouse --no-info)
    [[ -n $cmd ]] && LBUFFER+="$cmd"
    zle redisplay
}

# --- KEYBINDINGS ---

zle -N fh                     # Register the shell function `fh` as a ZLE (Zsh Line Editor) widget so it can be bound to keys.
bindkey -e                    # Enable Emacs-style keybindings in Zsh (e.g., Ctrl-A, Ctrl-E, Ctrl-R behavior).
bindkey "^R" fh               # Bind Ctrl-R to the custom ZLE widget `fh` (overrides the default history search).
bindkey -s ^o "tms\n"         # Bind Ctrl-O to send the literal string "tms" followed by Enter (runs the `tms` command).
bindkey -s ^h "fsv_connect\n" # Bind Ctrl-H to send the string "fsv_connect" followed by Enter (runs that command).

# --- OS Specific ---

[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# --- HISTORY ---

ulimit -n 8192                 # Increase file descriptor limit
HISTSIZE=100000                # Number of commands kept in memory
SAVEHIST=100000                # Number of commands saved to the history file
HISTFILE=~/.zsh_history        # History file location (optional, this is the default)
setopt APPEND_HISTORY          # Append instead of overwrite
setopt INC_APPEND_HISTORY      # Write to history immediately
setopt SHARE_HISTORY           # Share history across terminals
setopt HIST_IGNORE_ALL_DUPS    # Remove older duplicate entries
setopt HIST_REDUCE_BLANKS      # Remove superfluous blanks
setopt HIST_VERIFY             # Edit before executing history expansions
setopt EXTENDED_HISTORY        # Timestamp each command in history
setopt HIST_EXPIRE_DUPS_FIRST  # Drop duplicates before unique commands
setopt HIST_FIND_NO_DUPS       # No dupes during history search
setopt HIST_SAVE_NO_DUPS       # Don’t write dupes to file
setopt HIST_IGNORE_SPACE       # Commands starting with space aren’t saved
setopt HIST_NO_STORE           # Don’t store `history`, `fc`, etc.
setopt HIST_FCNTL_LOCK         # Lock history file during write
setopt CHASE_LINKS             # Resolve the real physical path
setopt NULL_GLOB               # Enable nullglob behavior

# --- AUTO GENERATED ---

# bun completions
[ -s "/Users/xcxa1b9/.bun/_bun" ] && source "/Users/xcxa1b9/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

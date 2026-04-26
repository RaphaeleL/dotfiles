
# ~/.zshrc file for zsh interactive shells.

setopt autocd              # change directory just by typing its name
#setopt correct            # auto correct mistakes
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt

WORDCHARS='_-' # Don't consider certain characters part of the word

# hide EOL sign ('%')
PROMPT_EOL_MARK=""

# configure key keybindings
bindkey -e                                        # emacs key bindings
bindkey ' ' magic-space                           # do history expansion on space
bindkey '^U' backward-kill-line                   # ctrl + U
bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo last action

# enable completion features
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
#setopt share_history         # share command history data

# force zsh to show the complete history
alias history="history 0"

# configure `time` format
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

configure_prompt() {
    prompt_symbol="::"
    # Skull emoji for root terminal
    #[ "$EUID" -eq 0 ] && prompt_symbol="%"
    case "$PROMPT_ALTERNATIVE" in
        twoline)
            PROMPT=$'%F{%(#.blue.green)}┌──${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{%(#.red.blue)}%n'$prompt_symbol$'%m%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}]\n└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '
            NEWLINE_BEFORE_PROMPT=yes
            # Right-side prompt with exit codes and background processes
            RPROMPT=$'%(?.. %? %F{red}%B⨯%b%F{reset})%(1j. %j %F{yellow}%B⚙%b%F{reset}.)'
            ;;
        oneline)
            # PROMPT=$'${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{%(#.red.blue)}%n@%m%b%F{reset}:%B%F{%(#.blue.green)}%~%b%F{reset}%(#.#.$) '
            PROMPT=$'[%n@%m %1~]%(#.#.$) '
            PROMPT=$'%n@%m:%~%(#.#.$) '

            RPROMPT=
            NEWLINE_BEFORE_PROMPT=no
            ;;
        backtrack)
            PROMPT=$'%~> '
            RPROMPT=
            NEWLINE_BEFORE_PROMPT=no
            ;;
    esac
    unset prompt_symbol
}

# The following block is surrounded by two delimiters.
# These delimiters must not be modified. Thanks.
PROMPT_ALTERNATIVE=backtrack
NEWLINE_BEFORE_PROMPT=yes

if [ "$color_prompt" = yes ]; then
    # override default virtualenv indicator in prompt
    VIRTUAL_ENV_DISABLE_PROMPT=1

    configure_prompt

    # enable syntax-highlighting
    if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        . /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
        ZSH_HIGHLIGHT_STYLES[default]=none
        ZSH_HIGHLIGHT_STYLES[unknown-token]=underline
        ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
        ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[global-alias]=fg=green,bold
        ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[path]=bold
        ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[command-substitution]=none
        ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[process-substitution]=none
        ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=green
        ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=green
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[assign]=none
        ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
        ZSH_HIGHLIGHT_STYLES[named-fd]=none
        ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
        ZSH_HIGHLIGHT_STYLES[arg0]=fg=cyan
        ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
        ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
    fi
fi
unset color_prompt force_color_prompt

toggle_oneline_prompt(){
    if [ "$PROMPT_ALTERNATIVE" = twoline ]; then
        PROMPT_ALTERNATIVE=oneline
    elif [ "$PROMPT_ALTERNATIVE" = oneline ]; then
        PROMPT_ALTERNATIVE=backtrack
    else
        PROMPT_ALTERNATIVE=twoline
    fi
    configure_prompt
    zle reset-prompt
}
zle -N toggle_oneline_prompt
bindkey ^O toggle_oneline_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty)
    TERM_TITLE=$'\e]0;${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%n@%m: %~\a'
    ;;
*)
    ;;
esac

precmd() {
    # Print the previously configured title
    print -Pnr -- "$TERM_TITLE"

    # Print a new line before the prompt, but only if it is not the first line
    if [ "$NEWLINE_BEFORE_PROMPT" = yes ]; then
        if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
            _NEW_LINE_BEFORE_PROMPT=1
        else
            print ""
        fi
    fi
}

# enable color support of ls, less and man, and also add handy aliases
if [ 1 ]; then # -x /usr/bin/dircolors
    #test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions

    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
    export MANROFFOPT="-c"

    # Take advantage of $LS_COLORS for completion as well
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# enable auto-suggestions based on the history
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    # change suggestion color
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'
fi

# enable command-not-found if installed
if [ -f /etc/zsh_command_not_found ]; then
    . /etc/zsh_command_not_found
fi

# enable certain things on macos
if [[ "$OSTYPE" == "darwin"* ]]; then
    if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        alias icloud='cd "/Users/raphaele/Library/Mobile Documents/com~apple~CloudDocs/"'
    fi
fi

# custom functions and aliases
alias w="watch -t -n 1"                                                       # quick watch
alias remove="shred -f -n 512 --remove -x -z"                                 # absolutely remove everything
path() { echo "$PATH" | tr ":" "\n" }                                         # pretty print path
sizes() { du -sh ./* | sort }                                                 # get the sizes
tmp() { cd "$(mktemp -d)" }                                                   # Quick temp dir
back() { cd - }                                                               # quick go to last dir
hashit() { echo $1  | md5sum | cut -c1-8 }                                    # create a 8 digit hash
mkcd() { [ -n "$1" ] && mkdir -p "$1" && cd "$1" }                            # create and jump a dir
hist() { history | grep -i "$1" }                                             # grep the history
ff() { find . -type f -iname "*$1*" 2>/dev/null }                             # easier way to find files
fd() { find . -type d -iname "*$1*" 2>/dev/null }                             # easier way to find dirs
up() { cd "$(printf '../%.0s' $(seq 1 ${1:-1}))"; }                           # faster dir ups
backup() { cp -r "$1" "$1.bak.$(date +%s)" }                                  # quick backup
port(){ lsof -i :"$1" }                                                       # used port
pk () { pgrep -if -- "$1" | grep -v grep | awk '{print $1}' | xargs kill -9 } # kill process
p () { pgrep -if -- "$1" | grep -v grep }                                     # list process
em() { emacs "$@" >/dev/null 2>&1 &; disown }                                 # gui emacs
emd() { emacsclient -c "$@" >/dev/null 2>&1 &; disown }                       # gui emacs with daemon
emt() { emacs "$@" -nw }                                                      # tty emacs
emdt() { emacsclient -c --nw "$@" }                                           # tty emacs with daemon
emdaemon() { emacs --daemon >/dev/null 2>&1 & disown }                        # start emacs daemon
compress() { tar -czf "$1.tar.gz" "$1" }                                      # compress anything
extract () {                                                                  # auto extract anything
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
fh() {                                                                        # custom history search with fzf
    local cmd
    cmd=$(fc -lnr 1 | sed 's/^[[:space:]]*//' | fzf --height 40% --border --tac --no-mouse --no-info)
    [[ -n $cmd ]] && LBUFFER+="$cmd"
    zle redisplay
}
zle -N fh
bindkey ^R fh

# # --- PROFILE ---
#
# export PATH="$HOME/.local/bin/:$PATH";
# export EDITOR='nvim'
#
# # --- THEME ---
#
# make_prompt_fancy() {
#     # this function decides whether to use an Oh My Zsh based settings or stay in a
#     # rather Plain and basic version of it.
#
#     local PLAIN=1
#     local FANCY=0
#
#     [ -n "$SSH_CONNECTION" ] && return $PLAIN
#     [ -n "$TMUX" ] && return $PLAIN
#
#     case "$TERM_PROGRAM" in
#         iTerm.app) return $PLAIN ;;
#         Apple_Terminal) return $PLAIN ;;
#         ghostty) return $FANCY ;;
#         vscode) return $PLAIN ;;
#     esac
#
#     case "$TERM" in
#         linux) return $PLAIN ;;
#         xterm*|screen*|tmux*) return $FANCY ;;
#     esac
#
#     # we haven't returned out yet, thereby it must be a different terminal then above,
#     # and thereby we are making it os depending.
#     case "$(uname)" in
#         Darwin) # macos -> depending on the current dark/light mode
#             defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q Dark
#             return $?
#             ;;
#         Linux) # linux -> default to fancy
#             return $FANCY
#             ;;
#     esac
#
#     # still havn't returned out yet, so the default is plain
#     return $PLAIN
# }
#
# if make_prompt_fancy; then
#     _git_symbolic_ref() {
#         command git symbolic-ref -q HEAD || command git name-rev --name-only --no-undefined --always HEAD
#     }
#     _git_where() {
#         local ref="$(_git_symbolic_ref 2>/dev/null)"
#         ref="${ref#refs/heads/}"
#         [ -z "$ref" ] || printf '%s%s%s' "$GIT_PROMPT_PREFIX" "$ref" "$GIT_PROMPT_SUFFIX"
#     }
#     autoload -U colors && colors
#     setopt prompt_subst
#     local GIT_PROMPT_PREFIX=" %{$fg[blue]%}git:(%{$fg[red]%}"
#     local GIT_PROMPT_SUFFIX="%{$fg[blue]%})%{$reset_color%}"
#     export PS1='%{$fg[green]%}➜ %{$fg[cyan]%}%1~%{$reset_color%}$(_git_where) '
#     source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#     (( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
#     ZSH_HIGHLIGHT_STYLES[path]=none
#     ZSH_HIGHLIGHT_STYLES[path_prefix]=none
#     # export ZSH="$HOME/.oh-my-zsh"
#     # export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST
#     # ZSH_THEME="robbyrussell"
#     # plugins=()
#     # source $ZSH/oh-my-zsh.sh
#     # autoload -U add-zsh-hook
#     # add-zsh-hook precmd load_syntax_highlighting
#     # load_syntax_highlighting() {
#     #     source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#     #     add-zsh-hook -d precmd load_syntax_highlighting
#     # }
#     alias ls="eza -F"
#     alias ll="eza -AF -ali"
#     # alias ls="ls -FG --color=always"
#     # alias ll="ls -AFGh -ali --color=always"
# else
#     # export PS1="%n@%m %1~ %# " # default prompt
#     export PS1='%~> '
#     alias ls="ls -FG --color=never"
#     alias ll="ls -AFGh -ali --color=never"
# fi
#
# # --- ALIAS ---
#
# alias icloud='cd "/Users/raphaele/Library/Mobile Documents/com~apple~CloudDocs/"'
# alias grep='grep --color=always'
# alias path='echo "$PATH" | tr ":" "\n"' # Pretty Print the Path
# alias sizes="du -sh ./* | sort" # get the sizes
# alias remove="shred -f -n 512 --remove -x -z" # absolutely remove it (not reliable on modern filesystems (APFS, SSDs))
# alias tmp='cd "$(mktemp -d)"' # Quick temp dir
# alias back='cd -' # quick go to last dir
# alias w='watch -t -n 1' # quick watch
# hashit() { echo $1  | md5sum | cut -c1-8 } # create a 8 digit hash
# mkcd() { [ -n "$1" ] && mkdir -p "$1" && cd "$1" } # Create and Jump a Dir
# hist() { history | grep -i "$1" } # Grep the History
# ff() { find . -type f -iname "*$1*" 2>/dev/null } # Easier way to find files
# fd() { find . -type d -iname "*$1*" 2>/dev/null } # Easier way to find dirs
# up() { cd "$(printf '../%.0s' $(seq 1 ${1:-1}))"; } # Faster Dir Up's
# backup() { cp -r "$1" "$1.bak.$(date +%s)" } # Quick backup
# port(){ lsof -i :"$1" } # used port
#
# pk () { pgrep -if -- "$1" | grep -v grep | awk '{print $1}' | xargs kill -9 } # Kill Process
# p () { pgrep -if -- "$1" | grep -v grep } # List Process
#
# em() { emacs "$@" >/dev/null 2>&1 &; disown } # GUI Emacs
# emd() { emacsclient -c "$@" >/dev/null 2>&1 &; disown } # GUI Emacs with Daemon
# emt() { emacs "$@" -nw } # TTY Emacs
# emdt() { emacsclient -c --nw "$@" } # TTY Emacs with Daemon
# emdaemon() { emacs --daemon >/dev/null 2>&1 & disown } # Start Emacs Daemon
#
# compress() { tar -czf "$1.tar.gz" "$1" } # compress anything
# extract () { # auto extract anything
#     [ -f "$1" ] || { echo "file not found"; return 1; }
#     case $1 in
#         *.tar.bz2) tar xjf "$1" ;;
#         *.tar.gz)  tar xzf "$1" ;;
#         *.bz2)     bunzip2 "$1" ;;
#         *.rar)     unrar x "$1" ;;
#         *.gz)      gunzip "$1" ;;
#         *.tar)     tar xf "$1" ;;
#         *.tbz2)    tar xjf "$1" ;;
#         *.tgz)     tar xzf "$1" ;;
#         *.zip)     unzip "$1" ;;
#         *.Z)       uncompress "$1" ;;
#         *.7z)      7z x "$1" ;;
#         *) echo "cannot extract '$1'" ;;
#     esac
# }
#
# regiongrep() { # region based grep wrapper with line range selection and optional regex filtering
#     local start=$1
#     local end=$2
#     local file=$3
#     local pattern=$4
#
#     # validate numbers
#     [[ "$start" =~ ^[0-9]+$ ]] || {
#         echo "usage: regiongrep START END|+OFFSET FILE PATTERN"
#         echo "error: start must be a number"
#         return 1
#     }
#
#     # relative mode
#     if [[ "$end" == +* ]]; then
#         end=$((start + ${end#+}))
#
#     # absolute mode
#     elif [[ "$end" =~ ^[0-9]+$ ]]; then
#         :
#
#     else
#         echo "usage: regiongrep START END|+OFFSET FILE PATTERN"
#         echo "error: invalid end argument"
#         return 1
#     fi
#
#     # sanity check
#     if (( end < start )); then
#         echo "usage: regiongrep START END|+OFFSET FILE PATTERN"
#         echo "error: end < start ($start > $end)"
#         return 1
#     fi
#
#     sed -n "${start},${end}p" "$file"  | nl -ba -v"$start" |
#     if [ -n "$pattern" ]; then
#         grep -iE -C 0 -- "$pattern" # -A 2 -B 2
#     else
#         cat
#     fi
# }
#
# prep() {
#     local session=$1
#
#     tmux rename-window -t "$session:1" dev
#
#     tmux new-window -t "$session:" -n build
#     tmux new-window -t "$session:" -n test -c "test"
#     tmux new-window -t "$session:" -n git
#     tmux new-window -t "$session:" -n ssh
#     tmux new-window -t "$session:" -n log
#
#     tmux send-keys -t "$session:dev" 'ls -al' C-m
#     tmux send-keys -t "$session:build" 'make all -B -j' C-m
#     tmux send-keys -t "$session:\test" 'make run' C-m
#     tmux send-keys -t "$session:git" 'git recent 20 && git status' C-m
#
# }
#
# fh() {
#     local cmd
#     cmd=$(fc -lnr 1 | sed 's/^[[:space:]]*//' | fzf --height 40% --border --tac --no-mouse --no-info)
#     [[ -n $cmd ]] && LBUFFER+="$cmd"
#     zle redisplay
# }
#
# # --- KEYBINDINGS ---
#
# zle -N fh                     # Register the shell function `fh` as a ZLE (Zsh Line Editor) widget so it can be bound to keys.
# bindkey -e                    # Enable Emacs-style keybindings in Zsh (e.g., Ctrl-A, Ctrl-E, Ctrl-R behavior).
# bindkey "^R" fh               # Bind Ctrl-R to the custom ZLE widget `fh` (overrides the default history search).
# bindkey -s ^o "tms\n"         # Bind Ctrl-O to send the literal string "tms" followed by Enter (runs the `tms` command).
# bindkey -s ^h "fsv_connect\n" # Bind Ctrl-H to send the string "fsv_connect" followed by Enter (runs that command).
#
# # --- OS Specific ---
#
# [ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
#
# # --- HISTORY ---
#
# ulimit -n 8192                 # Increase file descriptor limit
# HISTSIZE=100000                # Number of commands kept in memory
# SAVEHIST=100000                # Number of commands saved to the history file
# HISTFILE=~/.zsh_history        # History file location (optional, this is the default)
# setopt APPEND_HISTORY          # Append instead of overwrite
# setopt INC_APPEND_HISTORY      # Write to history immediately
# setopt SHARE_HISTORY           # Share history across terminals
# setopt HIST_IGNORE_ALL_DUPS    # Remove older duplicate entries
# setopt HIST_REDUCE_BLANKS      # Remove superfluous blanks
# setopt HIST_VERIFY             # Edit before executing history expansions
# setopt EXTENDED_HISTORY        # Timestamp each command in history
# setopt HIST_EXPIRE_DUPS_FIRST  # Drop duplicates before unique commands
# setopt HIST_FIND_NO_DUPS       # No dupes during history search
# setopt HIST_SAVE_NO_DUPS       # Don’t write dupes to file
# setopt HIST_IGNORE_SPACE       # Commands starting with space aren’t saved
# setopt HIST_NO_STORE           # Don’t store `history`, `fc`, etc.
# setopt HIST_FCNTL_LOCK         # Lock history file during write
# setopt CHASE_LINKS             # Resolve the real physical path
# setopt NULL_GLOB               # Enable nullglob behavior
#
# # --- AUTO GENERATED ---
#
# # bun completions
# [ -s "/Users/xcxa1b9/.bun/_bun" ] && source "/Users/xcxa1b9/.bun/_bun"
#
# # bun
# export BUN_INSTALL="$HOME/.bun"
# export PATH="$BUN_INSTALL/bin:$PATH"

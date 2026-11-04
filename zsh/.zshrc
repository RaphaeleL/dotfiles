# ~/.zshrc file for zsh interactive shells.
# Profile startup:  time zsh -i -c exit
# Deep profile:     add `zmodload zsh/zprof` at top, `zprof` at bottom

setopt autocd              # change directory just by typing its name
setopt correct             # auto correct mistakes
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt

WORDCHARS='_-' # Don't consider certain characters part of the word

# Atruvia Proxy
[[ -r "$HOME/.atruvia.sh" ]] && source "$HOME/.atruvia.sh"

# hide EOL sign ('%')
PROMPT_EOL_MARK=""

# enable certain things on macos
# (brew shellenv is cached instead of forking brew on every shell start)
if [[ "$OSTYPE" == darwin* && -x /opt/homebrew/bin/brew ]]; then
    _brew_cache=${XDG_CACHE_HOME:-$HOME/.cache}/brew-shellenv.zsh
    if [[ ! -s $_brew_cache || /opt/homebrew/bin/brew -nt $_brew_cache ]]; then
        mkdir -p ${_brew_cache:h}
        /opt/homebrew/bin/brew shellenv >| $_brew_cache
    fi
    source $_brew_cache; unset _brew_cache
    alias icloud='cd "$HOME/Library/Mobile Documents/com~apple~CloudDocs/"'
fi

# tms is located in ~/.local/bin/ if installed successful through dotman
typeset -U path PATH                # dedupe PATH automatically
path=($HOME/.local/bin $path)

# configure key keybindings
bindkey -e                                         # emacs key bindings
bindkey ' '        magic-space                     # do history expansion on space
bindkey '^U'       backward-kill-line              # ctrl + U
bindkey '^[[3;5~'  kill-word                       # ctrl + Supr
bindkey '^[[3~'    delete-char                     # delete
bindkey '^[[1;5C'  forward-word                    # ctrl + ->
bindkey '^[[1;5D'  backward-word                   # ctrl + <-
bindkey '^[[5~'    beginning-of-buffer-or-history  # page up
bindkey '^[[6~'    end-of-buffer-or-history        # page down
bindkey '^[[H'     beginning-of-line               # home
bindkey '^[[F'     end-of-line                     # end
bindkey '^[[Z'     undo                            # shift + tab undo last action

# enable completion features
# (full check once a day, otherwise use the cached dump with -C)
autoload -Uz compinit
_zcd=${XDG_CACHE_HOME:-$HOME/.cache}/zcompdump-$ZSH_VERSION
[[ -d ${_zcd:h} ]] || mkdir -p ${_zcd:h}
if [[ -n $_zcd(#qN.mh+24) || ! -s $_zcd ]]; then
    compinit -d $_zcd
    { zcompile $_zcd } &!
else
    compinit -C -d $_zcd
fi
unset _zcd
zstyle ':completion:*:*:*:*:*'  menu select
zstyle ':completion:*'          auto-description 'specify: %d'
zstyle ':completion:*'          completer _expand _complete
zstyle ':completion:*'          format 'Completing %d'
zstyle ':completion:*'          group-name ''
zstyle ':completion:*'          list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*'          matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*'          select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*'          use-compctl false
zstyle ':completion:*'          use-cache on
zstyle ':completion:*'          cache-path ${XDG_CACHE_HOME:-$HOME/.cache}/zcompcache
zstyle ':completion:*'          verbose true
zstyle ':completion:*:kill:*'   command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=50000                # must be >= SAVEHIST
SAVEHIST=50000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data

alias history="history 0" # force zsh to show the complete history

TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P' # configure `time` format

# set a fancy prompt
configure_prompt() {
    case "$PROMPT_ALTERNATIVE" in
        classic)
            # PROMPT=$'%n@%m:%~%(#.#.$) '
            # PROMPT=$'%n@%m %1~ %# '
            # PROMPT=$'[%n@%m %1~]%(#.#.$) '
            PROMPT=$'[%n@%F{cyan}%m%F{reset} %1~]%(#.#.$) '
            RPROMPT=
            ;;
        minimal)
            PROMPT='%~> '
            # RPROMPT='$(date)'
            RPROMPT=''
            ;;
    esac
}

PROMPT_ALTERNATIVE=classic

# override default virtualenv indicator in prompt
VIRTUAL_ENV_DISABLE_PROMPT=1
configure_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty|tmux*|screen*)
    _set_title() { print -Pn '\e]0;${VIRTUAL_ENV:+(${VIRTUAL_ENV:t})}%n@%m: %~\a' }
    autoload -Uz add-zsh-hook && add-zsh-hook precmd _set_title
    ;;
esac

# enable color support of ls, less and man, and also add handy aliases
[[ -n $LS_COLORS ]] && export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions

alias ls='ls --color=always -F'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
(( $+commands[ip] )) && alias ip='ip --color=auto'
# fgrep/egrep dropped: deprecated in grep >= 3.8, use grep -F / grep -E

export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
# export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
# export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
export LESS='-R'                       #
export MANROFFOPT="-c"

# Take advantage of $LS_COLORS for completion as well
[[ -n $LS_COLORS ]] && zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -lh'
alias la='ls -A'
alias l='ls -CF'

# custom functions and aliases
alias w="watch -t -n 1"                                                       # quick watch
alias remove="shred -fuz -n 3"                                                # absolutely remove everything
path() { print -l $path }                                                     # pretty print path
sizes() { du -sh ./*(N) | sort -h }                                           # get the sizes
tmp() { cd "$(mktemp -d)" }                                                   # Quick temp dir
back() { cd - }                                                               # quick go to last dir
hashit() { print -rn -- "$1" | { md5sum 2>/dev/null || md5 } | cut -c1-8 }    # create a 8 digit hash
mkcd() { [[ -n $1 ]] && mkdir -p -- "$1" && cd -- "$1" }                      # create and jump a dir
hist() { fc -l 1 | grep -i -- "$1" }                                          # grep the history
ff() { find . -type f -iname "*$1*" 2>/dev/null }                             # easier way to find files
ffd() { find . -type d -iname "*$1*" 2>/dev/null }                            # easier way to find dirs (was fd, shadowed the fd tool)
up() { local d=""; repeat ${1:-1} d+="../"; cd "$d" }                         # faster dir ups
backup() { cp -r -- "$1" "$1.bak.$(date +%s)" }                               # quick backup
port(){ lsof -i :"$1" }                                                       # used port
pk() { pkill -9 -if -- "$1" }                                                 # kill process
p() { pgrep -ifl -- "$1" }                                                    # list process
em() { emacsclient -s "main" -a "" -c -n "$@" &>/dev/null }                   # emacs
compress() { tar -czf "${1%/}.tar.gz" "$1" }                                  # compress anything
extract() {                                                                   # auto extract anything
    [[ -f $1 ]] || { echo "file not found"; return 1 }
    case $1 in
        *.tar.bz2|*.tbz2) tar xjf "$1" ;;
        *.tar.gz|*.tgz)   tar xzf "$1" ;;
        *.tar.xz|*.txz)   tar xJf "$1" ;;
        *.tar.zst)        tar --zstd -xf "$1" ;;
        *.tar)            tar xf "$1" ;;
        *.bz2)            bunzip2 "$1" ;;
        *.gz)             gunzip "$1" ;;
        *.xz)             unxz "$1" ;;
        *.rar)            unrar x "$1" ;;
        *.zip)            unzip "$1" ;;
        *.Z)              uncompress "$1" ;;
        *.7z)             7z x "$1" ;;
        *.rpm)            rpm2cpio "$1" | cpio -idmv ;;
        *) echo "cannot extract '$1'"; return 1 ;;
    esac
}
if (( $+commands[fzf] )); then
    fh() {                                                                        # custom history search with fzf
        local cmd
        cmd=$(fc -lnr 1 | awk '!seen[$0]++' | fzf --height='40%' --border --no-scrollbar --no-mouse --pointer='' --no-info --prompt='> ' --marker='' --no-color --query="$LBUFFER")
        [[ -n $cmd ]] && LBUFFER=$cmd
        zle reset-prompt
    }
    zle -N fh
    bindkey '^R' fh
fi

# tms is located in ~/.local/bin/ if installed successful through dotman
(( $+commands[tms] )) && bindkey -s '^O' 'tms\n'

# Keep the zsh prompt at the bottom of the terminal
# autoload -Uz add-zsh-hook
# function bottom_prompt() { printf '\033[999;1H' }
# add-zsh-hook precmd bottom_prompt

# enable syntax-highlighting (must be sourced last)
# for _f in /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
#           /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh; do
#     if [[ -r $_f ]]; then
#         source $_f
#         ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)   # dropped `pattern`: slow, unused
#         ZSH_HIGHLIGHT_STYLES[default]=none
#         ZSH_HIGHLIGHT_STYLES[unknown-token]=underline
#         ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
#         ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
#         ZSH_HIGHLIGHT_STYLES[global-alias]=fg=green,bold
#         ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
#         ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
#         ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
#         ZSH_HIGHLIGHT_STYLES[path]=bold
#         ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
#         ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
#         ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
#         ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
#         ZSH_HIGHLIGHT_STYLES[command-substitution]=none
#         ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta,bold
#         ZSH_HIGHLIGHT_STYLES[process-substitution]=none
#         ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta,bold
#         ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=green
#         ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=green
#         ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
#         ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
#         ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
#         ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
#         ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
#         ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
#         ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta,bold
#         ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta,bold
#         ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta,bold
#         ZSH_HIGHLIGHT_STYLES[assign]=none
#         ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
#         ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
#         ZSH_HIGHLIGHT_STYLES[named-fd]=none
#         ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
#         ZSH_HIGHLIGHT_STYLES[arg0]=fg=cyan
#         ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
#         ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
#         ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
#         ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
#         ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
#         ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
#         ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
#         break
#     fi
# done
# unset _f

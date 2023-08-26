# --- PROMPT --- 
export PS1='\[\e[01;32m\]raphaele@\h:\[\e[01;34m\]\w\[\e[0m\]\$ '

# --- PROFILE --- 
export BASH_SILENCE_DEPRECATION_WARNING=1
export BASH_SESSIONS_DISABLE=1
export LESSHISTFILE=-
export EDITOR='vim'

# --- PATH --- 
export PATH="$PATH:/Users/raphaele/Library/Application Support/JetBrains/Toolbox/scripts"

# --- BREW --- 
eval "$(/opt/homebrew/bin/brew shellenv)"

# --- KEYMAPPINGS --- 

# Basics 
alias lg="lazygit"
alias vim="nvim"
alias vi="NVIM_APPNAME=macnvim nvim"
alias v="/usr/bin/vim"

# Git
alias gs="git status"
alias gd="git diff"
alias ga="git add"
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push"

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias .3="cd ../../.."
alias .4="cd ../../../.."
alias .5="cd ../../../../.."

# Tmux
alias tn="tmux display-message -p '#S'"
alias tl="tmux list-sessions"
alias ta="tmux attach -t"
alias td="tmux detach"
alias tk="tmux kill-session -a -t"
tms() {
    local dir
    # find ${1:-.}
    dir=$(find ~/Developer ~/Master ~/Documents ~/.config ~/Desktop -type d 2> /dev/null | fzf +m)
    session_name=$(basename $dir)
    tmux has-session -t=$session_name 2> /dev/null

    if [[ $? -ne 0 ]]; then
        TMUX='' tmux new-session -d -s "$session_name" -c $dir
    fi

    if [[ -z "$TMUX" ]]; then
        tmux attach -t "$session_name"
    else
        tmux switch-client -t "$session_name"
    fi
}

# Permissions 
alias perms="stat -f '%N %A' *"

# Easter Eggs
function theme() {
    osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to not dark mode'
    DARK_MODE=$(osascript -e 'tell app "System Events" to tell appearance preferences to get dark mode')
    if [[ "${DARK_MODE}" == "true" ]]; then
        export PS1='\[\e[01;32m\]raphaele@\h:\[\e[01;34m\]\w\[\e[0m\]\$ '
    else
        export PS1='\h:\W \u\$ '
    fi
}

# Spezial Commands simplified 
alias remove="shred -n 512 --remove "
alias sizes="du -sh * | gsort -hr"

# List Directory - geohot
alias ls='ls -Ghp'

# --- PROMPT --- 
# export PS1='\u@\h:\[\e[01;36m\]\w\[\e[0m\]\$ '
# export PS1='\[\e[01;32m\]\u@\h:\[\e[01;34m\]\w\[\e[0m\]\$ '
# export PS1='\u@\h:\[\e[01;32m\]\w\[\e[0m\]\$ '
# export PS1='\h:\W \u\$ '
# export PS1='[\u@\h \[\e[01;36m\]\w\[\e[0m\]]\$ '
eval "$(starship init bash)"

# --- PROFILE --- 
export CLICOLOR=1
export BASH_SILENCE_DEPRECATION_WARNING=1
export BASH_SESSIONS_DISABLE=1
export LESSHISTFILE=-
export EDITOR='nvim'

# --- PATH --- 
export PATH=$PATH:/usr/local/go/bin
export PATH="$HOME/bin:$PATH";

# --- Alias' --- 

# Basics 
alias lg="lazygit"
alias vim="nvim"
alias vi="NVIM_APPNAME=macnvim nvim"
alias v="/usr/bin/vim"
alias wezterm="flatpak run org.wezfurlong.wezterm"
alias ls='ls -Ghp'

# Tmux
alias tn="tmux display-message -p '#S'"
alias tl="tmux list-sessions"
alias ta="tmux attach -t"
alias td="tmux detach"
alias tk="tmux kill-session -a -t"
tms() {
    local dir
    dir=$(find ~/bwSyncShare ~/Projects ~/.config ~/Documents ~/Desktop ~/Downloads-type d 2> /dev/null | fzf +m)
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

# Spezial Commands simplified 
alias remove="shred -n 512 --remove "
alias sizes="du -sh * | gsort -hr"
alias uuid="sysctl -n kernel.random.uuid"
alias perms="stat -f '%N %A' *"

# --- I3WM RELATED SHIT --- 

# Turn on/off the Laptop
alias hpoff="xrandr --output eDP --off"
alias hpon="xrandr --output eDP --off"

# Manage Monitors
duplicate() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Error: Two monitor identifiers and the location is required."
        echo "  Monitors:"
        xrandr --listmonitors | awk 'NR>1 {print "\t- "$NF}'
        echo "Usage: duplicate <monitor-a> <monitor-b>"
        return 1
    fi
    xrandr --output $1 --same-as $2
}
expand() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Error: Two monitor identifiers and the location is required."
        echo "  Monitors:"
        xrandr --listmonitors | awk 'NR>1 {print "\t- "$NF}'
        echo "  Location:"
        echo "        - --left-of"
        echo "        - --right-of"
        echo "        - --above"
        echo "        - --below"
        echo "Usage: expand <monitor-a> <location> <monitor-b>"
        return 1
    fi
    xrandr --output $1 $2 $3
}

# Set a random Wallpaper
alias wallpaper="feh --bg-fill --randomize Pictures/wallpapers/"

# --- AUTO GENERATRED --- 

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
. "$HOME/.cargo/env"



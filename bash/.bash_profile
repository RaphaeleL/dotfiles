# --- PROMPT --- 
# export PS1='\u@\h:\[\e[01;36m\]\w\[\e[0m\]\$ '
# export PS1='\[\e[01;32m\]\u@\h:\[\e[01;34m\]\w\[\e[0m\]\$ '
# export PS1='\u@\h:\[\e[01;32m\]\w\[\e[0m\]\$ '
# export PS1='\h:\W \u\$ '
export PS1='[\u@\h \[\e[01;36m\]\w\[\e[0m\]]\$ '
# eval "$(starship init bash)"

# --- PROFILE --- 
export BASH_SILENCE_DEPRECATION_WARNING=1
export BASH_SESSIONS_DISABLE=1
export LESSHISTFILE=-
export EDITOR="/usr/bin/vim"
# export CLICOLOR=1

# --- PATH --- 
export PATH=$PATH:/usr/local/go/bin
export PATH="$HOME/bin:$PATH";

# --- Alias' --- 

# Basics 
alias lg="lazygit"
alias v="/usr/bin/vim"
alias vim="nvim"
alias e="emacs -nw"
# alias ls="ls -Ghp"

# Special Commands simplified 
alias remove="shred -f -n 512 --remove -x -z"
alias sizes="du -sh * | gsort -hr"
alias uuid="sysctl -n kernel.random.uuid"
alias perms="stat -f '%N %A' *"
alias emacs-kill="emacsclient -e '(kill-emacs)'"

# Tmux
alias tmux-ls="tmux list-sessions"
alias tmux-a="tmux attach -t"
alias tmux-d="tmux detach"
tmux_ccms_prep() {
    tmux rename-window -t 1 CCMS
    tmux new-window -t "$session_name" -n Podman
    tmux new-window -t "$session_name" -n TestVMs
    tmux new-window -t "$session_name" -n ksbuild8
    tmux new-window -t "$session_name" -n scp-toolbox
    tmux new-window -t "$session_name" -n packaging
    tmux select-window -t:-5
}
tms() {
    if [[ -n "$1" ]]; then
        session_name="$1"
    else
        dir=$(find ~/dev -mindepth 0 -maxdepth 2 -type d 2> /dev/null | fzf +m)
        session_name=$(basename "$dir")
    fi
    tmux has-session -t="$session_name" 2>/dev/null

    if [[ $? -ne 0 ]]; then
        TMUX='' tmux new-session -d -s "$session_name" -c "$dir"
    fi

    if [[ -z "$TMUX" ]]; then
        tmux attach -t "$session_name"
    else
        tmux switch-client -t "$session_name"
    fi
}

# --- I3WM RELATED SHIT --- 

# Turn on/off the Laptop
alias hpoff="xrandr --output eDP --off"
alias hpon="xrandr --output eDP --auto"
alias i3picom="picom --config /home/lira0003/.config/picom/picom_i3.conf --experimental-backends -b &"

# Set a random Wallpaper
alias wallpaper="feh --bg-fill --randomize Pictures/wallpapers/"
alias background_black="hsetroot -solid "#000000""

# Lock Screen 
alias lock="i3lock -c ffffff"

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

# --- MACOS RELATED SHIT --- 

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# --- AUTO GENERATRED --- 

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
. "$HOME/.cargo/env"



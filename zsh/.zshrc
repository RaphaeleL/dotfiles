# --- ZSH --- 
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="example_non_colorful" # or just colorful
plugins=(
    # git
    # zsh-syntax-highlighting
    # zsh-autosuggestions
)
source $ZSH/oh-my-zsh.sh

(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST

# --- PROFILE --- 
export BASH_SILENCE_DEPRECATION_WARNING=1
export BASH_SESSIONS_DISABLE=1
export LESSHISTFILE=-
export EDITOR="/usr/bin/vim"
export PATH=$PATH:/usr/local/go/bin
export PATH="$HOME/bin:$PATH";
export BASH_SILENCE_DEPRECATION_WARNING=1
export BASH_SESSIONS_DISABLE=1
export LESSHISTFILE=-
export EDITOR="vi"
# export CLICOLOR=1
export PATH=$PATH:/usr/local/go/bin
export PATH="$HOME/bin:$PATH";

# --- General --- 

# BindKey
bindkey -s ^s "tms\n"

# Keybindings 
bindkey -e

# History
HISTSIZE=5000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

# --- Alias' --- 

# Basics 
alias lg="lazygit"
alias v="/usr/bin/vim"
alias vim="nvim"
alias e="emacs -nw"
alias ls="ls -hp" # -G for colors or just use eza
alias python="python3"

# Special Commands simplified 
alias remove="shred -f -n 512 --remove -x -z"
alias sizes="du -sh * | gsort -hr"
alias perms="stat -f '%N %A' *"
alias emacs-kill="emacsclient -e '(kill-emacs)'"

# Tmux
alias tmux-ls="tmux list-sessions"
alias tmux-a="tmux attach -t"
alias tmux-d="tmux detach"
tms() {
    dir=$(find ~/bwSyncShare ~/Projects ~/.config ~/Documents ~/Desktop ~/Downloads -mindepth 0 -maxdepth 1 -type d 2> /dev/null | fzf +m)
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

# --- AUTO GENERATED --- 

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# pnpm
export PNPM_HOME="/Users/raphaele/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

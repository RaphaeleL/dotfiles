# --- ZSH ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="example"
plugins=(
    git
    zsh-syntax-highlighting
    zsh-autosuggestions
)
source $ZSH/oh-my-zsh.sh

(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST

# --- PROFILE ---
export PATH
export PATH="$HOME/bin:$PATH";
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$HOME/.local/share/JetBrains/Toolbox/scripts"
export PATH=$PATH:~/.local/bin

export EDITOR='nvim'

# --- Alias' ---

# Basic's
alias ger='echo "LANG=de_DE.UTF-8" | sudo tee /etc/locale.conf && setxkbmap de'
alias eng='echo "LANG=en_US.UTF-8" | sudo tee /etc/locale.conf && setxkbmap us'
alias i3_bg_black='xsetroot -solid black &'
alias i3_bg_wallpaper='feh --bg-fill ~/Bilder/Wallpaper-main/pexels-ragga-muffin-2468773.jpg'
alias grep='grep --color=always'
alias ls="ls --color=always -Ghp"

# Special Commands simplified
alias remove="shred -f -n 512 --remove -x -z"

fh() {
  local cmd
  cmd=$(builtin fc -lnr 1 | fzf --height 40% --border --no-scrollbar --tac --no-mouse --pointer='' --no-info --prompt='' --marker='')

  if [[ -n $cmd ]]; then
    LBUFFER+="$cmd"
    zle reset-prompt 
  fi
}

zle -N fh
bindkey "^R" fh

ccms_tmux_setup_test() {
    tmux rename-window -t 1 CCMS
    tmux new-window -t "$session_name" -n TestVM-1 
    tmux new-window -t "$session_name" -n TestVM-2 
    tmux new-window -t "$session_name" -n ksbuild8
    tmux select-window -t:-3
}
ccms_tmux_setup_dev() {
    tmux rename-window -t 1 CCMS
    tmux new-window -t "$session_name" -n Podman
    tmux new-window -t "$session_name" -n TestVMs
    tmux new-window -t "$session_name" -n ksbuild8
    tmux new-window -t "$session_name" -n scp-toolbox
    tmux new-window -t "$session_name" -n packaging
    tmux select-window -t:-5
}

# Tmux
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

# Test for TRAMP Emacs
if [[ $- != *i* ]]; then
    return
fi


# --- AUTO GENERATED ---

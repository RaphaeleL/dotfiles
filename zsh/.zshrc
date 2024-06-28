# --- ZSH --- 
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="example"
plugins=(
    git
    zsh-syntax-highlighting
    zsh-autosuggestions
)
source $ZSH/oh-my-zsh.sh

# --- PROFILE --- 
export BASH_SILENCE_DEPRECATION_WARNING=1
export BASH_SESSIONS_DISABLE=1
export LESSHISTFILE=-
export EDITOR='nvim'

# --- PATH --- 
export PATH=$PATH:/usr/local/go/bin
export PATH="$HOME/bin:$PATH";

# --- Alias' --- 

# Basics 
alias vim="nvim"
alias vi="/usr/bin/vim"
alias e="emacs -nw"

alias ls="eza"

# Special Commands simplified 
alias remove="shred -n 512 --remove "
alias sizes="du -sh * | gsort -hr"
alias perms="stat -f '%N %A' *"

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

# --- MACOS RELATED SHIT --- 

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"



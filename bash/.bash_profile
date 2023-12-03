# --- PROMPT --- 
export PS1='\u@\h:\[\e[01;36m\]\w\[\e[0m\]\$ '
# export PS1='\[\e[01;32m\]\u@\h:\[\e[01;34m\]\w\[\e[0m\]\$ '
# export PS1='\u@\h:\[\e[01;32m\]\w\[\e[0m\]\$ '
# export PS1='\h:\W \u\$ '
# export PS1='[\u@\h \[\e[01;36m\]\w\[\e[0m\]]\$ '

# --- PROFILE --- 
export CLICOLOR=1
export BASH_SILENCE_DEPRECATION_WARNING=1
export BASH_SESSIONS_DISABLE=1
export LESSHISTFILE=-
export EDITOR='vim'
export PNPM_HOME="/Users/raphaele/Library/pnpm"
if [[ "$(uname)" == "Linux" ]]; then
	export PNPM_HOME="~/.local/share/pnpm"
fi
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# --- PATH --- 
export PATH="$HOME/bin:$PATH";
export PATH="$HOME/bin:$PATH";
. "$HOME/.cargo/env"
export PATH="$PNPM_HOME:$PATH"

# --- BREW --- 
if [[ "$(uname)" == "Darwin" ]]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# --- Alias' --- 
# Basics 
alias lg="lazygit"
alias vim="nvim"
alias vi="NVIM_APPNAME=macnvim nvim"
alias v="/usr/bin/vim"

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

# Spezial Commands simplified 
alias remove="shred -n 512 --remove "
alias sizes="du -sh * | gsort -hr"

# List Directory - geohot
alias ls='ls -Ghp'

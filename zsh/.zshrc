# --- ZSH ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(
    git
    zsh-syntax-highlighting
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

export EDITOR='nvim'

# --- Alias' ---

# Basic's
alias ger='echo "LANG=de_DE.UTF-8" | sudo tee /etc/locale.conf && setxkbmap de'
alias eng='echo "LANG=en_US.UTF-8" | sudo tee /etc/locale.conf && setxkbmap us'
alias grep='grep --color=always'
alias ls="ls --color=always -Ghp"
alias vim='nvim'

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

# Tmux
tms() {
    if [[ -n "$1" ]]; then
        session_name="$1"
    # else if: if no params then:
    else
        echo 'Usage: tms <session_name>'
        echo '   - session_name: is either a given or wanted Tmux Session'
        echo '   - (there is tab completion)'
        return

        # dir=$(find ~/dev -mindepth 0 -maxdepth 2 -type d 2> /dev/null | fzf +m)
        # session_name=$(tmux list-sessions -F '#S' 2> /dev/null | fzf --height 40% --border --no-scrollbar --tac --no-mouse --pointer='' --no-info --prompt='' --marker='')

    fi
    tmux has-session -t="$session_name" 2>/dev/null

    if [[ $? -ne 0 ]]; then
        TMUX='' tmux new-session -d -s "$session_name" # -c "$dir"
    fi

    if [[ -z "$TMUX" ]]; then
        tmux attach -t "$session_name"
    else
        tmux switch-client -t "$session_name"
    fi
}
# Completion function for tms
_tms_complete() {
    local -a sessions
    sessions=("${(@f)$(tmux list-sessions -F '#S' 2>/dev/null)}")
    compadd -a sessions
}
compdef _tms_complete tms       # NOTE: this is for zsh. 
# complete -F _tms_complete tms # NOTE: this is for bash. 

# Test for TRAMP Emacs
if [[ $- != *i* ]]; then
    return
fi


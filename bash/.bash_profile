# --- PROMPT --- 
export PS1='\u@\h:\[\e[36m\]\w\[\e[0m\]\$ '

# --- BASE --- 
export BASH_SILENCE_DEPRECATION_WARNING=1
export BASH_SESSIONS_DISABLE=1
export LESSHISTFILE=-
export EDITOR="/usr/bin/vim"

# --- PATH --- 
export PATH
export PATH="$HOME/bin:$PATH";
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/go/bin$HOME/.local/bin:$PATH"

# --- Alias' --- 

# Basic
alias grep='grep --color=always'
alias ls="ls -Ghp"
alias vim='nvim'
alias vi='/usr/bin/vim'

# Special Commands simplified 
alias remove="shred -f -n 512 --remove -x -z"
alias sizes="du -sh * | gsort -hr"
alias perms="stat -f '%N %A' *"
alias emacs-kill="emacsclient -e '(kill-emacs)'"
alias calc="numi-cli"

# Custom Scripts 
fh() { # Fuzzy History
  local cmd
  cmd=$(builtin fc -lnr 1 | fzf --height 40% --border --no-scrollbar --tac --no-mouse --pointer='' --no-info --prompt='' --marker='')

  if [[ -n $cmd ]]; then
    LBUFFER+="$cmd"
    zle reset-prompt 
  fi
}
zle -N fh
bindkey "^R" fh 

tms() { # Tmux Sessionizer
    if [[ -n "$1" ]]; then
        session_name="$1"
    else
        session_name=$(tmux list-sessions -F '#S' 2>/dev/null | fzf --height 40% --border --no-scrollbar --tac --no-mouse --pointer='' --no-info  --marker='' --prompt="Select tmux session: ")
        [[ -z "$session_name" ]] && return
    fi
    tmux has-session -t="$session_name" 2>/dev/null

    if [[ $? -ne 0 ]]; then
        TMUX='' tmux new-session -d -s "$session_name"
    fi

    if [[ -z "$TMUX" ]]; then
        tmux attach -t "$session_name"
    else
        tmux switch-client -t "$session_name"
    fi
}
_tms_complete() {
    local cur
    cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -W "$(tmux list-sessions -F '#S' 2>/dev/null)" -- "$cur") )
}
complete -F _tms_complete tms

# --- OS Specific ---

if [[ "$(uname -s)" == "Darwin" ]]; then        # MacOS
    # Homebrew
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # Function to set terminal title
    set_title() {
      local title="$1"
      printf "\033]0;%s\007" "$title"
    }

    # Dynamic title on prompt
    PROMPT_COMMAND='set_title "${USER}@${HOSTNAME}: ${PWD/#$HOME/~}"'

elif [[ "$(uname -s)" == "Linux" ]]; then      # Linux

    alias ger='echo "LANG=de_DE.UTF-8" | sudo tee /etc/locale.conf && setxkbmap de'
    alias eng='echo "LANG=en_US.UTF-8" | sudo tee /etc/locale.conf && setxkbmap us'

else
    echo "Unsupported OS: $(uname -s)"
fi

# --- AUTO GENERATRED --- 

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
. "$HOME/.cargo/env"



# --- ZSH ---

# OMZ + Plugins
export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="robbyrussell"
# plugins=(
#     git
#     zsh-syntax-highlighting
# )
source $ZSH/oh-my-zsh.sh

# Custom Prompt

# export PS1='%{%}[%n@dev :: %~] %# %{%}'
export PS1='%{%}[%n@dev %1~]%# %{%}'

# ZSH Settings
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST

# --- PROFILE ---

export PATH
export PATH="$HOME/bin:$PATH";
export PATH="$HOME/.local/bin:$PATH"

export EDITOR='vim'

# --- ALIAS ---

# Basic
alias ger='echo "LANG=de_DE.UTF-8" | sudo tee /etc/locale.conf && setxkbmap de'
alias eng='echo "LANG=en_US.UTF-8" | sudo tee /etc/locale.conf && setxkbmap us'
alias grep='grep --color=always'
# alias ls="ls --color=always -Ghp"
alias ls="ls --color=never -Ghp"

# Special Commands simplified
alias remove="shred -f -n 512 --remove -x -z"

# Custom Scripts
fh() { # Fuzzy History
  local cmd
  cmd=$(builtin fc -lnr 1 | fzf --height 40% --border --no-scrollbar --tac --no-mouse --pointer='' --no-info --prompt='' --marker='')

  if [[ -n $cmd ]]; then
    LBUFFER+="$cmd"
    zle reset-prompt
  fi
}

tms() { # Tmux Sessionizer
    if [[ -n "$1" ]]; then
        session_name="$1"
    else
        session_name=$(tmux list-sessions -F '#S' 2>/dev/null | fzf-tmux --height 40% --border --no-scrollbar --tac --no-mouse --pointer='' --no-info  --marker='' --prompt="")
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
_tms_complete() { # Tab Complete TMS with exisiting Tmux Sessions
    local -a sessions
    sessions=("${(@f)$(tmux list-sessions -F '#S' 2>/dev/null)}")
    compadd -a sessions
}
compdef _tms_complete tms

ccat() {
	# NOTE: ccat <start> <end> <file>
    tail -n "+$1" $3 | head -n "$(($2 - $1 + 1))"
}

# --- Bind Functions to Keys ---

zle -N fh
bindkey "^R" fh

bindkey -s ^o "tms\n"


# setxkbmap -layout us,de -option grp:shifts_toggle,ctrl:nocaps,compose:ralt
# xmodmap -e 'keycode 102 = Super_L'

# --- OS Specific ---

if [[ "$(uname -s)" == "Darwin" ]]; then        # MacOS

    # Homebrew
    eval "$(/opt/homebrew/bin/brew shellenv)"

elif [[ "$(uname -s)" == "Linux" ]]; then       # Linux

    # Test for TRAMP Emacs
    if [[ $- != *i* ]]; then
        return
    fi

	unset SSH_ASKPASS
	unset GIT_ASKPASS

fi

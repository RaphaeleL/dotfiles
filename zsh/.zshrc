# --- ZSH ---

# OMZ + Plugins
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(
    git
    zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh

# Custom Prompt

# export PS1='%{%}[%n@dev :: %~] %# %{%}'
# export PS1='%{%}[%n@dev %1~]%# %{%}'

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
alias ls="ls --color=never -hp"
alias em="emacs -q -l ~/.emacs.d/_term/init.el"
# em() {
#     if [ $# -eq 0 ]; then
#         emacs -q -l ~/.emacs.d/init.term.el &
#     else
#         emacs -q -l ~/.emacs.d/init.term.el "$@" &
#     fi
# }

# Special Commands simplified
alias remove="shred -f -n 512 --remove -x -z"
alias fullscreen="xrandr --output Virtual1 --mode 1920x1080"
alias halfscreen="xrandr --output Virtual1 --mode 1600x900"
alias smallscreen="xrandr --output Virtual1 --mode 1366x768"
alias longscreen='xrandr --output Virtual1 --mode 1400x1050'

# Custom Scripts
fh() { # Fuzzy History
  local cmd
  cmd=$(builtin fc -lnr 1 | fzf --height 40% --border --no-scrollbar --tac --no-mouse --pointer='' --no-info --prompt='' --marker='')

  if [[ -n $cmd ]]; then
    LBUFFER+="$cmd"
    zle reset-prompt
  fi
}

# --- Keybindings ---
zle -N fh
bindkey "^R" fh
bindkey -s ^o "tms\n"

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

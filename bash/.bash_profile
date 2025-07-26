# --- PROMPT --- 
# export PS1='[\u@\h \W]\$ '
export PS1='[\u@\e[0;31m\h\e[m \W]\$ '

# --- BASE --- 
export BASH_SILENCE_DEPRECATION_WARNING=1
export BASH_SESSIONS_DISABLE=1
export LESSHISTFILE=-
export EDITOR="/usr/bin/vim"

# --- PATH --- 
export PATH
export PATH="$HOME/bin:$PATH";
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH";
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/bin:$PATH"

# --- Alias' --- 

# Basic
alias grep='grep --color=always'

# Special Commands simplified 
alias remove="shred -f -n 512 --remove -x -z"
alias sizes="du -sh * | gsort -hr"
alias perms="stat -f '%N %A' *"
alias calc="numi-cli"

# Emacs 
alias em="emacs -q -l ~/.emacs.d/init.term.el"
alias emt="emacs -q -l ~/.emacs.d/init.term.el -nw"

# --- HOMEBREW --- 

eval "$(/opt/homebrew/bin/brew shellenv)"

# --- AUTO GENERATRED --- 

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
. "$HOME/.cargo/env"



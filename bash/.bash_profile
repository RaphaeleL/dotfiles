# --- PROMPT --- 
# export PS1='[\u@\h \W]\$ '
# export PS1='[\u@\[\e[0;31m\]\h\[\e[m\] \W]\$ '
# export PS1='\u@\h:\[\e[33m\]\w\[\e[0m\]\$ '
export PS1='\w> '

# --- BASE --- 
export BASH_SILENCE_DEPRECATION_WARNING=1
export BASH_SESSIONS_DISABLE=1
export LESSHISTFILE=-
export EDITOR="/usr/bin/vim"

# --- PATH --- 
export PATH
export PATH="$HOME/bin:$PATH";
export PATH="$HOME/go/bin:$PATH";
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/usr/local/bin:$PATH"

export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

# --- Alias' --- 

# Basic
alias grep='grep --color=always'

# Special Commands simplified 
alias remove="shred -f -n 512 --remove -x -z"
alias sizes="du -sh * | gsort -hr"
alias perms="stat -f '%N %A' *"
alias calc="numi-cli"
alias ls="ls -AFh"
alias ll="ls -AFhal"

# Emacs 
alias em="emacs -q -l ~/.emacs.d/init.term.el"
alias emt="emacs -q -l ~/.emacs.d/init.term.el -nw"

# --- KEYBOARD SHORTCUTS --- 

fh() {
  local cmd
  cmd=$(HISTTIMEFORMAT= history \
        | tac \
        | fzf --height 40% --border --no-scrollbar --tac \
              --no-mouse --pointer='>' --no-info \
              --prompt='Command> ' --marker='x' \
        | sed -E 's/^[[:space:]]*[0-9]+[[:space:]]+//')

  if [[ -n $cmd ]]; then
    READLINE_LINE=$cmd
    READLINE_POINT=${#cmd}
    history -s "$cmd"
    eval "$cmd"
  fi
}

bind -x '"\C-r": fh'
bind -x '"\C-t": "tms"'

# --- HOMEBREW --- 

eval "$(/opt/homebrew/bin/brew shellenv)"

# --- AUTO GENERATRED --- 

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
. "$HOME/.cargo/env"


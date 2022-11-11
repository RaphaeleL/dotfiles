alias ls='ls --color'
export PS1='\u@\h:\[\e[33m\]\w\[\e[0m\]\$ '

export EDITOR='nvim'

# +----------------+
# | Variables      | 
# +----------------+

export JAVA_HOME="/usr/bin/java"
export GOPATH="$HOME/sdk/go1.18.2/bin"

export PATH="/usr/local/sbin:$PATH"
export PATH="/opt/homebrew/opt/python@3.10/bin:$PATH"
export PATH=/Users/raphaele/.local/bin:$PATH

# +----------------+
# | Shortcuts      | 
# +----------------+

# work connection 
alias iam="sshpass -f ~/.ssh/.secret.txt ssh iam-mms"

# navigation 
alias dev="cd ~/Developer"
alias s2="cd ~/Hochschule/Semester-2"

alias ..="cd .."
alias ...="cd ../.."
alias .3="cd ../../.."
alias .4="cd ../../../.."
alias .5="cd ../../../../.."
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias la="exa -a --color=always --group-directories-first" 
alias ll="exa -aril --color=always --group-directories-first"  
alias ls="exa --color=always --group-directories-first"  
alias lt="exa -aT --color=always --group-directories-first" 
alias l.="exa -a | egrep "^\.""

# just shorter 
alias ip="ipconfig getifaddr en0"
alias ip-public="curl ifconfig.me"
alias v="nvim" 
alias g="git"
alias gl="lazygit"

# Apple Silicon Brew  
# alias brew="arch -arm64 brew"

# tmux
alias tk-server="tmux kill-server"
alias tl="tmux ls"
tk() {
  tmux kill-session -t $1
}
td() {
  tmux detach 
}
ta() {
  tmux attach-session -t $1
}

# +----------------+
# | Auto Generated | 
# +----------------+

# envman
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# pnpm
export PNPM_HOME="/Users/raphaele/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# llvm 
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

# +----------------+
# | FZF            | 
# +----------------+

# Shortcuts
tf() {
  tmux-detach
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
  cd "$dir"
  tmux new -s $(basename $dir)
  cd
}
fh() {
  history | fzf
}
killf() {
    local pid 
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi  
    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi  
}

# Homebrew 
function homebrew() {
  echo "==> Running 'brew update'" && brew update &&
  echo "==> Running 'brew outdated'" && brew outdated &&
  echo "==> Running 'brew upgrade'" && brew upgrade &&
  echo "==> Running 'brew cleanup'" && brew cleanup
}

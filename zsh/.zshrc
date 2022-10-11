# +----------------+
# | Variables      | 
# +----------------+

export ZSH="$HOME/.oh-my-zsh"
export JAVA_HOME="/usr/bin/java"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export GOPATH="$HOME/sdk/go1.18.2/bin"
export EDITOR=nvim
export PATH="/usr/local/sbin:$PATH"
export TERM=xterm
export PATH="/opt/homebrew/opt/python@3.10/bin:$PATH"
export PATH=/Users/raphaele/.local/bin:$PATH

# +----------------+
# | Theme          | 
# +----------------+

ZSH_THEME="own-theme"

# +----------------+
# | Plugins        |
# +----------------+

plugins=(zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

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
alias brew="arch -arm64 brew"

# tmux
alias tk-server="tmux kill-server"
alias tls="tmux ls"
tk-session() {
  tmux kill-session -t $1
}
td() {
  tmux detach 
}
ta() {
  tmux attach-session -t $1
}

# +----------------+
# | FZF            | 
# +----------------+

# Init 
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Shortcuts
tf() {
  tmux-detach
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
  cd "$dir"
  tmux new -s $(basename $dir)
  cd
}
hf() {
  history | fzf
}
kf() {
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

# Command Line Shortcuts 
bindkey "^K"      kill-whole-line                      # ctrl-k
bindkey "^R"      history-incremental-search-backward  # ctrl-r
bindkey "^A"      beginning-of-line                    # ctrl-a  
bindkey "^E"      end-of-line                          # ctrl-e

# Homebrew 
function homebrew() {
  echo "==> Running 'brew update'" && brew update &&
  echo "==> Running 'brew outdated'" && brew outdated &&
  echo "==> Running 'brew upgrade'" && brew upgrade &&
  echo "==> Running 'brew cleanup'" && brew cleanup
}

# +----------------+
# | Options        | 
# +----------------+

# If you type foo, and it isn't a command, and it is a directory in your cdpath, go there
setopt AUTO_CD

# Remove extra blanks from each command line being added to history
setopt HIST_REDUCE_BLANKS

# Include more information about when the command was executed, etc
setopt EXTENDED_HISTORY
unsetopt MENU_COMPLETE
setopt AUTO_MENU

# +----------------+
# | Auto Generated | 
# +----------------+

# envman
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# conda 
__conda_setup="$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniforge/base/bin:$PATH"
    fi
fi
unset __conda_setup

# pnpm
export PNPM_HOME="/Users/raphaele/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# llvm 
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

# doom emacs 
export PATH="/Applications/MacPorts/Emacs.app/Contents/MacOS:$PATH"


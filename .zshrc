export ZSH="$HOME/.oh-my-zsh"
export JAVA_HOME="/usr/bin/java"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

ZSH_THEME="own-theme"

plugins=( 
    zsh-syntax-highlighting
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

alias ..="cd .."
alias ...="cd ../.."
alias .3="cd ../../.."
alias .4="cd ../../../.."
alias .5="cd ../../../../.."

alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

alias la="exa -a --color=always --group-directories-first" 
alias ll="exa -al --color=always --group-directories-first"  
alias ls="exa -l --color=always --group-directories-first"  
alias lt="exa -aT --color=always --group-directories-first" 
alias l.="exa -a | egrep "^\.""

alias ip="ipconfig getifaddr en0"

export PATH="/usr/local/sbin:$PATH"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
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

alias v="nvim" 
alias g="git"
alias tk="tmux kill-server"
alias tl="tmux ls"
alias todo="cd ~/Hochschule/Semester-1; nvim Todo.md; cd"

tr() {
  tmux kill-session -t $1
}
td() {
  tmux detach 
}
ta() {
  tmux attach-session -t $1
}
t() {
  tmux has-session -t $1 2>/dev/null
  if [ $? != 0 ]; then
    tmux new -s $1 
  fi
  tmux attach-session -t $1
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

fd() {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
  cd "$dir"
  tmux new -s $(basename $dir)
  cd
}
ff() {
  nvim $(fzf)
}
fh() {
  history | fzf
}
fkill() {
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



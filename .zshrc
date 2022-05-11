export ZSH="$HOME/.oh-my-zsh"
export JAVA_HOME="/usr/bin/java"

ZSH_THEME="own-theme"

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
source /Users/raphaele/.config/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

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

alias tk="tmux kill-server"
alias tl="tmux ls"
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




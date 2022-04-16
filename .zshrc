export ZSH="$HOME/.oh-my-zsh"
export JAVA_HOME="/usr/bin/java"

ZSH_THEME="own-theme"

plugins=(zsh-syntax-highlighting web-search)

source $ZSH/oh-my-zsh.sh

alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

alias la='exa -al --color=always --group-directories-first' 
alias ls='exa -a --color=always --group-directories-first'  
alias ll='exa -l --color=always --group-directories-first'  
alias lt='exa -aT --color=always --group-directories-first' 
alias l.='exa -a | egrep "^\."'

export PATH="/usr/local/sbin:$PATH"

export BASH_SILENCE_DEPRECATION_WARNING=1
export PS1="\[\e[01;94m\][ \[\e[01;32m\]\[\e[0m\]\u\[\e[91m\]@\[\e[0m\]\h \[\e[92m\]::\[\e[0m\] \w \[\e[0m\]\[\e[01;94m\]] \[$(tput sgr0)\]"
export EDITOR='nvim'
export CLICOLOR=1

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

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

# just shorter 
alias ip="ipconfig getifaddr en0"
alias ip-public="curl ifconfig.me"
alias gl="lazygit"

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

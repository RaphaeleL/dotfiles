# Basics 
alias lg="lazygit"
alias tldrf="tldr --list | fzf --preview 'tldr {1} --color=always' --preview-window=right,70% | xargs tldr"
alias rgrep="rg"
alias vim="nvim"
alias vi="/usr/bin/vim"

# Git
alias gs="git status"
alias gd="git diff"
alias ga="git add"
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push"

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias .3="cd ../../.."
alias .4="cd ../../../.."
alias .5="cd ../../../../.."

# Tmux
alias tl="tmux list-sessions"
alias ta="tmux attach -t"
alias td="tmux detach"
alias tk="tmux kill-session -a -t"

# Permissions 
alias perms="stat -f '%N %A' *"

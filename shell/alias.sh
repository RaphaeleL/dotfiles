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
tf() {
    local dir
    dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
    tmux has-session -t $(basename $dir) 2> /dev/null 
    if [[ $? -ne 0 ]]; then
        TMUX='' tmux new -d -s $(basename $dir)
    fi
    cd "$dir"
    if [[ -z "$TMUX" ]]; then
        tmux attach-session -t $(basename $dir) || tmux new -s $(basename $dir)
    else
        tmux switch-client -t $(basename $dir)
    fi
    cd
}

# Permissions 
alias perms="stat -f '%N %A' *"

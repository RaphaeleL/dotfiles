# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# oh-my-zsh Plugins
plugins=(zsh-syntax-highlighting zsh-autosuggestions)

# No Comp Files 
if [ -z "$ZSH_COMPDUMP" ]; then
  ZSH_COMPDUMP="${ZDOTDIR:-${ZSH}}/cache/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"
fi

# Theme 
ZSH_THEME="own-theme"
source $ZSH/oh-my-zsh.sh
# source $(brew --prefix powerlevel10k)/powerlevel10k.zsh-theme
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Some Alias'
alias vim="nvim"
alias vi="/usr/bin/vim"
alias lg="lazygit"

# Some Alias' - Git
alias gs="git status"
alias gd="git diff"
alias ga="git add"
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push"

# Some Alias' - Navigation
alias ..="cd .."
alias ...="cd ../.."
alias .3="cd ../../.."
alias .4="cd ../../../.."
alias .5="cd ../../../../.."
alias la="exa -a --color=always --group-directories-first" 
alias ll="exa -aril --color=always --group-directories-first"  
alias ls="exa --color=always --group-directories-first"  
alias lt="exa -aT --color=always --group-directories-first" 
alias l.="exa -a | egrep "^\.""

# Some Alias' - Tmux
alias tl="tmux list-sessions"
alias ta="tmux attach -t"
alias td="tmux detach"
alias tk="tmux kill-session -a -t"

# Don't underline Paths
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.

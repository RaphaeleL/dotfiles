# oh-my-zsh Plugins
plugins=(zsh-syntax-highlighting zsh-autosuggestions)

# No Comp Files 
if [ -z "$ZSH_COMPDUMP" ]; then
  ZSH_COMPDUMP="${ZDOTDIR:-${ZSH}}/cache/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"
fi

# Theme 
ZSH_THEME="own-theme" # "robbyrussell"  
source $ZSH/oh-my-zsh.sh

# Don't underline Paths
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# alias 
source ~/.config/shell/alias.sh
source ~/.config/shell/alias_exa.sh
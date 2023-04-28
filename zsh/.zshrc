# OH MY ZSH - NOT USED - BUT KEEP FOR PLUG LOCATION
# export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="robbyrussell"
# plugins=(git) # zsh-syntax-highlighting)
# source $ZSH/oh-my-zsh.sh

# KEYMAPS 
source ~/.config/shell/alias.sh
source ~/.config/shell/alias_exa.sh

# PLUGINS
source .oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
source .oh-my-zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source .oh-my-zsh/plugins/vi-mode/vi-mode.plugin.zsh

# NO UGLY
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# PROMPT
PROMPT='%B%F{green}raphaele@%m:%F{blue}%~%F{white}$%F{reset} '

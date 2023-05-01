# KEYMAPS 
source ~/.config/shell/alias.sh

# PLUGINS
source ~/.oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
source ~/.oh-my-zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source ~/.oh-my-zsh/plugins/vi-mode/vi-mode.plugin.zsh

# NO UGLY
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# PROMPT
PROMPT='%B%F{green}raphaele@%m:%F{blue}%~%F{white}%b$%F{reset} '

# SEARCH
bindkey -v
bindkey '^R' history-incremental-search-backward

# EDITOR
export EDITOR=vi

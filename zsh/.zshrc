# KEYMAPS 
source ~/.config/shell/alias.sh

# PLUGINS
source ~/Developer/dotfiles/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
source ~/Developer/dotfiles/zsh/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source ~/Developer/dotfiles/zsh/vi-mode/vi-mode.plugin.zsh

# DO NOT BE UGLY
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

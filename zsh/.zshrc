# No Comp Files
if [ -z "$ZSH_COMPDUMP" ]; then
  ZSH_COMPDUMP="${ZDOTDIR:-${ZSH}}/cache/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"
fi

# No Underlining
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Alias'
source ~/.config/shell/alias.sh
source ~/.config/shell/alias_exa.sh

# Syntax Highlighting
source ./.oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Theme
PROMPT="%B%F{green}raphaele@%m:%B%F{blue}%~%F{white}\$ "

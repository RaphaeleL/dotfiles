# export BASH_SILENCE_DEPRECATION_WARNING=1

# Default: \h:\W \u\$
export PS1='\[\e[01;32m\]raphaele@\h:\[\e[01;34m\]\w\[\e[0m\]\$ '
# export PS1='raphaele@\h:\[\e[01;32m\]\w\[\e[0m\]\$ '

export BASH_SILENCE_DEPRECATION_WARNING=1
export LDFLAGS="-L/opt/homebrew/opt/curl/lib"
export CPPFLAGS="-I/opt/homebrew/opt/curl/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/curl/lib/pkgconfig"
export LESSHISTFILE=-
export ZSH="$HOME/.oh-my-zsh"
export HISTFILE=${ZDOTDIR:-$HOME}/.cache/.zsh_history
export SHELL_SESSIONS_DISABLE=1
export PATH="$PATH:/Users/raphaelelicciardo/Library/Application Support/JetBrains/Toolbox/scripts"
export PATH="$PATH:/Users/raphaelelicciardo/.local/bin"
export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:$HOME/.local/share/nvim/mason/packages/jdtls/bin"
export PATH="$PATH:$HOME/.config/emacs/bin"
export ES_JAVA_HOME=$(/usr/libexec/java_home)

eval "$(/opt/homebrew/bin/brew shellenv)"

source ~/.config/shell/alias.sh
export EDITOR='vi'
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
export PATH="/opt/homebrew/opt/sphinx-doc/bin:$PATH"

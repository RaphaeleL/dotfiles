# Custom v1
export PS1='\[\e[01;32m\]raphaele@\h:\[\e[01;34m\]\w\[\e[0m\]\$ '
# Custom v2 
# export PS1='raphaele@\h:\[\e[01;32m\]\w\[\e[0m\]\$ '
# Default
# export PS1='\h:\W \u\$ '

# export BASH_SILENCE_DEPRECATION_WARNING=1
export BASH_SILENCE_DEPRECATION_WARNING=1
export LDFLAGS="-L/opt/homebrew/opt/curl/lib"
export CPPFLAGS="-I/opt/homebrew/opt/curl/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/curl/lib/pkgconfig"
export LESSHISTFILE=-
export HISTFILE=${ZDOTDIR:-$HOME}/.cache/.zsh_history
export SHELL_SESSIONS_DISABLE=1
export ES_JAVA_HOME=$(/usr/libexec/java_home)
export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:$HOME/.local/share/nvim/mason/packages/jdtls/bin"
export PATH="$PATH:$HOME/.config/emacs/bin"
export PATH="$PATH:$HOME/Developer"
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
export PATH="/opt/homebrew/opt/sphinx-doc/bin:$PATH"
export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"
export PATH="$HOME/Developer/apache-jena-fuseki-4.8.0:$PATH"
export EDITOR='vi'

eval "$(/opt/homebrew/bin/brew shellenv)"

source ~/.config/shell/alias.sh

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

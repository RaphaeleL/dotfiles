export BASH_SILENCE_DEPRECATION_WARNING=1
export LDFLAGS="-L/opt/homebrew/opt/curl/lib"
export CPPFLAGS="-I/opt/homebrew/opt/curl/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/curl/lib/pkgconfig"
export EDITOR=nvim
export LESSHISTFILE=-
export ZSH="$HOME/.oh-my-zsh"
export HISTFILE=${ZDOTDIR:-$HOME}/.cache/.zsh_history
export SHELL_SESSIONS_DISABLE=1
export PATH="$PATH:/Users/raphaelelicciardo/Library/Application Support/JetBrains/Toolbox/scripts"

eval "$(/opt/homebrew/bin/brew shellenv)"

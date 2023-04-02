export EDITOR='vim'
export BASH_SILENCE_DEPRECATION_WARNING=1

# export PS1='raphaele@macbook:\[\e[01;32m\]\w\[\e[0m\]\$ '
# export PS1='\[\e[01;32m\]\u@\h:\[\e[01;34m\]\w\[\e[0m\]\$ '
export PS1='\[\e[01;32m\]raphaele@\h:\[\e[01;34m\]\w\[\e[0m\]\$ '
export PATH=$PATH:/opt/homebrew/bin
export PATH="$PATH:/Users/raphaelelicciardo/Library/Application Support/JetBrains/Toolbox/scripts"
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

eval "$(/opt/homebrew/bin/brew shellenv)"

source ~/.config/shell/alias.sh
. "$HOME/.cargo/env"

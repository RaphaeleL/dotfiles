export BASH_SILENCE_DEPRECATION_WARNING=1

# export PS1='\u@\h:\[\e[01;32m\]\w\[\e[0m\]\$ '    # geohot
# export PS1="\[[ \[\u@\h :: \w ] "                 # lira1011
# export PS1='\u@\h:\w\$ '
export PS1="\[[ \[raphaele@macboo :: \W ] "

export EDITOR='vim'

export PATH=$PATH:/opt/homebrew/bin
eval "$(/opt/homebrew/bin/brew shellenv)"

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"


export PATH="$PATH:/Users/raphaelelicciardo/Library/Application Support/JetBrains/Toolbox/scripts"

# alias 
source ~/.config/shell/alias.sh
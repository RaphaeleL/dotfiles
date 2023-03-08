#!/bin/sh

# PROMPT='%{${FG[012]}%}[$(git_prompt_info)'
# PROMPT+=" %{${FG[249]}%}%n%{${FG[124]}%}@%{${FG[249]}%}%m%{${FG[106]}%} "
# PROMPT+=":: %{$FG[188]%}%~ %{${FG[012]}%}]%{${FG[249]}%} "
# ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[blue]%}:(%{$fg[red]%}"
# ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%})"
# ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

PROMPT='%{${FG[012]}%}[$(git_prompt_info)'
PROMPT+=" %{${FG[249]}%}raphaele%{${FG[124]}%}@%{${FG[249]}%}macbook%{${FG[106]}%} "
PROMPT+=":: %{$FG[188]%}%c %{${FG[012]}%}]%{${FG[249]}%} "
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

# %n -> username
# %~ -> fullpath
# %c -> current dir 

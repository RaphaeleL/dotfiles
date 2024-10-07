PROMPT="%{${FG[012]}%}[ "
PROMPT+='$(git_prompt_info)'
PROMPT+="%{${FG[249]}%}%n%{${FG[124]}%}@%{${FG[249]}%}%m%{${FG[106]}%} :: %{$FG[188]%}%~ %{${FG[012]}%}]%{${FG[249]}%} "

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

# PROMPT="%{%}[ "
# PROMPT+='$(git_prompt_info)'
# PROMPT+="%n@%m :: %~ ] "

# ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
# ZSH_THEME_GIT_PROMPT_DIRTY=""
# ZSH_THEME_GIT_PROMPT_CLEAN=""


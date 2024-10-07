PROMPT="%{%}[ "
PROMPT+='$(git_prompt_info)'
PROMPT+="%n@%m :: %~ ] "

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""


# --- ZSH ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(
    git
    zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh

(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST

# --- PROFILE ---

export PATH
export PATH="$HOME/bin:$PATH";
export PATH="$HOME/.local/bin:$PATH"

export EDITOR='nvim'

# --- ALIAS ---

# Basic
alias ger='echo "LANG=de_DE.UTF-8" | sudo tee /etc/locale.conf && setxkbmap de'
alias eng='echo "LANG=en_US.UTF-8" | sudo tee /etc/locale.conf && setxkbmap us'
alias grep='grep --color=always'
alias ls="ls --color=always -Ghp"
alias vim='nvim'
alias vi='/usr/bin/vim'

# Special Commands simplified
alias remove="shred -f -n 512 --remove -x -z"

# Custom Scripts
fh() { # Fuzzy History
  local cmd
  cmd=$(builtin fc -lnr 1 | fzf --height 40% --border --no-scrollbar --tac --no-mouse --pointer='' --no-info --prompt='' --marker='')

  if [[ -n $cmd ]]; then
    LBUFFER+="$cmd"
    zle reset-prompt
  fi
}
zle -N fh
bindkey "^R" fh

tms() { # Tmux Sessionizer
    if [[ -n "$1" ]]; then
        session_name="$1"
    else
        session_name=$(tmux list-sessions -F '#S' 2>/dev/null | fzf-tmux --height 40% --border --no-scrollbar --tac --no-mouse --pointer='' --no-info  --marker='' --prompt="Select tmux session: ")
        [[ -z "$session_name" ]] && return
    fi
    tmux has-session -t="$session_name" 2>/dev/null

    if [[ $? -ne 0 ]]; then
        TMUX='' tmux new-session -d -s "$session_name"
    fi

    if [[ -z "$TMUX" ]]; then
        tmux attach -t "$session_name"
    else
        tmux switch-client -t "$session_name"
    fi
}
_tms_complete() { # Tab Complete TMS with exisiting Tmux Sessions
    local -a sessions
    sessions=("${(@f)$(tmux list-sessions -F '#S' 2>/dev/null)}")
    compadd -a sessions
}
compdef _tms_complete tms

# --- OS Specific ---

if [[ "$(uname -s)" == "Darwin" ]]; then        # MacOS

    # Homebrew
    eval "$(/opt/homebrew/bin/brew shellenv)"

elif [[ "$(uname -s)" == "Linux" ]]; then       # Linux

    # Test for TRAMP Emacs
    if [[ $- != *i* ]]; then
        return
    fi

fi

# # --- GH Copilot ---
#
# ghcs() {
#         FUNCNAME="$funcstack[1]"
#         TARGET="shell"
# 	local GH_DEBUG="$GH_DEBUG"
# 	local GH_HOST="$GH_HOST"
#
# 	read -r -d '' __USAGE <<-EOF
# 	Wrapper around \`gh copilot suggest\` to suggest a command based on a natural language description of the desired output effort.
# 	Supports executing suggested commands if applicable.
#
# 	USAGE
# 	  $FUNCNAME [flags] <prompt>
#
# 	FLAGS
# 	  -d, --debug           Enable debugging
# 	  -h, --help            Display help usage
# 	      --hostname        The GitHub host to use for authentication
# 	  -t, --target target   Target for suggestion; must be shell, gh, git
# 	                        default: "$TARGET"
#
# 	EXAMPLES
#
# 	- Guided experience
# 	  $ $FUNCNAME
#
# 	- Git use cases
# 	  $ $FUNCNAME -t git "Undo the most recent local commits"
# 	  $ $FUNCNAME -t git "Clean up local branches"
# 	  $ $FUNCNAME -t git "Setup LFS for images"
#
# 	- Working with the GitHub CLI in the terminal
# 	  $ $FUNCNAME -t gh "Create pull request"
# 	  $ $FUNCNAME -t gh "List pull requests waiting for my review"
# 	  $ $FUNCNAME -t gh "Summarize work I have done in issues and pull requests for promotion"
#
# 	- General use cases
# 	  $ $FUNCNAME "Kill processes holding onto deleted files"
# 	  $ $FUNCNAME "Test whether there are SSL/TLS issues with github.com"
# 	  $ $FUNCNAME "Convert SVG to PNG and resize"
# 	  $ $FUNCNAME "Convert MOV to animated PNG"
# 	EOF
#
# 	local OPT OPTARG OPTIND
# 	while getopts "dht:-:" OPT; do
# 		if [ "$OPT" = "-" ]; then     # long option: reformulate OPT and OPTARG
# 			OPT="${OPTARG%%=*}"       # extract long option name
# 			OPTARG="${OPTARG#"$OPT"}" # extract long option argument (may be empty)
# 			OPTARG="${OPTARG#=}"      # if long option argument, remove assigning `=`
# 		fi
#
# 		case "$OPT" in
# 			debug | d)
# 				GH_DEBUG=api
# 				;;
#
# 			help | h)
# 				echo "$__USAGE"
# 				return 0
# 				;;
#
# 			hostname)
# 				GH_HOST="$OPTARG"
# 				;;
#
# 			target | t)
# 				TARGET="$OPTARG"
# 				;;
# 		esac
# 	done
#
# 	# shift so that $@, $1, etc. refer to the non-option arguments
# 	shift "$((OPTIND-1))"
#
# 	TMPFILE="$(mktemp -t gh-copilotXXXXXX)"
# 	trap 'rm -f "$TMPFILE"' EXIT
# 	if GH_DEBUG="$GH_DEBUG" GH_HOST="$GH_HOST" gh copilot suggest -t "$TARGET" "$@" --shell-out "$TMPFILE"; then
# 		if [ -s "$TMPFILE" ]; then
# 			FIXED_CMD="$(cat $TMPFILE)"
# 			print -s -- "$FIXED_CMD"
# 			echo
# 			eval -- "$FIXED_CMD"
# 		fi
# 	else
# 		return 1
# 	fi
# }
#
# ghce() {
# 	FUNCNAME="$funcstack[1]"
# 	local GH_DEBUG="$GH_DEBUG"
# 	local GH_HOST="$GH_HOST"
#
# 	read -r -d '' __USAGE <<-EOF
# 	Wrapper around \`gh copilot explain\` to explain a given input command in natural language.
#
# 	USAGE
# 	  $FUNCNAME [flags] <command>
#
# 	FLAGS
# 	  -d, --debug      Enable debugging
# 	  -h, --help       Display help usage
# 	      --hostname   The GitHub host to use for authentication
#
# 	EXAMPLES
#
# 	# View disk usage, sorted by size
# 	$ $FUNCNAME 'du -sh | sort -h'
#
# 	# View git repository history as text graphical representation
# 	$ $FUNCNAME 'git log --oneline --graph --decorate --all'
#
# 	# Remove binary objects larger than 50 megabytes from git history
# 	$ $FUNCNAME 'bfg --strip-blobs-bigger-than 50M'
# 	EOF
#
# 	local OPT OPTARG OPTIND
# 	while getopts "dh-:" OPT; do
# 		if [ "$OPT" = "-" ]; then     # long option: reformulate OPT and OPTARG
# 			OPT="${OPTARG%%=*}"       # extract long option name
# 			OPTARG="${OPTARG#"$OPT"}" # extract long option argument (may be empty)
# 			OPTARG="${OPTARG#=}"      # if long option argument, remove assigning `=`
# 		fi
#
# 		case "$OPT" in
# 			debug | d)
# 				GH_DEBUG=api
# 				;;
#
# 			help | h)
# 				echo "$__USAGE"
# 				return 0
# 				;;
#
# 			hostname)
# 				GH_HOST="$OPTARG"
# 				;;
# 		esac
# 	done
#
# 	# shift so that $@, $1, etc. refer to the non-option arguments
# 	shift "$((OPTIND-1))"
#
# 	GH_DEBUG="$GH_DEBUG" GH_HOST="$GH_HOST" gh copilot explain "$@"
# }

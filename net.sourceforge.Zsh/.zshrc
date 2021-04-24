# Lines configured by zsh-newuser-install
HISTFILE={{@@ zdotdir @@}}/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '{{@@ zdotdir @@}}/.zshrc'

# Enabling shell completions
fpath+=$ZDOTDIR/zfunc

autoload -Uz compinit
compinit
# End of lines added by compinstall
## Automatically decide when to page a list of completions
LISTMAX=100

# From `man zshparam`: "A list of non-alphanumeric characters considered part of a word by the line editor."
WORDCHARS='*?_[]~=&;!#$%^(){}<>:.-'  # Borrowed from github.com/zpm-zsh/core-config

##########################
# More completion settings
##########################
# The following were all borrowed from zpm-zsh/core-config
zstyle ':completion:*:processes' command 'NOCOLORS=1 ps -U $USER|sed "/ps/d"'
zstyle ':completion:*:processes' insert-ids menu yes select
zstyle ':completion:*:processes-names' command 'NOCOLORS=1 ps xho command|sed "s/://g"'
zstyle ':completion:*:processes' sort false
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'
zstyle '*' single-ignored show
zstyle ':completion:*:*:*:*:*' menu select  # Use an interactive menu when there are multiple completions
bindkey '^[[Z' reverse-menu-complete        # Shift+Tab goes backward in the completion menu
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'\
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:*:zcompile:*' ignored-patterns '(*~|*.zwc)'
zstyle ':completion:*:warnings' format "%{${c[red]}${c[bold]}%}No matches for:%{${c[yellow]}${c[bold]}%} %d"
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=36=31'
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion::complete:*' use-cache 1  # Enable a cache for shell completions
zstyle ':completion::complete:*' cache-path "${TMPDIR:-/tmp}/zsh-${UID}"

# From zpm-zsh/core-config: Load completion listing extensions
zmodload zsh/complist

# Enable colors
autoload -U colors
colors

# Make ctrl-left and ctrl-right go left and right by words
bindkey ';5D' backward-word
bindkey ';5C' forward-word

###############
# Shell Options
###############
# Spell check
setopt CORRECT
export SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color?
	[Yes, No, Abort, Edit] "

# Case-insensitive globbing
setopt NO_CASE_GLOB

# Allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

# History-related options
setopt APPEND_HISTORY           # Add to the history file instead of overwriting it every time
setopt INC_APPEND_HISTORY       # Incrementally write to the history file instead of waiting until you exit Zsh
setopt HIST_IGNORE_DUPS         # Don't store duplicate history commands
setopt HIST_FIND_NO_DUPS        # When searching through the command history don't show duplicates
setopt HIST_IGNORE_SPACE        # Remove commands from the history that begin with a space
setopt HIST_REDUCE_BLANKS       # Trim commands of whitespace before saving them in HISTFILE
setopt HIST_FCNTL_LOCK          # I don't really understand what this does but it seems useful
setopt HIST_VERIFY              # When invoking history with a !, check first before running the command
setopt SHARE_HISTORY            # For sharing history between zsh processes

# cd-ing related options
setopt AUTO_PUSHD        # Automatically push directories onto the directory stack
setopt PUSHD_IGNORE_DUPS # Don't add directories to the directory stack that are already on it
setopt PUSHD_MINUS       # From `man zshoptions`: "Exchanges the meanings of `+' and `-' when
                         # used with a number to specify a directory in the stack."
setopt PUSHD_SILENT      # From `man zshoptions`: "Do not print the directory stack after pushd or popd."
setopt PUSHD_TO_HOME     # Make `pushd` behave as `pushd $HOME` similar to how `cd` behaves as `cd $HOME`

# Allow comments even in interactive shells
setopt INTERACTIVE_COMMENTS

# Do not allow '>' to clear (truncate) files
unsetopt CLOBBER

###########
# Functions
###########
for fn in `ls $ZDOTDIR/zfunc`; do
  [[ $fn != _* ]] && autoload $fn
done

###############
# Miscellaneous
###############
# Automatically activate and deactivate Python virtualenv upon directory entry and exit
type add-zsh-hook &>/dev/null || autoload -Uz add-zsh-hook
autoload _python-workon-cwd
add-zsh-hook chpwd _python-workon-cwd

# Run ls when changing directories
add-zsh-hook chpwd lsGF

# Ignore these users (taken from github.com/zpm-zsh/ignored-users)
if [[ -e /etc/passwd ]]; then
  CACHE_FILE=$ZDOTDIR/ignored-users.zsh
  if [[ -f "$CACHE_FILE" ]]; then
    source "$CACHE_FILE"
  else
    ignored=( $(cat /etc/passwd | awk -F':' '($3<1000 && $3>0)||$3>10000{print $1}' | xargs) )
    zstyle ':completion:*:*:*:users' ignored-patterns $ignored
    echo "zstyle ':completion:*:*:*:users' ignored-patterns $ignored" >! "$CACHE_FILE" 2>/dev/null
    zcompile "$CACHE_FILE"
  fi
fi

####################
# Additional scripts
####################
source $ZDOTDIR/aliases.zsh   # Shell aliases
source $ZDOTDIR/bookmark.zsh  # Bookmark mechanism

# If a plugins script exists, then load these plugins
ZSH_PLUGINS=$ZDOTDIR/zsh_plugins.zsh
[[ -f $ZSH_PLUGINS ]] && source $ZSH_PLUGINS

# Only load these plugins if not logged a login shell
ZSH_PLUGINS_LOGIN=$ZDOTDIR/zsh_plugins_login.zsh
if [[ $0 != -zsh && -f $ZSH_PLUGINS_LOGIN ]]; then
  source $ZSH_PLUGINS_LOGIN
  # Needed for zsh-users/zsh-history-substring-search
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
fi

{%@@ if exists_in_path('broot') @@%}
# Broot
{%@@ if profile == 'macos' @@%}
source $HOME/Library/Preferences/org.dystroy.broot/launcher/bash/br
{%@@ else @@%}
source  $HOME/.config/broot/launcher/bash/br
{%@@ endif @@%}
{%@@ endif @@%}

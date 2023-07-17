# Lines configured by zsh-newuser-install
HISTFILE="$ZDOTDIR/.zsh_history"
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename "$ZDOTDIR/.zshrc"

# Enabling shell completions
fpath+="$ZDOTDIR/zfunc"

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

# Shell prompt
autoload -Uz promptinit
prompt redhat

# Make ctrl-left and ctrl-right go left and right by words
bindkey ';5D' backward-word
bindkey ';5C' forward-word

###############
# Shell Options
###############
setopt CORRECT                  # Spell check
export SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color?
	[Yes, No, Abort, Edit] "

setopt NO_CASE_GLOB             # Case-insensitive globbing

setopt COMPLETE_IN_WORD         # Allow tab completion in the middle of a word

# History-related options
setopt APPEND_HISTORY           # Add to the history file instead of overwriting it every time
setopt INC_APPEND_HISTORY       # Incrementally write to the history file instead of waiting until you exit Zsh
setopt HIST_IGNORE_DUPS         # Don't store duplicate history commands
setopt HIST_FIND_NO_DUPS        # When searching through the command history don't show duplicates
setopt HIST_IGNORE_SPACE        # Remove commands from the history that begin with a space
setopt HIST_REDUCE_BLANKS       # Trim commands of whitespace before saving them in HISTFILE
setopt HIST_FCNTL_LOCK          # Invoke fcntl() to lock the history file when writing to it
setopt HIST_VERIFY              # When invoking history with a !, check first before running the command
setopt SHARE_HISTORY            # For sharing history between zsh processes

# cd-ing related options
setopt AUTO_PUSHD               # Automatically push directories onto the directory stack
setopt PUSHD_IGNORE_DUPS        # Don't add directories to the directory stack that are already on it
setopt PUSHD_MINUS              # From `man zshoptions`: "Exchanges the meanings of `+' and `-' when
                                # used with a number to specify a directory in the stack."
setopt PUSHD_SILENT             # From `man zshoptions`: "Do not print the directory stack after pushd or popd."
setopt PUSHD_TO_HOME            # Make `pushd` behave as `pushd $HOME` similar to how `cd` behaves as `cd $HOME`

setopt INTERACTIVE_COMMENTS     # Allow comments even in interactive shells

unsetopt CLOBBER                # Do not allow '>' to clear (truncate) files

setopt NO_PROMPT_CR             # Do not overwrite the last line of output if it does not end with a newline
                                # (https://www.zsh.org/mla/workers/2000/msg03870.html)

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

####################
# Additional scripts
####################
source $ZDOTDIR/aliases.zsh   # Shell aliases
source $ZDOTDIR/bookmark.zsh  # Bookmark mechanism

{%@@ if exists_in_path('broot') @@%}
# Broot
{%@@ if profile == 'macos' @@%}
source $HOME/Library/Preferences/org.dystroy.broot/launcher/bash/br
{%@@ else @@%}
source $HOME/.config/broot/launcher/bash/br
{%@@ endif @@%}
{%@@ endif @@%}

##########################################################################################
# Zgenom - plugin manager
# Not installed by default...to install run
# git clone https://github.com/jandamm/zgenom.git "${ZGEN_DIR:-${ZDOTDIR:-${HOME}}/.zgen}"
##########################################################################################
[[ -z "$ZGEN_DIR" ]] && ZGEN_DIR="${ZDOTDIR:-${HOME}}/.zgen"
[[ -d "$ZGEN_DIR" ]] || return

# Needed for djui/alias-tips
export ZSH_PLUGINS_ALIAS_TIPS_TEXT='Found existing alias: '
export ZSH_PLUGINS_ALIAS_TIPS_EXCLUDES='_ fsh-alias'

# Needed for zsh-users/zsh-history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Source the init script created by zgenom
# This loads all the plugins specified in the "if ! zgen saved" block below
source "$ZGEN_DIR/zgenom.zsh"

# From the "example .zshrc" given in the README of the zgenom repository:
# Check for plugin and zgenom updates every 14 days
# This does not increase the startup time.
zgenom autoupdate 14

# If the init script exists, we are done.
# Otherwise, we will download and use the following themes/plugins/etc.
zgenom saved && return

zgenom load zsh-users/zsh-completions src --completion

zgenom loadall <<EOPLUGINS
  zpm-zsh/ls
  zpm-zsh/colorize
  zpm-zsh/ssh
  zpm-zsh/ignored-users
  zpm-zsh/dot
  zsh-users/zsh-completions
  djui/alias-tips
  agkozak/zsh-z
  zpm-zsh/clipboard
  zdharma-continuum/fast-syntax-highlighting
  zsh-users/zsh-history-substring-search
  zsh-users/autosuggestions
  zdharma-continuum/history-search-multi-word
EOPLUGINS

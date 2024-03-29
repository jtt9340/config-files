# This .zshrc requires zgenom, a program that makes it easy to manage Zsh plugins. If it is not installed, it will be installed.
[[ -d $ZGEN_DIR || -d $ZDOTDIR/zgen || -d $ZDOTDIR/.zgen || -d $HOME/.zgen ]] || {
  [[ -z "$ZGEN_DIR" ]] && ZGEN_DIR="${ZDOTDIR:-${HOME}}/.zgen"
  if whence git &>/dev/null; then
    git clone git@github.com:jandamm/zgenom.git "$ZGEN_DIR" 
  else
    echo "The zsh configuration you have loaded requires a program called zgenom (github.com/jandamm/zgenom)" >&2
    echo "to load all plugins, but zgenom was not found and git was not found to be able to clone and install it." >&2
    echo "Some functions may not work properly." >&2
  fi
}

#
# These are part of Oh-My-Zsh
#

# Display little red dots while waiting for Zsh to fill in a completion
COMPLETION_WAITING_DOTS=true
# This probably does something useful
DISABLE_UNTRACKED_FILES_DIRTY=true
# Make hyphens and underscores indistuinguishable completion-wise
HYPHEN_INSENSITIVE=true
# This technically isn't part of Oh-My-Zsh but I don't know where else to put this; it's part of djui/alias-tips
export ZSH_PLUGINS_ALIAS_TIPS_TEXT='Found existing alias: '
export ZSH_PLUGINS_ALIAS_TIPS_EXCLUDES='_ fsh-alias'

#
# Enabling shell completions
#
{%@@ if exists_in_path('brew') @@%}
fpath+=($(brew --prefix)/share/zsh/site-functions $ZDOTDIR/zfunc)
{%@@ else @@%}
fpath+=$ZDOTDIR/zfunc
{%@@ endif @@%}

#
# Source the init script created by zgenom
# This loads all the plugins specified in the "if ! zgen saved" block below 
#
source "$ZGEN_DIR/zgenom.zsh"

# From the "example .zshrc" given in the README of the zgenom repository:
# Check for plugin and zgenom updates every 14 days
# This does not increase the startup time.
zgenom autoupdate 14

# If the init script exists, skip the following.
# Otherwise, we will download and use the following themes/plugins/etc.
if ! zgenom saved; then
  # Per the zgenom documentation: "It's a good idea to load the base components before specifying any plugins"
  zgenom oh-my-zsh

  # Specify plugins part of oh-my-zsh
  whence git &>/dev/null && {
    zgenom oh-my-zsh plugins/git
    zgenom oh-my-zsh plugins/gitignore
  }
  whence pip &>/dev/null && zgenom oh-my-zsh plugins/pip
  whence rustc &>/dev/null && zgenom oh-my-zsh plugins/rust
  zgenom oh-my-zsh plugins/virtualenv
  whence docker &>/dev/null && zgenom oh-my-zsh plugins/docker
  whence rsync &>/dev/null && zgenom oh-my-zsh plugins/cp

  zgenom load zsh-users/zsh-completions

  # Aliases
  if [[ -f $ALIASRC ]]; then
    zgenom load $ALIASRC
  elif [[ -f $ZDOTDIR/aliases.zsh ]]; then
    zgenom load $ZDOTDIR/aliases.zsh
  elif [[ -f $HOME/.aliases.zsh ]]; then
    zgenom load $HOME/.aliases.zsh
  fi

  # Directory bookmark mechanism
  zgenom load $ZDOTDIR/bookmark.zsh

{%@@ if exists_in_path('broot') @@%}
  # Broot
{%@@ if profile == 'macos' @@%}
  zgenom load "$HOME/Library/Application Support/org.dystroy.broot/launcher/bash/br"
{%@@ else @@%}
  zgenom load $HOME/.config/broot/launcher/bash/br
{%@@ endif @@%}
{%@@ endif @@%}

  # So when you use `zsh-users/zsh-syntax-highlighting` it needs to be
  # sourced last. I'm not sure if that's the same for fast-syntax-highlighing,
  # but might as well adhere to that.
  zgenom loadall <<EOPLUGINS
    djui/alias-tips
    agkozak/zsh-z
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-history-substring-search
    zdharma-continuum/fast-syntax-highlighting
EOPLUGINS

  # Set the theme
  # TODO: figure out why this theme only sort-of works when using 'zgenom load', for now I am resorting back to
  # normal source
  # By 'sort-of works' I mean the variables declared with 'typeset +H' at the top of the joeys-avit file aren't
  # actually present 🤔 
  # zgenom load $ZDOTDIR/joeys-avit

  # Generate the init script from plugins above
  zgenom save
fi

{#@@
  The Oh-My-Zsh pip plugin automatically handles putting the zsh-cache file in a place
  so as to not clutter the home directory on GNU/Linux, so we only need this line on macOS.
@@#}
{%@@ if profile == 'macos' @@%}
# The Oh-My-Zsh pip plugin stores auto-completion data in this file
# (This line needs to be placed after the "source $ZGEN_DIR/zgen.zsh"/"if ! zgen saved" block above
# since the following variable needs to be set *after* the pip plugin is sourced.)
# And this variable is only set if the pip plugin is loaded at all.
if (($zsh_loaded_plugins[(Ie)ohmyzsh/ohmyzsh/plugins/pip])) || (($ZGEN_LOADED[(I)*pip*])); then
  ZSH_PIP_CACHE_FILE=$HOME/Library/Caches/pip/zsh-cache
fi
{%@@ endif @@%}

# See above TODO
ZSH_THEME_VIRTUALENV_PREFIX=⟨
ZSH_THEME_VIRTUALENV_SUFFIX=⟩
source $ZDOTDIR/joeys-avit.zsh-theme

###############
# Shell Options
###############
# Spell check
setopt correct
export SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color?
	[Yes, No, Abort, Edit] "

# Case-insensitive globbing
setopt NO_CASE_GLOB

#
# Miscellaneous
#

for fn in `ls $ZDOTDIR/zfunc`; do
  [[ $fn != _* ]] && autoload $fn
done

{%@@ if exists_in_path('brew') @@%}
# Command-not-found functionality for Homebrew
HB_CNF_HANDLER="$(brew --prefix)/Homebrew/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"
[ -f "$HB_CNF_HANDLER" ] && source "$HB_CNF_HANDLER"
{%@@ endif @@%}

# Automatically activate and deactivate Python virtualenv upon directory entry and exit
type add-zsh-hook &>/dev/null || autoload -Uz add-zsh-hook
autoload _python-workon-cwd
add-zsh-hook chpwd _python-workon-cwd

# Run ls when changing directories
add-zsh-hook chpwd lsGF

##############################################################################################################################
# This .zshrc requires Zgen, a program that makes it easy to manage Zsh plugins. If it is not installed, it will be installed.
##############################################################################################################################
[[ -d $ZGEN_DIR || -d $ZDOTDIR/zgen || -d $HOME/.zgen ]] || {
  [[ -z "$ZGEN_DIR" ]] && {
    [[ -n "$ZDOTDIR" ]] && ZGEN_DIR="${ZDOTDIR}/zgen" || ZGEN_DIR="${HOME}/.zgen"
  }
  # Use my custom fork of Zgen
  git clone git@github.com:jtt9340/zgen.git $ZGEN_DIR 
}

#############################
# These are part of Oh-My-Zsh
#############################
# Display little red dots while waiting for Zsh to fill in a completion
COMPLETION_WAITING_DOTS=true
# This probably does something useful
DISABLE_UNTRACKED_FILES_DIRTY=true
# Make hyphens and underscores indistuinguishable completion-wise
HYPHEN_INSENSITIVE=true
# Disable biweekly auto-update checks for Oh-My-Zsh; this is handled by the unixorn/autoupdate-zgen plugin below
DISABLE_AUTO_UPDATE=true
# This technically isn't part of Oh-My-Zsh but I don't know where else to put this; it's part of djui/alias-tips
export ZSH_PLUGINS_ALIAS_TIPS_TEXT='Found existing alias: '
export ZSH_PLUGINS_ALIAS_TIPS_EXCLUDES=_

############################
# Enabling shell completions
############################
type brew &>/dev/null \
  && fpath+=($(brew --prefix)/share/zsh/site-functions $ZDOTDIR/zfunc) \
  || fpath+=$ZDOTDIR/zfunc

###################################################################################################################
# Source the init script created by zgen; this loads all the plugins specified in the "if ! zgen saved" block below 
###################################################################################################################
source "$ZGEN_DIR/zgen.zsh"

######################################################################################################################
# If the init script exists, skip the following. Otherwise, we will download and use the following themes/plugins/etc.
######################################################################################################################
if ! zgen saved; then
  # Per the zgen documentation: "It's a good idea to load the base components before specifying any plugins"
  zgen oh-my-zsh

  # Specify plugins part of oh-my-zsh
  zgen oh-my-zsh plugins/git
  zgen oh-my-zsh plugins/cargo
  zgen oh-my-zsh plugins/rustup
  zgen oh-my-zsh plugins/virtualenv

  # Aliases
  if [[ -f $ALIASRC ]]; then
    zgen load $ALIASRC
  elif [[ -f $ZDOTDIR/aliases.zsh ]]; then
    zgen load $ZDOTDIR/aliases.zsh
  elif [[ -f $HOME/.aliases.zsh ]]; then
    zgen load $HOME/.aliases.zsh
  fi

  # Directory bookmark mechanism
  zgen load $ZDOTDIR/bookmark.zsh

  # Broot
  zgen load /Users/josephterrito/Library/Preferences/org.dystroy.broot/launcher/bash/br

  # So when you use `zsh-users/zsh-syntax-highlighting` it needs to be
  # sourced last. I'm not sure if that's the same for fast-syntax-highlighing,
  # but might as well adhere to that.
  zgen loadall <<EOPLUGINS
    djui/alias-tips
    agkozak/zsh-z
    unixorn/autoupdate-zgen
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-history-substring-search
    zdharma/fast-syntax-highlighting
EOPLUGINS

  # Set the theme
  # TODO: figure out why this theme only sort-of works when using 'zgen load', for now I am resorting back to
  # normal source
  # By 'sort-of works' I mean the variables declared with 'typeset +H' at the top of the joeys-avit file aren't
  # actually present 🤔 
  # zgen load $ZDOTDIR/joeys-avit

  # Generate the init script from plugins above
  zgen save
fi

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

###########
# Functions
###########
for fn in `ls $ZDOTDIR/zfunc`; do
  [[ $fn != _* ]] && autoload $fn
done

###############
# Miscellaneous
###############
# MANPATH="/usr/local/gnupg-2.2/share/man${MANPATH:+:$MANPATH}"
manpath=(/usr/local/gnupg-2.2/share/man $manpath)

# Command-not-found functionality for Homebrew
if type brew &>/dev/null; then
  HB_CNF_HANDLER="$(brew --prefix)/Homebrew/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"
  [ -f "$HB_CNF_HANDLER" ] && source "$HB_CNF_HANDLER"
fi

# Automatically activate and deactivate Python virtualenv upon directory entry and exit
type add-zsh-hook &>/dev/null || autoload -Uz add-zsh-hook
autoload _python-workon-cwd
add-zsh-hook chpwd _python-workon-cwd

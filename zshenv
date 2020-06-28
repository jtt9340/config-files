##################################
# XDG Base Directory Specification
##################################
[ -z "$XDG_DATA_HOME" ] && export XDG_DATA_HOME="$HOME/Library"
[ -z "$XDG_CONFIG_HOME" ] && export XDG_CONFIG_HOME="$HOME/Library/Preferences"

[ -z "$XDG_DATA_DIRS" ] && export XDG_DATA_DIRS='/usr/local/share/:/usr/share/'
[ -z "$XDG_CACHE_HOME" ] && export XDG_CACHE_HOME="$HOME/Library/Caches"

########################################################################################################################
# The following code segment was graciously adapted from the Prezto Homebrew plugin; the reason I am not just sourcing
# that plugin is becuase it would require loading the code necessary for Prezto, much of which I will not, at present,
# use or take advantage of.
########################################################################################################################
# Load standard Homebrew shellenv into the shell session.
# Load 'HOMEBREW_' prefixed vairables only. Avoid loading 'PATH' related
# variables as thay are already handled in standard Zsh configuration.
(( $+commands[brew] )) && eval "${(@M)${(f)"$(brew shellenv 2> /dev/null)"}:#export HOMEBREW*}"

####################################################################################################
# Reconfiguring programs to store their configuation/data files somewhere besides the home directory
####################################################################################################

# Moving the file that saves history from interactive python sessions
export PYTHONSTARTUP="$XDG_CONFIG_HOME"/python_startup

# Setting PATH for Rust and telling Cargo and rustup where their dotfiles are
export RUSTUP_HOME="$XDG_DATA_HOME/Rustup"
export CARGO_HOME="$XDG_DATA_HOME/Cargo"
export PATH="$PATH:$CARGO_HOME/bin"

# Tell Zsh to make all files in this directory
export ZDOTDIR="$XDG_CONFIG_HOME/net.sourceforge.zsh.Zsh"
export ZGEN_DIR="$ZDOTDIR/zgen"
export ZGEN_SYSTEM_RECEIPT_F="${${ZDOTDIR}#${HOME}}/.zgen_system_lastupdate"
export ZGEN_PLUGIN_RECEIPT_F="${${ZDOTDIR}#${HOME}}/.zgen_plugin_lastupdate"

# Tell GnuPG where its dotfiles are
export GNUPGHOME="$XDG_DATA_HOME/GnuPG"

# Tell the Android SDK where its dotfiles are (why do I even have the Android SDK?)
export ANDROID_SDK_HOME="$XDG_CONFIG_HOME/Android"

# Tell the zsh-z plugin where it store its database so as to not pollute the home directory
export _Z_DATA="$XDG_DATA_HOME/z"

# Tell Vim where its config file is
export VIMINIT='source \$XDG_CONFIG_HOME/org.vim.Vim/vimrc'

# gem, the Ruby package manager
export GEM_HOME="$XDG_DATA_HOME"/Gem
export GEM_SPEC_CACHE="$XDG_CACHE_HOME"/Gem

# npm
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/com.npmjs.Npm/npmrc
export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history

# Store less' files somewhere besides the home directory
export LESSKEY="$XDG_CONFIG_HOME"/Less/lesskey
export LESSHISTFILE="$XDG_CACHE_HOME"/Less/history

# Tell dotdrop where its config.yaml is
[ "$(uname)" = "Darwin" ] && export DOTDROP_CONFIG="$XDG_CONFIG_HOME"/re.deadc0de.dotdrop/config.yaml

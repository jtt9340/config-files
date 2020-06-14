##################################
# XDG Base Directory Specification
##################################
[ -z "$XDG_DATA_HOME" ] && export XDG_DATA_HOME="$HOME/Library"
[ -z "$XDG_CONFIG_HOME" ] && export XDG_CONFIG_HOME="$HOME/Library/Preferences"

[ -z "$XDG_DATA_DIRS" ] && export XDG_DATA_DIRS='/usr/local/share/:/usr/share/'
[ -z "$XDG_CACHE_HOME" ] && export XDG_CACHE_HOME="$HOME/Library/Caches"

####################################################################################################
# Reconfiguring programs to store their configuation/data files somewhere besides the home directory
####################################################################################################

# Setting PATH for Rust and telling Cargo and rustup where their dotfiles are
export RUSTUP_HOME="$XDG_DATA_HOME/Rustup"
export CARGO_HOME="$XDG_DATA_HOME/Cargo"
export PATH="$PATH:$CARGO_HOME/bin"

# Tell ZSH to make all files in this directory
export ZDOTDIR="$XDG_CONFIG_HOME/net.sourceforge.zsh.Zsh"
export ZGEN_DIR="$ZDOTDIR/zgen"

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

# Store less' files somewhere besides the home directory
export LESSKEY="$XDG_CONFIG_HOME"/Less/lesskey
export LESSHISTFILE="$XDG_CACHE_HOME"/Less/history

# Tell dotdrop where its config.yaml is
[ "$(uname)" = "Darwin" ] && export DOTDROP_CONFIG="$XDG_CONFIG_HOME"/re.deadc0de.dotdrop/config.yaml

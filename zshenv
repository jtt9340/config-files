# XDG Base Directory Specification
[ -z "$XDG_DATA_HOME" ] && export XDG_DATA_HOME="$HOME/.local/share"
[ -z "$XDG_CONFIG_HOME" ] && export XDG_CONFIG_HOME="$HOME/.config"

[ -z "$XDG_DATA_DIRS" ] && export XDG_DATA_DIRS='/usr/local/share/:/usr/share/'
[ -z "$XDG_CACHE_HOME" ] && export XDG_CACHE_HOME="$HOME/.cache"

####################################################################################################
# Reconfiguring programs to store their configuation/data files somewhere besides the home directory
####################################################################################################

# Setting PATH for Rust and telling Cargo and rustup where their dotfiles are
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export PATH="$PATH:$CARGO_HOME/bin"

# Tell ZSH to make all files in this directory
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Tell GnuPG where its dotfiles are
export GNUPGHOME="$XDG_DATA_HOME/gnupg"

# Tell the Android SDK where its dotfiles are (why do I even have the Android SDK?)
export ANDROID_SDK_HOME="$XDG_CONFIG_HOME/android"

# Tell the zsh-z plugin where it store its database so as to not pollute the home directory
export _Z_DATA="$XDG_DATA_HOME/z"

# Tell Vim where its config file is
export VIMINIT='source \$XDG_CONFIG_HOME/vim/vimrc'

# Store less' files somewhere besides the home directory
export LESSKEY="$XDG_CONFIG_HOME"/less/lesskey
export LESSHISTFILE="$XDG_CACHE_HOME"/less/history

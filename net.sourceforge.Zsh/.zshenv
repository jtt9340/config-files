# Discard duplicates from PATH and FPATH
typeset -U PATH path FPATH fpath

# Move the $HOME/.cargo directory somewhere else
export CARGO_HOME="$HOME/Library/Application Support/Cargo"
path+=($CARGO_HOME/bin $HOME/Library/Application\ Support/com.npmjs.Npm/bin)

# Tell Zsh to make all files in this directory
export ZDOTDIR="$HOME/Library/Application Support/net.sourceforge.Zsh"

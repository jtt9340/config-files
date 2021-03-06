# Discard duplicates from PATH and FPATH
typeset -U PATH path FPATH fpath

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi

{%@@ if exists_in_path('cargo') @@%}
# Move the $HOME/.cargo directory somewhere else
{%@@ if profile == 'macos' @@%}
export CARGO_HOME="$HOME/Library/Application Support/Cargo"
path+=($CARGO_HOME/bin $HOME/Library/Application\ Support/com.npmjs.Npm/bin /usr/local/sbin)
{%@@ else @@%}
if [[ -n $XDG_DATA_HOME ]]; then
  export CARGO_HOME="$XDG_DATA_HOME"/cargo
elif [[ -d $HOME/.local/share ]]; then
  export CARGO_HOME=$HOME/.local/share/cargo
fi
{%@@ endif @@%}
{%@@ endif @@%}

{%@@ if exists_in_path('pipx') @@%}
export PIPX_HOME={{@@ user_base() | shellescape @@}}
export PIPX_BIN_DIR="$PIPX_HOME/bin"
path+="$PIPX_BIN_DIR"
{%@@ endif @@%}

# Tell Zsh to make all files in this directory
{%@@ if profile == 'macos' @@%}
export ZDOTDIR="$HOME/Library/Application Support/net.sourceforge.Zsh"
{%@@ else @@%}
[[ -n $XDG_CONFIG_HOME ]] \
  && export ZDOTDIR="$XDG_CONFIG_HOME"/zsh \
  || export ZDOTDIR="$HOME/.zsh"
{%@@ endif @@%}

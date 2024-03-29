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
{%@@ else @@%}
if [[ -n $XDG_DATA_HOME ]]; then
  export CARGO_HOME="$XDG_DATA_HOME"/cargo
elif [[ -d $HOME/.local/share ]]; then
  export CARGO_HOME=$HOME/.local/share/cargo
fi
{%@@ endif @@%}
{%@@ endif @@%}

{%@@ if profile == 'macos' and exists_in_path('ghcup') @@%}
export GHCUP_INSTALL_BASE_PREFIX="$HOME/Library/Application Support"
{%@@ endif @@%}

{#@@ Conditions for setting PATH on macOS that can be checked at dotfile install time @@#}
{%@@ if profile == 'macos' @@%}
path+=(
  /usr/local/sbin
{%@@ if exists_in_path('cargo') @@%}
  "$CARGO_HOME/bin"
{%@@ endif @@%}
{%@@ if exists_in_path('npm') @@%}
  "$HOME/Library/Application Support/com.npmjs.Npm/bin"
{%@@ endif @@%}
{%@@ if exists_in_path('ghcup') @@%}
  "$GHCUP_INSTALL_BASE_PREFIX/.ghcup/bin"
{%@@ endif @@%}
)
{%@@ endif @@%}

# Tell Zsh to make all files in this directory
{%@@ if profile == 'macos' @@%}
export ZDOTDIR="$HOME/Library/Application Support/net.sourceforge.Zsh"
{%@@ else @@%}
if [[ -n $XDG_CONFIG_HOME ]]; then
  export ZDOTDIR="$XDG_CONFIG_HOME"/zsh
elif [[ -d $HOME/.config ]]; then
  export ZDOTDIR=$HOME/.config/zsh
else
  export ZDOTDIR="$HOME/.zsh"
fi
{%@@ endif @@%}

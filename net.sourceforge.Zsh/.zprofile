{%@@ if os == 'Darwin' @@%}
##############
# Setting PATH
##############
# So macOS has this thing called path_helper that modifies PATH *after*
# .zshenv is sourced, which is fine except I would like the following to be
# at the front of PATH. I suppose I have several options: I could add the
# following to .zshrc, but .zshrc is only sourced on interactive shells
# (is that a problem for python3 and llvm?); I could also create aliases
# so that "python3" refers to, e.g. /usr/local/opt/python@3.8/bin/python3
# instead of /usr/local/bin/python3, but aliases don't feel like a robust
# solution to me. Oh well. I decided to see if modifying PATH here in .zpofile
# solves my problem.
##############

# Setting PATH for Python 3.8
# The original version is saved in .bash_profile.pysave
# And also use a version of LLVM that supports LeakSanitizer
# export PATH="/usr/local/opt/python@3.8/bin:${PATH}"
path=(/usr/local/opt/python@3.8/bin /usr/local/opt/llvm/bin $path)
# export PATH="/usr/local/opt/llvm/bin:$PATH"
{%@@ endif @@%}

# Other environment variables that don't need to be set in ${ZDOTDIR:-$HOME} 

{%@@ if exists_in_path('brew') @@%}
# The following code segment was graciously adapted from the Prezto Homebrew plugin; the reason I am not just sourcing
# that plugin is becuase it would require loading the code necessary for Prezto, much of which I will not, at present,
# use or take advantage of.

# Load standard Homebrew shellenv into the shell session.
# Load 'HOMEBREW_' prefixed vairables only. Avoid loading 'PATH' related
# variables as thay are already handled in standard Zsh configuration.
eval "${(@M)${(f)"$(brew shellenv 2> /dev/null)"}:#export HOMEBREW*}"
{%@@ endif @@%}

# Reconfiguring programs to store their configuation/data files somewhere besides the home directory
{#@@ Rustup @@#}
{%@@ if exists_in_path('rustup') @@%}
# Move $HOME/.rustup somewhere else
{%@@ if os == 'Darwin' @@%}
export RUSTUP_HOME="$HOME/Library/Application Support/Rustup"
{%@@ else @@%}
[[ -n $XDG_DATA_HOME ]] && export RUSTUP_HOME=$XDG_DATA_HOME/rustup 
{%@@ endif @@%}
{%@@ endif @@%}

# Tell Zsh to make all files in this directory
export ZGEN_DIR=$ZDOTDIR/zgen
export ZGEN_SYSTEM_RECEIPT_F=${${ZDOTDIR}#${HOME}}/zgen_system_lastupdate
export ZGEN_PLUGIN_RECEIPT_F=${${ZDOTDIR}#${HOME}}/zgen_plugin_lastupdate
export _Z_DATA=$ZDOTDIR/z.txt

{#@@ GPG @@#}
{%@@ if exists_in_path('gpg') @@%}
# Tell GnuPG where its dotfiles are
{%@@ if os == 'Darwin' @@%}
export GNUPGHOME="$HOME/Library/Application Support/GnuPG"
{%@@ else @@%}
[[ -n $XDG_DATA_HOME ]] && export GNUPGHOME=$XDG_DATA_HOME/gnupg
{%@@ endif @@%}
{%@@ endif @@%}

{#@@ Android SDK @@#}
{%@@ if os == 'Darwin' @@%}
# Tell the Android SDK where its dotfiles are (why do I even have the Android SDK?)
export ANDROID_SDK_HOME="$HOME/Library/Application Support/Android"
{%@@ endif @@%}

{#@@ Vim @@#}
{%@@ if exists_in_path('vim') @@%}
# Tell Vim where its config file is
{%@@ if os == 'Darwin' @@%}
export VIMINIT='source \$HOME/Library/Application\ Support/org.vim.Vim/vimrc'
{%@@ else @@%}
if [[ -n $XDG_CONFIG_HOME && -f $XDG_CONFIG_HOME/vim/vimrc ]]; then
  export VIMINIT='source \$XDG_CONFIG_HOME/vim/vimrc'
elif [[ -f $HOME/.config/vim/vimrc ]]; then
  export VIMINIT='source \$HOME/.config/vim/vimrc'
fi
{%@@ endif @@%}
{%@@ endif @@%}

{#@@ gem and npm @@#}
{%@@ if os == 'Darwin' @@%}
# gem, the Ruby package manager
export GEM_HOME="$HOME/Library/Application Support/Gem"
export GEM_SPEC_CACHE=$HOME/Library/Caches/Gem

# npm
export NPM_CONFIG_USERCONFIG="$HOME/Library/Application Support/com.npmjs.Npm/npmrc"
export NODE_REPL_HISTORY="$HOME/Library/Application Support/com.npmjs.Npm/node_repl_history"
{%@@ endif @@%}

{#@@ less @@#}
{%@@ if exists_in_path('less') @@%}
# Store less' files somewhere besides the home directory
{%@@ if os == 'Darwin' @@%}
export LESSKEY="$HOME/Library/Application Support/Less/lesskey"
export LESSHISTFILE=$HOME/Library/Caches/Less/history
{%@@ else @@%}
if [[ -n $XDG_CONFIG_HOME ]]; then
  export LESSKEY=$XDG_CONFIG_HOME/less/lesskey
else
  export LESSKEY=$HOME/.config/less/lesskey
fi

if [[ -n $XDG_CACHE_HOME ]]; then
  export LESSHISTFILE=$XDG_CACHE_HOME/less/history
else
  export LESSHISTFILE=$HOME/.cache/less/history
fi
{%@@ endif @@%}
{%@@ endif @@%}

{#@@ ripgrep @@#}
{%@@ if exists_in_path('rg') @@%}
# Tell ripgrep where it's configuration file is
export RIPGREP_CONFIG_PATH={{@@ env['HOME'] + '/Library/Application\ Support/com.github.burntsushi.Ripgrep/ripgreprc' if os == 'Darwin'
                                else env['XDG_CONFIG_HOME'] + '/ripgreprc' if env['XDG_CONFIG_HOME'] is string
                                else env['HOME'] + '/.config/ripgreprc'
                           @@}}
{%@@ endif @@%}

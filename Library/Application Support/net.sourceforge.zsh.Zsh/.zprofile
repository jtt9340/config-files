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

# Other environment variables that don't need to be set in ${ZDOTDIR:-$HOME} 

# The following code segment was graciously adapted from the Prezto Homebrew plugin; the reason I am not just sourcing
# that plugin is becuase it would require loading the code necessary for Prezto, much of which I will not, at present,
# use or take advantage of.

# Load standard Homebrew shellenv into the shell session.
# Load 'HOMEBREW_' prefixed vairables only. Avoid loading 'PATH' related
# variables as thay are already handled in standard Zsh configuration.
(( $+commands[brew] )) && eval "${(@M)${(f)"$(brew shellenv 2> /dev/null)"}:#export HOMEBREW*}"

# Reconfiguring programs to store their configuation/data files somewhere besides the home directory

# Move $HOME/.rustup somewhere else
export RUSTUP_HOME="$HOME/Library/Application Support/Rustup"

# Tell Zsh to make all files in this directory
export ZGEN_DIR=$ZDOTDIR/zgen
export ZGEN_SYSTEM_RECEIPT_F=${${ZDOTDIR}#${HOME}}/zgen_system_lastupdate
export ZGEN_PLUGIN_RECEIPT_F=${${ZDOTDIR}#${HOME}}/zgen_plugin_lastupdate
export _Z_DATA=$ZDOTDIR/z.txt

# Tell GnuPG where its dotfiles are
export GNUPGHOME="$HOME/Library/Application Support/GnuPG"

# Tell the Android SDK where its dotfiles are (why do I even have the Android SDK?)
export ANDROID_SDK_HOME="$HOME/Library/Application Support/Android"

# Tell Vim where its config file is
export VIMINIT='source \$HOME/Library/Application\ Support/org.vim.Vim/vimrc'

# gem, the Ruby package manager
export GEM_HOME="$HOME/Library/Application Support/Gem"
export GEM_SPEC_CACHE=$HOME/Library/Caches/Gem

# npm
export NPM_CONFIG_USERCONFIG="$HOME/Library/Application Support/com.npmjs.Npm/npmrc"
export NODE_REPL_HISTORY="$HOME/Library/Application Support/com.npmjs.Npm/node_repl_history"

# Store less' files somewhere besides the home directory
export LESSKEY="$HOME/Library/Application Support/Less/lesskey"
export LESSHISTFILE=$HOME/Library/Caches/Less/history

# Tell dotdrop where its config.yaml is
export DOTDROP_CONFIG="$HOME/Library/Application Support/re.deadc0de.dotdrop/config.yaml"

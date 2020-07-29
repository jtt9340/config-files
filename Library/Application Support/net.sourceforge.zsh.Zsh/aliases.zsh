#########
# Aliases
#########
# For quickly editing configuration files
alias zshconfig="${EDITOR:-vim} ${(q)ZDOTDIR:-$HOME}/.zshrc"
alias vimconfig="${EDITOR:-vim} ${(q)XDG_CONFIG_HOME:-$HOME/Library/Application Support}/org.vim.Vim/vimrc"
alias brootconfig="${EDITOR:-vim} $HOME/Library/Preferences/org.dystroy.broot/conf.toml"

# ls aliases
(( $+commands[lsd] )) && {
  alias lsdl='lsd -lF --date relative'
  alias lsda='lsd -aF'
  alias lsdla='lsd -laF --date relative'
  alias ltree='lsd --tree'
}

alias ldot='ls -d .*'
alias lab='ls -AbFG'

(( $+commands[broot] )) && {
  alias tree='br --cmd :pt'
  alias lbr='br -sdp'
}

if type brew &>/dev/null; then
  # These aliases are graciously taken from the Prezto Homebrew plugin; I have decided not to add the plugin to the above "if
  # ! zgen saved" block becuase that would require sourcing Prezto and adding a lot of code to my shell startup that I
  # wouldn't use
  alias brewc='brew cleanup' # cleans outdated brews and their cached archives
  alias brewi='brew install' # installs a formula
  alias brewL='brew leaves' # lists installed formulae that are not dependencies of another installed formula
  alias brewl='brew list' # lists installed formulae
  alias brewo='brew outdated' # lists brews which have an update available
  alias brews='brew search' # searched for a formula
  alias brewu='brew upgrade' # updates and upgrdes Homebrew packages and formulae
  alias brewx='brew uninstall' # uninstalls a formula

  # brew cask
  alias cask='brew cask'
  alias caskc='brew cleanup' # same as brew cleanup
  alias caski='brew cask install' # installs a cask
  alias caskl='brew cask list' # lists installed casks
  alias casko='brew cask outdated' # lists casks which have an update available
  alias casks='brew search --casks' # same as brew search 
  alias caskx='brew cask uninstall' # uninstalls a cask
fi

# Global aliases - proceed with caution
alias -g C='| wc -l'
alias -g H='| head'
alias -g T='| tail'
alias -g L="| ${PAGER-less}"
alias -g G='| grep -n'
alias -g NUL='> /dev/null 2>&1'
alias -g 'TRUE?'='&& echo true || echo false'

# Make some commands more verbose
alias rm='rm -v'
alias mv='mv -v'
alias diff='diff -s'
alias cp='cp -v'


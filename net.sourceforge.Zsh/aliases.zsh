#########
# Aliases
#########
# For quickly editing configuration files
alias zshconfig="${EDITOR:-vim} ${(q)ZDOTDIR:-$HOME}/.zshrc"
{%@@ if exists_in_path('vim') and profile == 'macos' @@%}
alias vimconfig="${EDITOR:-vim} $HOME/Library/Application\ Support/org.vim.Vim/vimrc"
{%@@ elif exists_in_path('vim') @@%}
if [[ -n $XDG_CONFIG_HOME && -f $XDG_CONFIG_HOME/vim/vimrc ]]; then
  alias vimconfig="${EDITOR:-vim} $XDG_CONFIG_HOME/vim/vimrc}"
elif [[ -f $HOME/.vim/vimrc ]]; then
  alias vimconfig="${EDITOR:-vim} $HOME/.vim/vimrc"
else
  alias vimconfig="${EDITOR:-vim} $HOME/.vimrc"
fi
{%@@ endif @@%} 
{%@@ if exists_in_path('broot') and profile == 'macos' @@%}
alias brootconfig="${EDITOR:-vim} $HOME/Library/Preferences/org.dystroy.broot/conf.toml"
{%@@ elif exists_in_path('broot') @@%}
if [[ -n $XDG_CONFIG_HOME ]]; then
  alias brootconfig="${EDITOR:-vim} $XDG_CONFIG_HOME/broot/conf.toml"
else
  alias brootconfig="${EDITOR:-vim} $HOME/.config/broot/conf.toml"
fi
{%@@ endif @@%}

# ls aliases
alias ldot='ls -d .*'
alias lab='ls -AbFG'
alias d='dirs -v'
{%@@ if exists(env['HOME'] + '/Library/Application Support/org.dystroy.broot/launcher/bash/1') or
        exists(env.get('XDG_DATA_HOME', default='') + '/broot/launcher/bash/1') or 
        exists(env['HOME'] + '/.local/share/broot/launcher/bash/1') @@%}
alias lbr='br -sdp'
{%@@ endif @@%}

{%@@ if exists_in_path('lsd') @@%}
alias lsdl='lsd -lF --date relative'
alias lsda='lsd -aF'
alias lsdla='lsd -laF --date relative'
{%@@ endif @@%}

{%@@ if exists(env['HOME'] + '/Library/Application Support/org.dystroy.broot/launcher/bash/1') or
        exists(env.get('XDG_DATA_HOME', default='') + '/broot/launcher/bash/1') or 
        exists(env['HOME'] + '/.local/share/broot/launcer/bash/1') @@%}
alias tree='br --cmd :pt'
{%@@ endif @@%}
{%@@ if exists_in_path('lsd') @@%}
alias ltree='lsd --tree'
{%@@ endif @@%}

alias g=git
# Convert Git aliases into shell aliases
IFS='
'
for galias in `git config --global --list`; do
  if [[ $galias =~ ^alias\. ]]; then
    galias=$(echo $galias | cut -c 7-)
    galias_key=$(echo $galias | cut -d = -f 1)
    galias_value=$(echo $galias | cut -d = -f 2)
    alias "g$galias_key"="git $galias_value"
  fi
done

{%@@ if exists_in_path('brew') @@%}
# These aliases are graciously taken from the Prezto Homebrew plugin; I have decided not to add the plugin
# becuase that would require sourcing Prezto and adding a lot of code to my shell startup that I
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
alias caski='brew install --cask' # installs a cask
alias caskl='brew list --cask' # lists installed casks
alias casko='brew outdated --cask' # lists casks which have an update available
alias casks='brew search --casks' # same as brew search 
alias caskx='brew uninstall --cask' # uninstalls a cask
{%@@ endif @@%}

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
{%@@ if profile == "macos" @@%}
alias diff='diff -s'
{%@@ else @@%}
alias diff='diff -s --color=always'
{%@@ endif @@%}
alias cp='cp -v'


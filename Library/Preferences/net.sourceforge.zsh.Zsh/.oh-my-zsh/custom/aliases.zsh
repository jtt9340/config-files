# Basic aliases
# This alias is no longer necessary since I no longer have oh-my-zsh randomly pick a theme for me
# alias theme="echo \$RANDOM_THEME"

alias ls="ls -abFG"
alias l="ls -l"
# alias glgg="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"

# Make some commands a little more verbose
alias rm="rm -v"
alias mv="mv -v"
alias cp="cp -v"
alias diff="diff -s"

# Use the version of Vim installed by Homebrew, not the one Apple shipped
alias vim="/usr/local/Cellar/vim/8.2.0750/bin/vim"

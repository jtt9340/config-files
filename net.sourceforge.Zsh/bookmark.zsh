# vim: set filetype=zsh :

# This script was graciosuly taken from vincentbernat's .zshrc per his permission
# as specified in the GitHub repository README (github.com/vincentbernat/zshrc/blob/master/README.md):
# "Feel free to read and understand. Steal anything."

# Handle bookmarks. This uses the static named directories feature of
# Zsh. Such directories are declared with `hash -d name=directory`.
# Both prompt expansion and completion know how to handle them.

# The directory to store Zsh bookmarks.
MARKPATH=$ZDOTDIR/bookmarks

# Populate the hash
for link ($MARKPATH/*(N@)) {
  hash -d -- ${link:t}=${link:A}
} 

function bookmark {
  [[ -d $MARKPATH ]] || mkdir -p $MARKPATH
  if (( $# == 0 )); then
    # When no arguments are provided just display existing bookmarks
    for link in $MARKPATH/*(N@); do
      local markname="$fg[green]${link:t}$reset_color"
      local markpath="$fg[cyan]${link/${HOME}/~}$reset_color"
      printf "%-30s -> %s\n" $markname $markpath
    done
  else
     # Othwerwise, we may want to add a bookmark or delete an existing one
    local -a delete
    zparseopts -D d=delete
    if (( $+delete[1] )); then
      # With `-d`, we delete an existing bookmark
      command rm -v $MARKPATH/$1        
    else
      # Otherwise, add a bookmark to the current directory.
      # the first argument is the bookmark name. `.` is special
      # and means the bookmark should be named after the current
      # directory.
      local name=$1
      [[ $name == "." ]] && name=${PWD:t}
      ln -s $PWD $MARKPATH/$name
      hash -d -- ${name}=${PWD}
    fi
  fi
}

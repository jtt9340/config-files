# Broot
[Broot](https://dystroy.org/broot/) is a command-line file browser. This difference between Broot and something
like [Ranger](https://ranger.github.io/index.html) is that Broot gives you a tree-like view of your filesystem
as opposed to a column-like view, and Broot supports fuzzy file searching. It would be cool one day if there was
a program that combined both views and let you switch back and forth between them, but for now I use Broot.

The config file in this directory is a modification of the default one installed by Broot. It changes a few of the
keybindings, and adds a few new "verbs", Broot's name for commands:

- `:gd` - Show a git diff of the currently selected file
- `:bat` - Open the currently selected file in [bat](../com.github.sharkdp.Bat/README.md)
- `:trash` - Moves the currently selected file to the trash (as opposed to permanently deleting it,
   requires a program with a `trash` binary to provide this functionality)
- `:zshconfig` - Open my [`.zshrc`](../net.sourceforge.Zsh/README.md) in the default command line text editor
- `:vimconfig` - Open my [`.vimrc`](../org.vim.Vim/README.md) in the default command line text editor
- `:brootconfig` - Open my [`conf.toml`](./conf.toml) in the default command line text editor
- `:ql` - Use macOS' Quick Look feature to preview the currently selected file 

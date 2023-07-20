# Zsh

[Zsh][zsh] is a UNIX shell with syntax similar to and compatible with Bash. It has lots of features that
let you do all sorts of crazy things. Most people aren't intimately familiar with the inner workings of Zsh.
However, some Zsh wizards have leveraged Zsh's features to add syntax highlighting at the command line,
interactive fuzzy search in history, autosuggestions for commands, and more. This is what everyone uses
when they use Zsh, and it's gotten so out of control Zsh users started writing programs to download and
install Zsh scripts that add this functionality for you and call them "plugin managers". Then we started
writing more plugin managers because the already existing ones weren't sufficient, and now
[there is a whole discussion on Reddit](https://www.reddit.com/r/zsh/comments/ak0vgi/a_comparison_of_all_the_zsh_plugin_mangers_i_used/?utm_source=share&utm_medium=web2x&context=3)
about which plugin manager to use: which is the easiest, which is the most featureful, which is the fastest, etc.

Zsh is definitely the C++ of UNIX shells: complicated to get started with, but once you get used to it and
leverage its features, it becomes very powerful.

I have broken down my Zsh config by file: Zsh has a specific startup sequence and crtieria for when it sources
each file.

## [`.zshenv`](.zshenv)
This file is always sourced, so it is best to keep it minimal. Mine just sets some environment variables.

## [`.zprofile`](.zprofile)
This file is sourced when Zsh is started as a login shell. Mine just sets some more environment variables
that I felt didn't need to be set in `.zshenv`.

## [`.zshrc`](.zshrc)
This is the meat and potatoes of my Zsh configuration. `.zshrc` is sourced on every interactive shell.
It starts by downloading and installing my plugin manager of choice: [zgenom]. Then, after setting
some options used by plugins, it downloads and installs my plugins of choice.

### Plugins Used
- [**zpm-zsh/ls**][zpm-zsh-ls]: Use common `ls` aliases (can optionally use [exa] or [lsd])
- [**zpm-zsh/colorize**][zpm-zsh-colorize]: Try to add color to many common commands (can optionally use [grc])
- [**zpm-zsh/ssh**][zpm-zsh-ssh]: SSH-related completions
- [**zpm-zsh/ignored-users**][zpm-zsh-ignored-users]: Don't suggest completions for users with a UID between 0 (exclusive) and 1000 (exclusive),
  or greater than 10,000
- [**zpm-zsh/dot**][zpm-zsh-dot]: Dot rationalization: every two `..`s becomes a `/..`
- [**zsh-users/zsh-completions**][zsh-completions]: Auto-completions for many popular commands and CLI tools.
- [**djui/alias-tips**][alias-tips]: Reminds you if you have an alias for a command you just used. This was helpful
  when I first started using Oh My Zsh's git plugin, since it taught me many of the aliases it defines. For example,
  when I would type `git rebase` it would remind me that there is an alias `grb`.
- [**agkozak/zsh-z**][zsh-z]: Defines a shell function `z` that keeps track of your most commonly `cd`-ed to directories.
  Then, you can type a substring of one of these directories and it will `cd` to the directory for you. For example, if you
  `cd` to a directory named `llvm-interpreter` a lot, then after a while typing `z llvm` will `cd` you to `llvm-interpreter`.
  I've defined my own function `j` which uses `cd` as a fallback if `z` can't find a directory with the given substring in its name.
- [**zpm-zsh/clipboard**][zpm-zsh-clipboard]: Standardizes macOS' `pbcopy` and `pbpaste` commands to work as expected regardless
  of whether you are on Linux or macOS (Linux dependences: `xdg-open`, `xclip`)
- [**zdharma-continuum/fast-syntax-highlighting**][fast-syntax-highlighting]: Syntax highlighting at the command line, also inspired by Fish.
- [**zsh-users/zsh-history-substring-search**][zsh-history-substring-search]: At first, I didn't understand what this plugin did,
  because what it does is very subtle. When you start typing a command, if you hit the up arrow, it will cycle through all the commands in
  your shell history that start with what you've already typed. This is so intuitive you don't even think this was something that had to be
  added by a plugin.
- [**zsh-users/zsh-autosuggestions**][zsh-autosuggestions]: Inspired by a similar feature built into the Fish shell, this will show
  suggestions for common commands you type as you type them. Then, just hit the right arrow key to fill in the rest of the command.
  This is sort of like the predictive keyboards on smartphones, however `zsh-users/zsh-autosuggestions` has found a way to make this
  feature way less annoying.
- [**zdharma-continuum/history-search-multi-word**][history-search-multi-word]: More interactive ctrl-R reverse history search
- [**chisui/zsh-nix-shell**][zsh-nix-shell]: (only on NixOS) Allows Zsh to be used in Nix shells.

## [`bookmark.zsh`](bookmark.zsh)
This file is sourced by `.zshrc` and adds a directory bookmark mechanism. When in a directory you want to bookmark, run

```zsh
bookmark .
```

to use the current directory's name as the bookmark name, or

```zsh
bookmark <name>
```

to bookmark the current directory under the name `<name>`.

To view all current bookmarks, just run the `bookmark` command without any command line options.

To go to a bookmarked directory, type `~` and then the name of the bookmark. For example, I often create
a bookmark called `config-files` pointing to where I clone my config-files repo. Then, to go to it I simply type

```zsh
~config-files
```

and hit enter.


### [`zfunc`](zfunc)
Zsh has the notion of [autoloaded functions](https://zsh.sourceforge.io/Doc/Release/Functions.html#Autoloading-Functions).
Instead of defining a function directly in, say, your `.zshrc`, you place your function in a file
in a directory listed in the `$fpath` variable (note that you can add directories to this variable
with the `$fpath+=` syntax &#x2014; you'll see this in my `.zshrc`). The name of the file is the name of the
function you are defining with no extension. Then, in your `.zshrc` add

```zsh
autoload <function-name>
```

The benefit to autoloading functions rather than defining them directly in your `.zshrc` is that they are lazy
loaded &#x2014; the function code will not be read and compiled to bytecode until the first time you call it.
The only downside to this method is that you cannot see the source code of a function with the `functions` command
until after you call it at least once.

The [`zfunc`](zfunc) directory contains many functions I autoload that I find useful. I think the most important one
to point out is `_python-workon-cwd`. In addition to lazy loading, Zsh uses function autoloading for command completions
and shell hooks &#x2014; functions that are invoked on a certain event. One such event is when the current directory changes.
This function looks for a `.venv` file and, if present, activates the Python virtual environment named in that file. The
virtual environment is automatically deactivated upon leaving the directory.

[zsh]: https://zsh.sourceforge.io/
[zgenom]: https://github.com/jandamm/zgenom
[zpm-zsh-ls]: https://github.com/zpm-zsh/ls
[zpm-zsh-colorize]: https://github.com/zpm-zsh/colorize
[zpm-zsh-ssh]: https://github.com/zpm-zsh/ssh
[zpm-zsh-ignored-users]: https://github.com/zpm-zsh/ignored-users
[zpm-zsh-dot]: https://github.com/zpm-zsh/dot
[zsh-completions]: https://github.com/zsh-users/zsh-completions
[alias-tips]: https://github.com/djui/alias-tips
[zsh-z]: https://github.com/agkozak/zsh-z
[zpm-zsh-clipboard]: https://github.com/zpm-zsh/clipboard
[fast-syntax-highlighting]: https://github.com/zdharma-continuum/fast-syntax-highlighting
[zsh-history-substring-search]: https://github.com/zsh-users/zsh-history-substring-search
[zsh-autosuggestions]: https://github.com/zsh-users/zsh-autosuggestions
[history-search-multi-word]: https://github.com/zdharma-continuum/history-search-multi-word
[zsh-nix-shell]: https://github.com/chisui/zsh-nix-shell
[exa]: https://the.exa.website/
[lsd]: https://github.com/Peltoche/lsd
[grc]: https://kassiopeia.juls.savba.sk/~garabik/software/grc.html

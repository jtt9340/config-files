# Minimal Zsh Configuration

You'll notice the [`.zshrc`](.zshrc) in the minimal configuration has to set a lot more settings than the
[`.zshrc` in the Oh My Zsh configuration](../omz/.zshrc). This is (some of) the heavy lifting that
Oh My Zsh does for you.

## Plugins Used
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
[exa]: https://the.exa.website/
[lsd]: https://github.com/Peltoche/lsd
[grc]: https://kassiopeia.juls.savba.sk/~garabik/software/grc.html

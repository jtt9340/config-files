# Oh My Zsh-based Configuration

The [`.zshrc`](.zshrc) for this one just clones Zgenom if it is not already installed, loads
my plguins of choice (see below), and customizes them a bit. It also auto-loads the functions in the
[`zfunc`](zfunc) directory.

## Plugins Used
- [**Oh My Zsh Git Plugin**][omz-git]: (only if `git` is installed) Defines many `git` aliases. I'm so used to using these
  using `git` on another machine is a struggle.
- [**Oh My Zsh Gitignore Plugin**][omz-gitignore]: (only if `git` is installed) Command line interface to [gitignore.io](https://gitignore.io),
  a website containing many `.gitignore` templates for various programming languages, IDEs, and operating systems.
- [**Oh My Zsh Pip Plugin**][omz-pip]: (only if `pip` is installed) Auto-completion for `pip`. Not only does it autocomplete `pip`'s subcommands,
  but the names of the packages that can be installed too!
- [**Oh My Zsh Rust Plugin**][omz-rust]: (only if `rustc` is installed) Auto-completion for `rustc`, `cargo`, and `rustup`.
- [**Oh My Zsh Virtualenv Plugin**][omz-virtualenv]: Allows the name of the current active Python virtual environment,
  if any, to be displayed in the shell prompt.
- [**Oh My Zsh Docker Plugin**][omz-docker]: (only if `docker` is installed) Auto-completion and aliases for Docker.
- [**Oh My Zsh cp Plugin**][omz-cp]: (onlf if `rsync` is installed) Defines an alias `cpv` that uses `rsync` instead of
  `cp` to copy files for added security.
- [**zsh-users/zsh-completions**][zsh-completions]: Auto-completions for many popular commands and CLI tools.
- [**djui/alias-tips**][alias-tips]: Reminds you if you have an alias for a command you just used. This was helpful
  when I first started using Oh My Zsh's git plugin, since it taught me many of the aliases it defines. For example,
  when I would type `git rebase` it would remind me that there is an alias `grb`.
- [**agkozak/zsh-z**][zsh-z]: Defines a shell function `z` that keeps track of your most commonly `cd`-ed to directories.
  Then, you can type a substring of one of these directories and it will `cd` to the directory for you. For example, if you
  `cd` to a directory named `llvm-interpreter` a lot, then after a while typing `z llvm` will `cd` you to `llvm-interpreter`.
  I've defined my own function `j` which uses `cd` as a fallback if `z` can't find a directory with the given substring in its name.
- [**zsh-users/zsh-autosuggestions**][zsh-autosuggestions]: Inspired by a similar feature built into the Fish shell, this will show
  suggestions for common commands you type as you type them. Then, just hit the right arrow key to fill in the rest of the command.
  This is sort of like the predictive keyboards on smartphones, however `zsh-users/zsh-autosuggestions` has found a way to make this
  feature way less annoying.
- [**zsh-users/zsh-history-substring-search**][zsh-history-substring-search]: At first, I didn't understand what this plugin did,
  because what it does is very subtle. When you start typing a command, if you hit the up arrow, it will cycle through all the commands in
  your shell history that start with what you've already typed. This is so intuitive you don't even think this was something that had to be
  added by a plugin.
- [**zdharma-continuum/fast-syntax-highlighting**][fast-syntax-highlighting]: Syntax highlighting at the command line, also inspired by Fish.
- [**chisui/zsh-nix-shell**][zsh-nix-shell]: (only on NixOS) Allows Zsh to be used in Nix shells.

## Shell Prompt
[My shell prompt](joeys-avit.zsh-theme) is based off the [Oh My Zsh Avit Theme][omz-avit] and is customized to add support for Python virtualenvs via the
[Oh My Zsh Virtualenv Plugin][omz-virtualenv] as well as Nix shell support when on NixOS.

[omz-git]: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
[omz-gitignore]: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/gitignore
[omz-pip]: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/pip
[omz-rust]: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/rust
[omz-virtualenv]: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/virtualenv
[omz-docker]: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/docker
[omz-cp]: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/cp
[omz-avit]: https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/avit.zsh-theme
[zsh-completions]: https://github.com/zsh-users/zsh-completions
[alias-tips]: https://github.com/djui/alias-tips
[zsh-z]: https://github.com/agkozak/zsh-z
[zsh-autosuggestions]: https://github.com/zsh-users/zsh-autosuggestions
[zsh-history-substring-search]: https://github.com/zsh-users/zsh-history-substring-search
[fast-syntax-highlighting]: https://github.com/zdharma-continuum/fast-syntax-highlighting
[zsh-nix-shell]: https://github.com/chisui/zsh-nix-shell

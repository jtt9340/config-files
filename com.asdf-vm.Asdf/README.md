# [asdf][asdf]
This is a new (to me) tool I am trying out. It combines programs like [`pyenv`][pyenv], [`nvm`][nvm], [`ghcup`][ghcup], [`rustup`][rustup], and others into a single tool.
In other words, it is a tool that allows you to install multiple different versions of programming languages and other developer tools at a time and switch between them
when necessary. For example, one project might require Python 3.9 and Node version 11, and other might require Python 3.11 and Node version 16. Every mainstream programming
language has a tool like this for this purpose (see the aforementioned tools), but it gets annoying to have to install one for each programming language. The idea with `asdf` is to
have a single tool with a consistent CLI do this for you for a variety of programming languages and other CLI tools.

`asdf` is actually configured via environment variables in shell initialization scripts (see my [Zsh configuration](../net.sourceforge.Zsh/minimal/.zprofile)). The way it is
configured you have to use the [asdf-direnv][asdf-direnv] plugin so that is the first plugin that should be installed if you install `asdf`. The other configuration files in this
directory should be deployed if you install their respective `asdf` plugins, as they install some default CLI tools upon installing a particular programming language.

[asdf]: https://asdf-vm.com/
[pyenv]: https://github.com/pyenv/pyenv
[nvm]: https://github.com/nvm-sh/nvm
[ghcup]: https://www.haskell.org/ghcup/
[rustup]: https://rustup.rs
[asdf-direnv]: https://github.com/asdf-community/asdf-direnv

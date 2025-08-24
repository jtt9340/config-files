This directory contains all configuration for the `joeyt` user.

## [`config.nix`](config.nix)

This lives in the home directory for each user.
Nix by default disallows unfree software, which is good, except I'm not as steadfast on purely using free software and use Slack and Discord.
This file just tells Nix to allow non-free software when installing software at the command line with `nix-env`.

## [`git.nix`](git.nix)

This is [my git config](../../../com.git-scm.Git/README.md) ported to the Nix expression language, so that Home Manager can install this file as a package.

## [`vim.nix`](vim.nix)

This is [my vim configuration](../../../org.vim.Vim/README.md) ported to the Nix expression language, so that Home Manager can install this file as a package.

## [`coc-settings.nix`](coc-settings.nix)

This is the settings for [the CoC Vim extension][coc.nvim] ported to the Nix expression language, so that Home Manager can install this file as a package.

## [`zsh.nix`](zsh.nix)

This is [my zsh configuration](../../../net.sourceforge.Zsh/README.md) ported to the Nix expression language, so that Home Manager can install this file as a package.

## [`tmux.nix`](tmux.nix)

This is [my tmux configuration](../../../io.github.tmux/README.md) ported to the Nix expression language, so that Home Manager can install this file as a package.

## [`wezterm.nix`](wezterm.nix)

This is my [Wezterm][wezterm] configuration ported to the Nix expression language, so that Home Manager an install this file as a package.

## [`home.nix`](home.nix)

In addition to being the file that imports the configurations for all of the above into one centralized file that is imported by `configuration.nix`, this also installs some packages I didn't feel belonged in the system-wide configuration file, since I may stop using them at some point.

[coc.nvim]: https://github.com/neoclide/coc.nvim
[wezterm]: https://wezterm.org/

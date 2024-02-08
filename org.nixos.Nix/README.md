# [Nix(OS)](https://nixos.org/)
The files in this directory are the reason I named this repository "config files" instead of
"dotfiles." They are the files that configure the state and settings of my NixOS setup.

The unique thing that I like about NixOS is that it aims to be as "stateless" as possible,
meaning your OS is a function of the configuration you give it, nothing else. Of course,
stateful things like Documents, Photos, etc. make it so that this is not 100% possible,
but you can get pretty close in these config files by specifying which packages you want
installed, any patches/settings for them, systemd services, UNIX users, etc. By making as much of
your OS's state a function of these config files as possible, I can get a streamlined, consistent
experience on any machine running NixOS by deploying these files to that machine and running
`sudo nixos-rebuild switch`. Of course, I can back up the aforementioned Documents and Photos
to a cloud provider, and now I have a completely reproducible environment for any machine running
NixOS! This is very similar to the value proposition of a ChromeBook.

## [`config.nix`](config.nix)
This lives in the home directory for each user. Nix by default disallows unfree software, which
is good, except I'm not as steadfast on purely using free software and use Slack and Discord. This
file just tells Nix to allow non-free software when installing software at the command line with
`nix-env`.

## [`configuration.nix`](configuration.nix)
Don't let the similar name confuse you &#x2014; this is the system-wide configuration file for
Nix. This
- configures Grub
- sets the hostname for the computer
- configures networking
- sets other basic options like locale and time zone
- lists system-level packages to be installed
- enables OpenSSH
- configures the X server

## [`joeyt/`](joeyt)
Nix becomes even more powerful when you integrate
[Home Manager](https://rycee.gitlab.io/home-manager/) &#x2014;
it allows Nix to manage your config files for you. As outlined in the linked manual,
there are several ways to set it up; I've opted to install it as a NixOS module, which extends
the above `configuration.nix` to also configure users and their config files. For organizational
purposes, I have included all my user-specific configurations in their own directory to be
imported by the main `configuration.nix`, broken down by program.

### [`joeyt/git.nix`](joeyt/git.nix)
This is [my git config](../com.git-scm.Git/README.md) ported to the Nix expression language, so
that Home Manager can install this file as a package.

### [`joeyt/vim.nix`](joeyt/vim.nix)
This is [my vim configuration](../org.vim.Vim/README.md) ported to the Nix expression language,
so that Home Manager can install this file as a package.

### [`joeyt/coc-settings.nix`](joeyt/coc-settings.nix)
This is the settings for [the CoC Vim extension][coc.nvim] ported to the Nix expression language,
so that Home Manager can install this file as a package.

### [`joeyt/zsh.nix`](joeyt/zsh.nix)
This is [my zsh configuration](../net.sourceforge.Zsh/README.md) ported to the Nix expression
language, so that Home Manager can install this file as a package.

### [`joeyt/home.nix`](joeyt/home.nix)
In addition to being the file that imports the configurations for all of the above into one
centralized file that is imported by `configuration.nix`, this also installs some packages I
didn't feel belonged in the system-wide configuration file, since I may stop using them at some
point.

[coc.nvim]: https://github.com/neoclide/coc.nvim

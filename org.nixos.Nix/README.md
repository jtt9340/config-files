# [Nix(OS)](https://nixos.org/)

The files in this directory are the reason I named this repository "config files" instead of "dotfiles."
They are the files that configure the state and settings of my NixOS setup.

The unique thing that I like about NixOS is that it aims to be as "stateless" as possible, meaning your OS is a function of the configuration you give it, nothing else.
Of course, stateful things like documents, photos, etc. make it so that this is not 100% possible, but you can get pretty close in these config files by specifying which packages you want installed, any patches/settings for them, systemd services, UNIX users, etc.
By making as much of your OS's state a function of these config files as possible, I can get a streamlined, consistent experience on any machine running NixOS by deploying these files to that machine and running `sudo nixos-rebuild switch`.
Of course, I can back up the aforementioned Documents and Photos to a cloud provider, and now I have a completely reproducible environment for any machine running NixOS!
This is very similar to the value proposition of a ChromeBook.

## [`flake.nix`](flake.nix)

This is the "entrypoint" of my Nix configuration.
It uses [lollypops][lollypops] to specify which configuration file to use for a particular host/platform.
You deploy Nix configuration by running `nix run '.#lollypops' -- TARGET_NAME` where `TARGET_NAME` is one of the targets listed by `nix run '.#lollypops' -- --list-all`.

For each host you should see 4 targets: 
1. **check-vars:** This just does some prelimary checks to ensure everything is set up correctly.
2. **deploy-flake:** This copies the configuration to the host-to-be-configured using SSH.
3. **deploy-secrets:** This decrypts the secrets in this repo (see below) and copied them to the host-to-be-configured using SSH.
4. **rebuild:** This calls `nixos-rebuild` to actually build the configuration copied over in the **deploy-flake** target.

You will usually want to run all 4 targets, in which case you can use the hostname of the host-to-be-configured as the target name.
For example: `nix run '.#lollypops' -- nicksauce`.

If you want to configure all hosts at once, use target `all`.

## [`configuration.nix`](configuration.nix)

This is the system-wide configuration file for Nix.
In particular, this is the configuration common to all hosts I have running Nix(OS).
Becuase of this, it is very minimal and only
- installs Zsh
- installs some packages common to all hosts

[lollypops]: https://github.com/pinpox/lollypops

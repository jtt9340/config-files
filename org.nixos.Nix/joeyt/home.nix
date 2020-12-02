{ lib, pkgs, config, ... }:

let
  # Path to my repository for storing config/dot files
  configFiles = "${config.home.homeDirectory}/Projects/config-files";
  # nixos-unstable (for more recent version of some packages, need to subscribe to nixpkgs-unstable first)
  # pkgsUnstable = import <nixpkgs-unstable> {
  #   config = { allowUnfree = true; };
  # };
in
{
  xdg = {
    # Enable management of XDG Base Directories
    enable = true;

    # Home manager will manage these dotfiles
    configFile = {
      "nixpkgs/config.nix".source = "${configFiles}/org.nixos.Nix/config.nix";
      "micro/settings.json".source = "${configFiles}/io.github.micro-editor/settings.json";
      "ripgreprc".source = "${configFiles}/com.github.burntsushi.Ripgrep/ripgreprc";
      "zsh/zfunc" = {
        source = "${configFiles}/net.sourceforge.Zsh/zfunc";
        recursive = true;
      };
    };
  };

  programs = {
    # Let Home Manager install and manage things
    home-manager.enable = true;

    # Configure Zsh
    zsh = (import ./zsh.nix) {
      inherit (pkgs) fetchFromGitHub;
      inherit configFiles;
    };

    # Git config
    git = (import ./git.nix) pkgs.bat-extras.batman;

    # Use z-lua, a program that remembers your most frequently cd-ed to directories to make
    # it easier to cd to them
    z-lua = import ./z-lua.nix;

    # Use skim, a command-line fuzzy finder written in Rust
    skim.enable = true;

    # Use lsd, an ls clone written in Rust
    lsd.enable = true;
  };

  home.packages = with pkgs; [
    # CLI tools
    bat-extras.batdiff
    bat-extras.batgrep
    bat-extras.batman
    bat-extras.prettybat
    broot
    elvish
    nodePackages.insect
    lua
    sshfs

    # GUI apps
    bitwarden
    discord
    jetbrains.idea-ultimate
    jetbrains.pycharm-professional
    libreoffice
    slack
    thunderbird
  ];

  # How many times do I have to say that I am okay with non-free software?! I guess when
  # you specify packages with home.packages you also need to specify it here?
  # (Me from the future: yes that is the case - the following line applies only to packages
  # listed above)
  nixpkgs.config.allowUnfree = true;
}

{ lib, pkgs, ... }:

{
  programs = {
    # Let Home Manager install and manage things
    home-manager.enable = true;

    # Configure Zsh
    zsh = (import ./zsh.nix) pkgs.fetchFromGitHub; 

    # Git config
    git = import ./git.nix;

    # Use z-lua, a program that remembers your most frequently cd-ed to directories to make
    # it easier to cd to them
    z-lua = import ./z-lua.nix;
  };

  home.packages = with pkgs; [
    broot thunderbird bitwarden lua slack discord
  ];

  # How many times do I have to say that I am okay with non-free software?! I guess when
  # you specify packages with home.packages you also need to specify it here?
  nixpkgs.config.allowUnfree = true;
}

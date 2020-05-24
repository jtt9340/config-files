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
    broot thunderbird bitwarden lua
  ];
}

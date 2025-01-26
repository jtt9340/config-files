{ lib, pkgs, config, ... }:

{%@@ if profile == 'nixos' @@%}
let
  impermanence = builtins.fetchTarball "https://github.com/nix-community/impermanence/archive/master.tar.gz";
in
{%@@ endif @@%}
{
  imports =
{%@@ if profile == 'nixos' @@%}
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Introduce a new NixOS option called home-manager.users
      <home-manager/nixos>
      # Introduce a new NixOS option called environment.persistence
      "${impermanence}/nixos.nix"
    ]
{%@@ else @@%}
    [
      # Introduce a new nix-darwin option called home-manager.users
      <home-manager/nix-darwin>
    ]
{%@@ endif @@%}
    ;

  config = lib.mkMerge [
    {
      programs.zsh = {
        enable = true;
        # If true, then compinit is called in /etc/zshrc
        # See https://github.com/nix-community/home-manager/issues/108
        enableCompletion = false;
      };

      nixpkgs.config.allowUnfree = true;

      environment = {
        systemPackages = with pkgs; [
          # Print a list of paths as a tree of paths
          as-tree
          # A cat/less alternative with syntax highlighting
          bat
          # Convert between \n and \r\n line endings
          dos2unix
          # More user-friendly alternative to find
          fd
          # Terminal-based system monitor
          htop
          # Format nix files
          nixfmt-classic
          # Generate SHA-256 sums from Git repositories
          nix-prefetch-git
          # Generate SHA-256 sums from GitHub repositories
          nix-prefetch-github
          # A command line calculator with support for dimensional analysis
          numbat
          # Integrate ripgrep (grep alternative) with additional document formats like PDFs and Word documents
          ripgrep-all
          # Linter for shell scripts
          shellcheck
          # Formatter for shell scripts
          shfmt
          # Put files in the trash from the command line
          trash-cli
        ];

        # Shell completion for system packages
        pathsToLink = [ "/share/zsh" ];
      };

      nix = {
        settings = {
          show-trace = true;
          use-xdg-base-directories = true;
          experimental-features = [ "nix-command" "flakes" ];
        };
        # Periodically clean out the Nix store
        gc = {
          automatic = true;
          options = "--delete-older-than 365d";
        };
      };

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
      };

      networking.hosts = {
        "192.168.1.6" = [ "raspberrypi" ];
      };
    }

{%@@ if profile == 'nixos' @@%}
  {#@@ This include does not need the org.nixos.Nix/ prefix because
       the dotpath in config_root.yaml includes that @@#}
  {%@@ include 'nixos-configuration.nix' @@%}
{%@@ else @@%}
  {%@@ include 'org.nixos.Nix/darwin-configuration.nix' @@%}
{%@@ endif @@%}
  ];
}

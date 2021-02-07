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
      "bat/config".source = "${configFiles}/com.github.sharkdp.Bat/config";
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

    # Use Vim with custom configuration and plugins
    vim = (import ./vim.nix) {
      inherit (pkgs) vimPlugins fetchFromGitHub;
      inherit (pkgs.vimUtils) buildVimPluginFrom2Nix;
    };
  };

  home.packages = with pkgs; [
    # CLI tools

    # A shell script to use bat (a cat/less alternative feat. syntax highlighting) to view diffs
    bat-extras.batdiff
    # A shell script to use bat (see above) in tandem with ripgrep (grep alternative) for pretty output
    bat-extras.batgrep
    # A shell script to use bat (see above) to view man pages, effectively colorizing them 
    bat-extras.batman
    # A shell script to pretty print/format files before viewing them
    bat-extras.prettybat
    # Tree-based file manager and fuzzy finder
    broot
    # A shell that aims to innovate on UNIX shells by using strongly-typed data structures as pipelines
    elvish
    # A command line calculator with support for dimensional analysis
    nodePackages.insect
    # A simple scripting language
    lua
    # Allows you to mount remote drives via ssh
    sshfs

    # GUI apps

    # Password manager
    bitwarden
    # Chat app
    discord
    # Java IDE
    jetbrains.idea-ultimate
    # Python IDE
    jetbrains.pycharm-professional
    # Free and open-source office suite
    libreoffice
    # Makes it easier to run games/Windows-only applications on GNU/Linux
    lutris
    # Another chat app
    slack
    # Email client
    thunderbird
  ];

  # How many times do I have to say that I am okay with non-free software?! I guess when
  # you specify packages with home.packages you also need to specify it here?
  # (Me from the future: yes that is the case - the following line applies only to packages
  # listed above)
  nixpkgs.config.allowUnfree = true;
}

stateVersion:

{ lib, pkgs, config, ... }:

let
  # Path to my repository for storing config/dot files
  configFiles = "${config.home.homeDirectory}/Projects/config-files";
  # nixos-unstable (for more recent version of some packages, need to subscribe to nixpkgs-unstable first)
  # pkgsUnstable = import <nixpkgs-unstable> {
  #   config = { allowUnfree = true; };
  # };
  xdgConfigHome = config.xdg.configHome;
  xdgDataHome = config.xdg.dataHome;
  xdgCacheHome = config.xdg.cacheHome;
in {
  home.stateVersion = stateVersion;

  xdg = {
    # Enable management of XDG Base Directories
    enable = true;

    # Home manager will manage these dotfiles
    configFile = {
      "nixpkgs/config.nix".source = "${configFiles}/org.nixos.Nix/config.nix";
      "ripgreprc".source =
        "${configFiles}/com.github.burntsushi.Ripgrep/ripgreprc";
      "zsh/zfunc" = {
        source = "${configFiles}/net.sourceforge.Zsh/omz/zfunc";
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
      inherit (pkgs) fetchFromGitHub python3;
      inherit (pkgs.stdenv) mkDerivation;
      inherit configFiles;
      inherit xdgConfigHome;
      inherit xdgDataHome;
    };

    # Git config
    git = (import ./git.nix) pkgs.bat-extras.batman;

    # Use z-lua, a program that remembers your most frequently cd-ed to directories to make
    # it easier to cd to them
    z-lua = import ./z-lua.nix;

    # Use skim, a command-line fuzzy finder written in Rust
    skim.enable = true;

    # Use lsd, an ls clone with more colors and icons
    lsd.enable = true;

    # Use Vim with custom configuration and plugins
    vim = (import ./vim.nix) {
      inherit (pkgs) vimPlugins fetchFromGitHub;
      inherit (pkgs.vimUtils) buildVimPluginFrom2Nix;
      inherit xdgConfigHome;
      inherit xdgDataHome;
      inherit xdgCacheHome;
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
    # JavaScript runtime - needed for coc.nvim
    nodejs_18
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
    # Sync mobile device with Gnome Desktop
    gnomeExtensions.gsconnect
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
  ];

  # How many times do I have to say that I am okay with non-free software?! I guess when
  # you specify packages with home.packages you also need to specify it here?
  # (Me from the future: yes that is the case - the following line applies only to packages
  # listed above)
  nixpkgs.config.allowUnfree = true;
}

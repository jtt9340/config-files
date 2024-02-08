{ config, pkgs, ... }:

{
  imports = [
    # Introduce a new nix-darwin option called home-manager.users
    <home-manager/nix-darwin>
  ];

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
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
    # A command line calculator with support for dimensional analysis
    nodePackages.insect
    # List USB devices
    darwin.lsusb
    # SSH alternative that allows for interrupted connections
    mosh
    # An opinionated formatter for Nix
    nixfmt
    # Generate SHA-256 sums from Git repositories
    nix-prefetch-git
    # Generate SHA-256 sums from GitHub repositories
    nix-prefetch-github
    # Integrate ripgrep (grep alternative) with additional document formats like PDFs and Word documents
    ripgrep-all
    # Linter for shell scripts
    shellcheck
    # Formatter for shell scripts
    shfmt
    # Put files in the trash from the command line
    trash-cli
  ];

  # Even though we will try to manage as many packages as possible with Nix, we still use Homebrew
  # for some macOS-specific things
  homebrew = {
    enable = true;
    taps = [
      # Contains a formula for Apple's San Francisco monospace font
      # patched to work with Nerd Fonts
      "epk/epk"
      # Needed for SSHFS
      "gromgit/fuse"
      # Several fonts for macOS
      "homebrew/cask-fonts"
    ];
    brews = [
      # SSHFS: Mount folders on remote machines as local mounts via SSH
      "gromgit/fuse/sshfs-mac"
    ];
    casks = [
      # Tool to flash OS images to SD cards & USB drives
      "balenaetcher"
      # App to build and share containerized applications and microservices
      "docker"
      # Tool to hide status bar icons
      "dozer"
      # Web browser
      "firefox"
      # Several nerd fonts to use with lsd
      "font-droid-sans-mono-nerd-font"
      "font-iosevka-nerd-font"
      "font-meslo-lg-nerd-font"
      "font-sf-mono-nerd-font"
      # Client for the Google Drive storage services
      "google-drive"
      # I think this is needed for SSHFS to work?
      "macfuse"
      # Cloud storage client
      "onedrive"
      # Keyboard configurator
      "via"
      # Remote desktop application
      "vnc-viewer"
    ];
  };

  # Shell completion for system packages
  environment.pathsToLink = [ "/share/zsh" ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh = {
    enable = true; # default shell on catalina
    # If true, then compinit is called in /etc/zshrc
    # See https://github.com/rycee/home-manager/issues/108
    enableCompletion = false;
  };
  # programs.fish.enable = true;

  # "The user-friendly name for the system"
  networking.computerName = "Joey’s MacBook Pro";

  # Use TouchID to authenticate with sudo
  security.pam.enableSudoTouchIdAuth = true;

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    # Periodically clean out the Nix store
    gc = {
      automatic = true;
      # on the 15th of every month (man launchd.plist)
      interval.Day = 15;
      options = "--delete-older-than 365d";
    };
  };

  users.users.josephterrito = {
    description = "Joseph Territo";
    home = "/Users/josephterrito";
    shell = "/bin/zsh";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.josephterrito = import ./joeyt/home.nix;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}

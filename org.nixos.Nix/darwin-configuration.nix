{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # List USB devices
    darwin.lsusb
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
      # SSH alternative that allows for interrupted connections
      "mosh"
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
      # Graphically shows disk usage within a filesystem
      # This is in nixpkgs but it can't build: https://github.com/NixOS/nixpkgs/issues/347868
      "grandperspective"
      # I think this is needed for SSHFS to work?
      "macfuse"
      # Cloud storage client
      "onedrive"
      # Move and resize windows using keyboard shortcuts or snap areas
      # This is in nixpkgs but it can't build: https://github.com/NixOS/nixpkgs/issues/347868
      "rectangle"
      # FOSS filesystem encryption on-the-fly
      "veracrypt"
      # Keyboard configurator
      "via"
      # Remote desktop application
      "vnc-viewer"
      # X11 for macOS: to be able to enable X forwarding when SSH-ing into Linux boxes
      # This is in nixpkgs but it can't build: https://github.com/NixOS/nixpkgs/issues/319189
      "xquartz"
    ];
  };

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # JOEY: Setting darwin-config via nix.nixPath, since nix path needs to also contain an
  # XDG-respecting nix/defexpr
  # environment.darwinConfig = "$XDG_CONFIG_HOME/nix/configuration.nix";
  nix.nixPath = [
    {
      darwin-config =
        "$HOME/Library/Application Support/nix/configuration.nix";
    }
    "/nix/var/nix/profiles/per-user/root/channels"
    "$HOME/Library/Application Support/nix/defexpr/channels"
  ];

  # Nested " to account for space
  environment.systemPath = [ ''"$HOME/Library/Application Support/nix/profile/bin"'' ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Pin Nix to the latest version that still supports spaces in NIX_PATH
  nix.package = pkgs.nixVersions.nix_2_23;

  nixpkgs.hostPlatform = "x86_64-darwin";

  # "The user-friendly name for the system"
  networking.computerName = "Joey’s MacBook Pro";

  # Use TouchID to authenticate with sudo
  security.pam.enableSudoTouchIdAuth = true;

  # How often to clean out the Nix store
  nix.gc.interval.Day = 15; # on the 15th of every month (man launchd.plist)

  users.users.josephterrito = {
    description = "Joseph Territo";
    home = "/Users/josephterrito";
    shell = /bin/zsh;
  };

  home-manager.users.josephterrito = import ./joeyt/home.nix;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}

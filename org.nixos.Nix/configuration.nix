# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

rec {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # Introduce a new NixOS option called home-manager.users
    <home-manager/nixos>
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "craigscomputer"; # Define your hostname.
  # The following does not need to be enabled, so long as a user is in the "networkmanager" group
  # and NetworkManager is enabled
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  # Joey: I think this can all be managed by networkmanager
  # networking.useDHCP = false;
  # networking.interfaces.enp0s25.useDHCP = true;
  # networking.interfaces.wlp0s26f7u3.useDHCP = true;
  # Used to facilitate network configuration (I probably need this?)
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # These are the defaults so I guess they don't need to be uncommented
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # This is only needed if any of the packages listed in `environment.systemPackages`
  # are non-free.
  # nixpkgs.config.allowUnfree = true;

  # Configure Zsh as an interactive shell
  programs.zsh = {
    enable = true;
    # If true, then compinit is called in /etc/zshrc
    # See https://github.com/rycee/home-manager/issues/108
    enableCompletion = false;
  };

  # Install wireshark
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # These are packages that are automatically available to all users, and are
  # automatically updated every time you rebuild the system configuration
  environment.systemPackages = with pkgs; [
    # Print a list of paths as a tree of paths
    as-tree
    # A cat/less alternative with syntax highlighting
    bat
    # "A command-line tool for transferring files with URL syntax"
    curl
    # More user-friendly alternative to find
    fd
    # Identify files by their type
    file
    # Web browser
    firefox
    # C/C++ compiler
    gcc
    # Distributed VCS
    git
    # "A tool to control the generation of non-source files from sources"
    gnumake
    # English dictionaries, useful for spell check in programs
    hunspellDicts.en-us
    # Terminal-based system monitor
    htop
    # A command line calculator with support for dimensional analysis
    nodePackages.insect
    # Text editor part of the KDE ecosystem
    kate
    # SSH alternative that allows for interrupted connections
    mosh
    # PDF viewer part of the KDE ecosystem
    okular
    # An opinionated formatter for Nix
    nixfmt
    # Generate SHA-256 sums from Git repositories
    nix-prefetch-git
    # Generate SHA-256 sums from GitHub repositories
    nix-prefetch-github
    # Does what it says on the tin
    partition-manager
    # Screen recorder
    peek
    # Integrate ripgrep (grep alternative) with additional document formats like PDFs and Word documents
    ripgrep-all
    # Screenshots
    spectacle
    # Put files in the trash from the command line
    trash-cli
    # Extract ZIP archives
    unzip
    # Advanced terminal-based text editor
    vim
    # "Tool for retrieving files using HTTP, HTTPS, and FTP"
    wget
    # Determine where binaries are installed on your system
    which
    # Access the clpiboard from the command line
    xclip
    # Create ZIP archives
    zip
    # A UNIX shell alternative to Bash
    zsh
  ];

  # Shell completion for system packages
  environment.pathsToLink = [ "/share/zsh" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  programs.ssh.startAgent = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
  };
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver = {
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };

  # "On 64-bit systems, if you want OpenGL for 32-bit programs such as in Wine, you should also set the following"
  # Could this be why programs fail with an error saying my version of OpenGL is too old?
  # hardware.opengl.driSupport32Bit = true;
  hardware.opengl.enable = true;

  # Automatically keep NixOS up-to-date, but don't automatically reboot
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
  };

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    # Periodically clean out the Nix store
    gc = {
    automatic = true;
    dates =
      "*-*-1,15 3:15"; # 3:15 AM (local time) on the 1st and 15th of every month (man systemd.time)
    options = "--delete-older-than 365d";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    # Zsh is the default shell for everyone...mwah ha ha!
    defaultUserShell = pkgs.zsh;

    users.joeyt = {
      description = "Joey T";
      isNormalUser = true;
      # 'wheel' enables ‘sudo’ for the user;
      # 'networkmanager' allows the user to change network settings  
      # 'wireshark' is needed for wireshark to be able to collect packet captures
      extraGroups = [ "wheel" "networkmanager" "wireshark" ];
    };
  };

  # Configure the Joey T user a little bit
  home-manager.users.joeyt = (import ./joeyt/home.nix) system.stateVersion;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

}


# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  pypi2nix = import (pkgs.fetchgit {
    url = "https://github.com/nix-community/pypi2nix";
    rev = "v2.0.4";
    sha256 = "023b5l2blbzafh9327l5j9b5n05wqxqc75mv8h94927sd5rr9ggr";
  }) {};
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Introduce a new NixOS option called home-manager.users
      <home-manager/nixos>
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
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
  networking.useDHCP = false;
  networking.interfaces.enp0s25.useDHCP = true;
  networking.interfaces.wlp0s26f7u3.useDHCP = true;

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
  programs.zsh.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # These are packages that are automatically available to all users, and are
  # automatically updated every time you rebuild the system configuration
  environment.systemPackages = with pkgs; [
    bat
    curl
    fd
    file
    firefox
    flameshot
    gcc
    git
    gnumake
    gparted
    htop
    kate
    okular
    micro
    nix-prefetch-git
    nix-prefetch-github
    pypi2nix
    ripgrep-all
    trash-cli
    unzip
    vim
    wget
    which
    xclip
    zip
    zsh
  ];

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

  # Used to facilitate network configuration (I probably need this?)
  networking.networkmanager.enable = true;

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
  hardware.opengl.driSupport32Bit = true;

  # Automatically keep NixOS up-to-date, but don't automatically reboot
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
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
      extraGroups = [ "wheel" "networkmanager" ];
    };
  };

  # Configure the Joey T user a little bit
  home-manager.users.joeyt = import ./joeyt/home.nix;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

}


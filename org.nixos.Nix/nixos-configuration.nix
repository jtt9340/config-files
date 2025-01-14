# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  # Use the GRUB 2 boot loader.
  # boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  # Use the systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Minimal list of modules to use the EFI system partition and the YubiKey
  boot.initrd.kernelModules = [ "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" ];

  # Enable support for the YubiKey PBA
  boot.initrd.luks.yubikeySupport = true;

  # Configuration to use your Luks device
  boot.initrd.luks.devices = {
    "nixos-enc" = {
      device = "/dev/disk/by-uuid/80f05700-d1e3-4b15-84f4-1dbcfd7d0635";
      preLVM = true; # Set to false if you need to start a network service first
      yubikey = {
        slot = 2;
        twoFactor = false;
        storage.device = "/dev/disk/by-uuid/E2BC-AA8C";
      };
    };
  };

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    mkdir /mnt
    mount -t btrfs /dev/mapper/nixos-enc /mnt
    if [[ -e /mnt/root ]]; then
      mkdir -p /mnt/persist/old_roots
      timestamp=$(date --date="@$(stat -c %Y /mnt/root)" "+%Y-%m-%-d_%H:%M:%S")
      mv /mnt/root "/mnt/persist/old_roots/$timestamp"
    fi

    delete_subvolume_recursively() {
      IFS=$'\n'
      for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
        delete_subvolume_recursively "/mnt/$i"
      done
      btrfs subvolume delete "$1"
    }

    for i in $(find /mnt/persist/old_roots -maxdepth 1 -mtime +30); do
      delete_subvolume_recursively "$i"
    done

    btrfs subvolume snapshot /mnt/root-blank /mnt/root
    umount /mnt
  '';

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      {
        directory = "/var/lib/colord";
        user = "colord";
        group = "colord";
        mode = "u=rwx,g=rx,o=";
      }
    ];
    files = [
      "/etc/machine-id"
      "/etc/joeyt"
      "/etc/root"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/btrbk_key"
      "/etc/ssh/btrbk_key.pub"
    ];
  };

  services.btrbk = let btrbkKey = "/etc/ssh/btrbk_key";
  in {
    sshAccess = [{
      key = "${btrbkKey}.pub";
      roles = [ "source" "target" "info" ];
    }];
    instances.btrbk = {
      onCalendar = "*-*-1,15 2:15";
      settings = {
        ssh_identity = btrbkKey;
        ssh_user = "btrbk";
        stream_compress = "lz4";
        volume."/btrpool" = {
          subvolume = {
            home = { };
            persist = { };
            log = { };
          };
          target = "ssh://raspberrypi/srv/btrbk";
        };
      };
    };
  };

  networking.hostName = "nicksauce"; # Define your hostname.
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

  networking.interfaces.enp5s0.ipv4.addresses = [{
    address = "10.0.0.5";
    prefixLength = 24;
  }];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # These are the defaults so I guess they don't need to be uncommented
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # This is only needed if any of the packages listed in `environment.systemPackages`
  # are non-free.
  # nixpkgs.config.allowUnfree = true;

  # Install wireshark
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  virtualisation = {
    containers.enable = true;
    podman.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # These are packages that are automatically available to all users, and are
  # automatically updated every time you rebuild the system configuration
  environment.systemPackages = with pkgs; [
    # "A command-line tool for transferring files with URL syntax"
    curl
    # Identify files by their type
    file
    # C/C++ compiler
    gcc
    # Distributed VCS
    git
    # "A tool to control the generation of non-source files from sources"
    gnumake
    # English dictionaries, useful for spell check in programs
    hunspellDicts.en-us
    # Utilities for working with .heic files
    libheif
    # Compression algorithm used by btrbk
    lz4
    # SSH alternative that allows for interrupted connections
    mosh
    # Remote desktop client
    realvnc-vnc-viewer
    # Extract ZIP archives
    unzip
    # FOSS filesystem encryption on-the-fly
    veracrypt
    # "Tool for retrieving files using HTTP, HTTPS, and FTP"
    wget
    # Determine where binaries are installed on your system
    which
    # Copy to and paste from the system clipboard from the command line
    wl-clipboard
    # Create ZIP archives
    zip
  ];

  programs.firefox.enable = true;

  programs.vim.defaultEditor = true;

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
  programs.ssh = {
    startAgent = true;
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };

  # Open ports in the firewall. Needed for GSConnect.
  networking.firewall.allowedTCPPorts = pkgs.lib.lists.range 1714 1764;
  networking.firewall.allowedUDPPorts = pkgs.lib.lists.range 1714 1764;
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    # Enable the KDE Desktop Environment.
    # displayManager.sddm.enable = true;
    # desktopManager.plasma5.enable = true;
    # Enable the GNOME Desktop Environment.
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Do not include these GNOME packages by default.
  environment.gnome.excludePackages = with pkgs; [
    epiphany # Replaced by firefox
    geary # Replaced by thunderbird
    gnome-connections # Replaced by realvnc-vnc-viewer
    gnome-console # Replaced by wezterm
  ];

  # "On 64-bit systems, if you want OpenGL for 32-bit programs such as in Wine, you should also set the following"
  # hardware.opengl.driSupport32Bit = true;
  hardware.opengl.enable = true;

  # Automatically keep NixOS up-to-date, but don't automatically reboot
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
  };

  # How often to clean out the Nix store
  nix.gc.dates =
    "*-*-1,15 3:15"; # 3:15 AM (local time) on the 1st and 15th of every month (man systemd.time)

  # Define user accounts.
  users = {
    # Users cannot be created imperatively, only declaratively
    mutableUsers = false;

    # Zsh is the default shell for everyone...mwah ha ha!
    defaultUserShell = pkgs.zsh;

    users = {
      # Other options are already set for root by default, we only want to override the password.
      root.hashedPasswordFile = "/persist/etc/root";

      joeyt = {
        description = "Joey T";
        isNormalUser = true;
        hashedPasswordFile = "/persist/etc/joeyt";
        # 'wheel' enables ‘sudo’ for the user;
        # 'networkmanager' allows the user to change network settings  
        # 'wireshark' is needed for wireshark to be able to collect packet captures
        extraGroups = [ "wheel" "networkmanager" "wireshark" ];
      };
    };
  };

  # Configure the Joey T user a little bit
  home-manager.users.joeyt = import ./joeyt/home.nix;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "{{@@ state_version @@}}"; # Did you read the comment?
}

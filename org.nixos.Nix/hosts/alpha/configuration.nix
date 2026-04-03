{ lib, config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Needed for ZFS
  networking.hostId = "f1e68ca3";

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [ "/var/lib/nixos" "/var/lib/systemd/coredump" ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };

  boot = {
    # I'm not sure how necessary this option is.
    supportedFilesystems = [ "zfs" ];

    loader.grub = {
      enable = true;
      zfsSupport = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      mirroredBoots = [{
        devices = [ "nodev" ];
        path = "/boot";
      }];
    };

    initrd = {
      kernelModules = [ "zfs" ];
      postResumeCommands = lib.mkAfter ''
        zfs rollback -r zroot/local/root@blank
      '';
    };

    # https://nixos.wiki/wiki/ZFS#Missing_support_for_SWAP_on_ZFS
    kernelParams = [ "nohibernate" ];
  };

  networking = {
    hostName = "alpha";
    useNetworkd = true;
    useDHCP = false;
    dhcpcd.enable = false;
  };

  systemd.network = {
    enable = true;
    networks = {
      eno1 = let gateway = "192.168.13.1";
      in {
        name = "eno1";
        address = [ "192.168.13.3/24" ];
        gateway = [ gateway ];
        dns = [ gateway ];
      };
    };
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Set your time zone.
  time.timeZone = "America/Chicago";

  virtualisation = {
    containers.enable = true;
    podman.enable = true;
  };

  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  # How often to clean out the Nix store
  nix.gc.dates =
    "*-*-1,15 3:15"; # 3:15 AM (local time) on the 1st and 15th of every month (man systemd.time)

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
      };
    };

    zfs = {
      autoScrub.enable = true;
      autoSnapshot.enable = true;
    };
  };

  # Define user accounts.
  users = {
    # Users cannot be created imperatively, only declaratively.
    mutableUsers = false;

    # Make Zsh the default shell for all users
    defaultUserShell = pkgs.zsh;

    users = {
      # Other options are already set for root by default, we only want to override the password.
      root.hashedPasswordFile = "/persist/etc/root";

      nixos = {
        description = "NixOS";
        isNormalUser = true;
        hashedPasswordFile = "/persist/etc/nixos";
        # 'wheel' enables ‘sudo’ for the user;
        extraGroups = [ "wheel" ];
      };
    };
  };

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
  system.stateVersion = "25.11";
}

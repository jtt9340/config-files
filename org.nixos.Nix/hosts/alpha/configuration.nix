{
  lib,
  config,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  lollypops.deployment = {
    group = "servers";
    ssh.user = config.users.users.nixos.name;
    sudo.enable = true;
  };

  # Needed for ZFS
  networking.hostId = "f1e68ca3";

  environment = {
    systemPackages = with pkgs; [
      wezterm.headless
    ];

    persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
      ];
      files = [
        "/etc/machine-id"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
      ];
    };
  };

  boot = {
    # I'm not sure how necessary this option is.
    supportedFilesystems = [ "zfs" ];

    loader.grub = {
      enable = true;
      zfsSupport = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      mirroredBoots = [
        {
          devices = [ "nodev" ];
          path = "/boot";
        }
      ];
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
      eno1 =
        let
          gateway = "192.168.13.1";
        in
        {
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

  # Add PAM module for using SSH keys forwarded by SSH agent to authenticate with sudo.
  security.pam.rssh.enable = true;
  security.pam.services.sudo.rssh = true;

  # Automatically keep NixOS up-to-date, but don't automatically reboot
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    flake = "github:jtt9340/config-files?dir=org.nixos.Nix#alpha";
  };

  # How often to clean out the Nix store
  nix.gc.dates = "*-*-1,15 3:15"; # 3:15 AM (local time) on the 1st and 15th of every month (man systemd.time)

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        # Needed by Wezterm
        AcceptEnv = "COLORTERM TERM TERM_PROGRAM TERM_PROGRAM_VERSION WEZTERM_REMOTE_PANE";
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

        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCw4ddmw3cQUr+/PDD/ezWUf0JvVAfBj/BUSx9XkTMEMG8O0yxybA0F4o3wjePL9bIdmkjoZc/kQBKxqECcoaT3Z7c98WJAGllE41XlKPJO+s00xMWbAHVTewDwPdkB3Wntf9BpMDqESA7MrKQxhS6dFmgXaqJHNKnBUkmkxPspkRsBVibMT52C3uRFkfGKLX1mnRtdQ5R+RnuxZvec4Aj3SQQyn4Mti3/40k7r1c8bN0odCIxoaPgnM74z2GQH3FTo+M4tUUf4gO6MakVPBqh048CkUvxRI9O+T3wtEauhxPeVf/QCPsph/AP0KtPuH3FLZg1u3Vt4QqfLALYt4OLN josephterrito@res555574750155.rh.rit.edu"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIANkzjU75w7GM4w/p8MqMk028n496uAqsEH0iDsiTCov jtt9340@rit.edu"
        ];
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

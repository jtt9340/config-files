# Adapted from https://github.com/nix-community/disko-templates/blob/main/zfs-impermanence/disko-config.nix
{
  disko.devices = {
    disk = {
      disk1 = {
        device = "/dev/disk/by-id/ata-HGST_HMS5C4040BLE640_PL1331LAH1NURH";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
      disk2 = {
        device = "/dev/disk/by-id/ata-HGST_HMS5C4040BLE640_PL2331LAH09W4J";
        type = "disk";
        content = {
          type = "zfs";
          pool = "zroot";
        };
      };
      disk3 = {
        device = "/dev/disk/by-id/ata-Hitachi_HUS724040ALE641_PAKYU3VT";
        type = "disk";
        content = {
          type = "zfs";
          pool = "zroot";
        };
      };
      disk4 = {
        device = "/dev/disk/by-id/ata-Hitachi_HUS724040ALE641_PCGM388B";
        type = "disk";
        content = {
          type = "zfs";
          pool = "zroot";
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        mode = "raidz1";
        rootFsOptions = {
          acltype = "posixacl";
          relatime = "on";
          compression = "zstd";
          mountpoint = "none";
          xattr = "sa";
        };
        options = {
          ashift = "12";
          autotrim = "on";
        };

        datasets = {
          "local" = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
          "local/home" = {
            type = "zfs_fs";
            mountpoint = "/home";
            options = {
              mountpoint = "legacy";
              # Used by services.zfs.autoSnapshot options.
              "com.sun:auto-snapshot" = "true";
            };
          };
          "local/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options = {
              mountpoint = "legacy";
              "com.sun:auto-snapshot" = "false";
            };
          };
          "local/persist" = {
            type = "zfs_fs";
            mountpoint = "/persist";
            options = {
              mountpoint = "legacy";
              "com.sun:auto-snapshot" = "false";
            };
          };
          "local/log" = {
            type = "zfs_fs";
            mountpoint = "/var/log";
            options = {
              mountpoint = "legacy";
              "com.sun:auto-snapshot" = "false";
            };
          };
          "local/srv" = {
            type = "zfs_fs";
            mountpoint = "/srv";
            options = {
              mountpoint = "legacy";
              "com.sun:auto-snapshot" = "true";
            };
          };
          "local/root" = {
            type = "zfs_fs";
            mountpoint = "/";
            options = {
              mountpoint = "legacy";
              "com.sun:auto-snapshot" = "false";
            };
            postCreateHook =
              "zfs list -t snapshot -H -o name | grep -E '^zroot/local/root@blank$' || zfs snapshot zroot/local/root@blank";
          };
        };
      };
    };
  };

  fileSystems."/persist".neededForBoot = true;
  # To have correct log order
  fileSystems."/var/log".neededForBoot = true;
}

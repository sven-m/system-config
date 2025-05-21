{
  disko.devices = {
    disk = {
      nvme0n1 = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "boot";
              name = "ESP";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                ];
              };
            };
            luks = {
              size = "100%";
              label = "luks";
              content = {
                type = "luks";
                name = "cryptroot";
                extraOpenArgs = [
                  "--allow-discards"
                  "--perf-no_read_workqueue"
                  "--perf-no_write_workqueue"
                ];
                content = {
                  type = "btrfs";
                  extraArgs = ["-L" "nixos" "-f"];
                  subvolumes = {
                    "@rootfs" = {
                      mountpoint = "/";
                      mountOptions = ["subvol=@rootfs" "compress=zstd" "noatime"];
                    };
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = ["subvol=@home" "compress=zstd" "noatime"];
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = ["subvol=@nix" "compress=zstd" "noatime"];
                    };
                    "@log" = {
                      mountpoint = "/var/log";
                      mountOptions = ["subvol=@log" "compress=zstd" "noatime"];
                    };
                    "@swap" = {
                      mountpoint = "/.swap";
                      swap.swapfile.size = "64G";
                    };
                    "@snapshots" = {
                      mountpoint = "/.snapshots";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  fileSystems."/var/log".neededForBoot = true;
}


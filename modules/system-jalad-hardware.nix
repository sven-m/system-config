/*

Hardware configuration for jalad. Update using nixos-generate-config if needed.

*/

{ config, lib, pkgs, modulesPath, ... }:

{
  #hardware.enableAllFirmware = true;
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/240345b8-a148-4d60-b6cb-c2ed1ca12544";
      fsType = "btrfs";
      options = [ "subvol=@rootfs" "noatime" ];
    };

  boot.initrd.luks.devices."nixos-root".device = "/dev/disk/by-uuid/83185266-ab8d-4893-aa24-1017a894e31a";

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/240345b8-a148-4d60-b6cb-c2ed1ca12544";
      fsType = "btrfs";
      options = [ "subvol=@home" "noatime" ];
    };

  fileSystems."/var/log" =
    { device = "/dev/disk/by-uuid/240345b8-a148-4d60-b6cb-c2ed1ca12544";
      fsType = "btrfs";
      options = [ "subvol=@log" "noatime" ];
    };

  fileSystems."/.snapshots" =
    { device = "/dev/disk/by-uuid/240345b8-a148-4d60-b6cb-c2ed1ca12544";
      fsType = "btrfs";
      options = [ "subvol=@snapshots" "noatime" ];
    };

  fileSystems."/.swap" =
    { device = "/dev/disk/by-uuid/240345b8-a148-4d60-b6cb-c2ed1ca12544";
      fsType = "btrfs";
      options = [ "subvol=@swap" "noatime" ];
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp42s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

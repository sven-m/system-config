# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, username, home-manager, ... }:

{
  imports = [
    ./system-temba-hardware.nix
  ];

  environment.sessionVariables = {
    CFG_NAME = "temba";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "temba";
  networking.networkmanager.enable = true;

  boot.initrd.availableKernelModules = [ "9p" "9pnet_virtio" ];
  fileSystems."/mnt/utm" = {
    device = "share";
    fsType = "9p";
    options = [
      "trans=virtio" "version=9p2000.L" "rw" "_netdev" "nofail"
      "x-systemd.automount" "x-systemd.idle-timeout=30"
    ];
  };

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      claude-code
    ];
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  system.stateVersion = "26.05";
}


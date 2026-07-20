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

  services.kmscon = {
    enable = true;
    hwRender = false;
    extraConfig = ''
      term=xterm-256color
      font-name=monospace
      font-size=28
      palette=custom
      palette-black=69,71,90
      palette-red=243,139,168
      palette-green=166,227,161
      palette-yellow=249,226,175
      palette-blue=137,180,250
      palette-magenta=245,194,231
      palette-cyan=148,226,213
      palette-light-grey=186,194,222
      palette-dark-grey=88,91,112
      palette-light-red=243,139,168
      palette-light-green=166,227,161
      palette-light-yellow=249,226,175
      palette-light-blue=137,180,250
      palette-light-magenta=245,194,231
      palette-light-cyan=148,226,213
      palette-white=166,173,200
      palette-foreground=205,214,244
      palette-background=30,30,46
    '';
  };

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      claude-code
      fbset
      libdrm
    ];
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  system.stateVersion = "26.05";
}


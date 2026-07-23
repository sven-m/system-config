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

  systemd.services."serial-getty@ttyAMA0".environment = {
    TERM = "xterm-256color";
  };

  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono nerd-fonts.symbols-only ];

  services.xserver.enable = true;
  services.xserver.dpi = 192;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.displayManager.autoLogin = { enable = true; user = username; };
  services.displayManager.defaultSession = "none+i3";

  services.spice-vdagentd.enable = true;

  home-manager.users.${username} = {
    xsession.windowManager.i3 = {
      enable = true;
      config = {
        modifier = "Mod4";
        terminal = "urxvt";
        startup = [
          { command = "spice-vdagent"; notification = false; }
        ];
        bars = [{
          fonts = {
            names = [ "JetBrainsMono Nerd Font" "monospace" ];
            size = 24.0;
          };
        }];
      };
    };

    xresources.properties = {
      "URxvt.font"      = "xft:JetBrainsMono Nerd Font:size=24,xft:Symbols Nerd Font Mono:size=24";
      "URxvt.scrollBar" = "false";
      # Catppuccin Mocha
      "*.foreground" = "#CDD6F4";
      "*.background" = "#1E1E2E";
      "*.color0"     = "#45475A";
      "*.color1"     = "#F38BA8";
      "*.color2"     = "#A6E3A1";
      "*.color3"     = "#F9E2AF";
      "*.color4"     = "#89B4FA";
      "*.color5"     = "#F5C2E7";
      "*.color6"     = "#94E2D5";
      "*.color7"     = "#BAC2DE";
      "*.color8"     = "#585B70";
      "*.color9"     = "#F38BA8";
      "*.color10"    = "#A6E3A1";
      "*.color11"    = "#F9E2AF";
      "*.color12"    = "#89B4FA";
      "*.color13"    = "#F5C2E7";
      "*.color14"    = "#94E2D5";
      "*.color15"    = "#A6ADC8";
    };
  };

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      claude-code
      rxvt-unicode
    ];
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  system.stateVersion = "26.05";
}

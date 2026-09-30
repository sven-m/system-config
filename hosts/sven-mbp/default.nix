{ config, lib, pkgs, pkgs-unstable, username, ... }:

{
  imports = [
    ../../modules/common
    ../../modules/packages
    ../../modules/darwin
    ../../modules/bash
    ../../modules/fzf
    ../../modules/starship
    ../../modules/tmux
    ../../modules/git
    ../../modules/lazygit
    ../../modules/ghostty
    ../../modules/ssh
    ../../modules/1password
    ../../modules/nvim
    ../../modules/xcode
    ../../modules/android
    ../../modules/ansible
    ../../modules/npm
    ../../modules/gdu
    ../../modules/cfg
  ];

  users.users.${username}.home = "/Users/${username}";

  services.tailscale.enable = true;

  environment.systemPackages = [
    pkgs.certbot-full
    pkgs.code-cursor
    pkgs.claude-code
    pkgs.ghidra
    pkgs.gnupg
    pkgs.libssh
    pkgs.ollama
    pkgs.openssh
    pkgs.pass
    pkgs.proton-pass
    pkgs.protonmail-desktop
    pkgs.supabase-cli
    pkgs.utm
    pkgs.vagrant
    pkgs.winbox4
  ];

  environment.shellAliases = {
  };

  homebrew.casks = [
    "balenaetcher"
    "bitcoin-core"
    "claude"
    "docker-desktop"
    "electrum"
    "google-drive"
    "iloader"
    "ios-app-signer"
    "ledger-wallet"
    "nextcloud-vfs"
    "nordvpn"
    "proton-mail-bridge"
    "raspberry-pi-imager"
    "tuna"
    "vivaldi"
  ];

  # homebrew.masApps = {
    #"Pages" = 409201541;
    #"Numbers" = 409203825;
    #"Keynote" = 409183694;
    # "Hush" = 1544743900;
    # "BioPassFIDO2" = 1456584103;
    # "MindNode Next" = 6446116532;
    # "Proton Pass for Safari" = 6502835663;
    # "Sketch" = 1667260533;
    # "Solitaire Epic" = 972224785;
    # "TestFlight" = 899247664;
    # "Bitwarden" = 1352778147;
    # "Prime Video" = 545519333;
    # "Whatsapp" = 310633997;
  # };

  system.defaults.dock.persistent-apps = [
    "/System/Applications/Apps.app"
    "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
    "/Applications/Nix Apps/Ghostty.app"
    "/Applications/Xcode-27.0.0.app"
    "/Applications/Nix Apps/WinBox.app"
    "/Applications/Claude.app"
    "/System/Applications/App Store.app"
    "/System/Applications/System Settings.app"
  ];
}

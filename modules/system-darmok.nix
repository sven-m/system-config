/*

Configuration for darmok (macOS)

- homebrew formulas and casks
- Mac App Store apps
- Dock items

*/

{ config, lib, pkgs, pkgs-unstable, username, ... }:

{
  users.users.${username}.home = "/Users/${username}";

  services.tailscale.enable = true;

  environment.variables = {
    CFG_NAME = "darmok";
    NEOVIM_VIMWIKI_MAGIC_MERGE_ENABLED = "1";
  };

  environment.systemPackages = [
    pkgs.certbot-full
    pkgs.code-cursor
    pkgs.claude-code
    pkgs.ghidra
    pkgs.gnupg
    pkgs.ollama
    pkgs.pass
    pkgs.supabase-cli
    pkgs.winbox4
  ];

  environment.shellAliases = {
  };

  homebrew.brews = [
    "libssh"
    "openssh"
  ];

  homebrew.casks = [
    "balenaetcher"
    "bitcoin-core"
    "claude"
    "docker-desktop"
    "electrum"
    "google-drive"
    "ledger-wallet"
    "iloader"
    "ios-app-signer"
    "nextcloud-vfs"
    "nordvpn"
    "obsidian"
    "proton-mail-bridge"
    "proton-mail"
    "proton-pass"
    "raspberry-pi-imager"
    "tuna"
    "utm"
    "vagrant"
    "vivaldi"
    "whatsapp"
  ];

  homebrew.masApps = {
    #"Pages" = 409201541;
    #"Numbers" = 409203825;
    #"Keynote" = 409183694;
    "Hush" = 1544743900;
    "BioPassFIDO2" = 1456584103;
    "MindNode Next" = 6446116532;
    "Proton Pass for Safari" = 6502835663;
    "Sketch" = 1667260533;
    "Solitaire Epic" = 972224785;
    "TestFlight" = 899247664;
    "Bitwarden" = 1352778147;
    "Prime Video" = 545519333;
  };

  system.defaults.dock.persistent-apps = [
    "/System/Applications/Apps.app"
    "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
    "/Applications/Ghostty.app"
    "/Applications/Xcode-26.5.0.app"
    "/Applications/Nix Apps/WinBox.app"
    "/Applications/Claude.app"
    "/System/Applications/App Store.app"
    "/System/Applications/System Settings.app"
  ];
}

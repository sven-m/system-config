/*

Configuration for darmok (macOS)

- homebrew formulas and casks
- Mac App Store apps
- Dock items

*/

{ config, lib, pkgs, username, ... }:

{
  users.users.${username}.home = "/Users/${username}";

  environment.variables = {
    CFG_NAME = "darmok";
    NEOVIM_VIMWIKI_MAGIC_MERGE_ENABLED = "1";
  };

  environment.systemPackages = [
    pkgs.transmission_3
    pkgs.uv
    pkgs.pass
    pkgs.gnupg
    pkgs.code-cursor
  ];

  environment.shellAliases = {
  };

  homebrew.brews = [
    "swiftformat"
    "xcbeautify"
    "xcode-build-server"
  ];

  homebrew.casks = [
    "balenaetcher"
    "bitcoin-core"
    "docker-desktop"
    "electrum"
    "google-drive"
    "ledger-live"
    "nextcloud-vfs"
    "nordvpn"
    "obsidian"
    "raspberry-pi-imager"
    "utm"
    "vagrant-vmware-utility"
    "vagrant"
    "vivaldi"
    "vmware-fusion"
    "whatsapp"
  ];

  homebrew.masApps = {
    "Pages" = 409201541;
    "Numbers" = 409203825;
    "Keynote" = 409183694;
    "Hush" = 1544743900;
  };

  system.defaults.dock.persistent-apps = [
    "/System/Applications/Apps.app"
    "/Applications/Brave Browser.app"
    "/Applications/Ghostty.app"
    "/Applications/Xcode-26.0.1.app"
    "/System/Applications/App Store.app"
    "/System/Applications/System Settings.app"
  ];
}

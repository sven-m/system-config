/*

Configuration for darmok (macOS)

- homebrew formulas and casks
- Mac App Store apps
- Dock items

*/

{ config, lib, pkgs, username, ... }:

{
  users.users.${username}.home = "/Users/${username}";

  environment.systemPackages = [
    pkgs.transmission_3
    pkgs.uv
    pkgs.pass
    pkgs.gnupg
  ];

  environment.shellAliases = {
    rebuild-cfg = "sudo darwin-rebuild switch --flake $CFG_HOME#darmok";
  };

  homebrew.casks = [
    "balenaetcher"
    "bitcoin-core"
    "docker"
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
    "/System/Applications/Launchpad.app"
    "/Applications/Brave Browser.app"
    "/Applications/Ghostty.app"
    "/Applications/Xcode-16.4.0.app"
    "/System/Applications/App Store.app"
    "/System/Applications/System Settings.app"
  ];
}

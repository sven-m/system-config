/*

Configuration for darmok (macOS)

- homebrew formulas and casks
- Mac App Store apps
- Dock items
*/

{ config, lib, pkgs, ... }:

{
  users.users.sven.home = "/Users/sven";

  environment.systemPackages = [
    pkgs.transmission_3
  ];

  homebrew.casks = [
    "balenaetcher"
    "bitcoin-core"
    "docker"
    "electrum"
    "google-drive"
    "ledger-live"
    "nordvpn"
    "obsidian"
    "raspberry-pi-imager"
    "utm"
    "vagrant-vmware-utility"
    "vagrant"
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
    "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
    "/Applications/Ghostty.app"
    "/Applications/Xcode-16.3.0.app"
    "/System/Applications/App Store.app"
    "/System/Applications/System Settings.app"
  ];
}

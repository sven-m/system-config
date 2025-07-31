/*

Configuration for tanagra (macOS)

- home directory
- homebrew formulas and casks
- Mac App Store apps
- Dock items

*/

{ config, lib, pkgs, username, ... }:

{
  users.users.${username}.home = "/Users/${username}";

  environment.systemPackages = [
    pkgs.typescript
    pkgs.jetbrains.idea-ultimate
  ];

  environment.shellAliases = {
    rebuild-cfg = "sudo darwin-rebuild switch --flake $CFG_HOME#tanagra";
  };


  homebrew.casks = [
    "zoom"
  ];

  homebrew.masApps = {
  };

  system.defaults.dock.persistent-apps = [
    "/System/Applications/Launchpad.app"
    "/Applications/Brave Browser.app"
    "/Applications/Ghostty.app"
    "/Applications/Xcode-16.4.0.app"
    "/Applications/Slack.app"
    "/System/Applications/App Store.app"
    "/System/Applications/System Settings.app"
  ];
}

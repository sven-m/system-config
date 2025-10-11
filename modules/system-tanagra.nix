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

  environment.variables = {
    CFG_NAME = "tanagra";
  };

  environment.systemPackages = [
    pkgs.typescript
    pkgs.jetbrains.idea-ultimate
  ];

  environment.shellAliases = {
  };


  homebrew.casks = [
    "zoom"
  ];

  homebrew.masApps = {
  };

  system.defaults.dock.persistent-apps = [
    "/System/Applications/Apps.app"
    "/Applications/Brave Browser.app"
    "/Applications/Ghostty.app"
    "/Applications/Xcode-26.0.1.app"
    "/Applications/Slack.app"
    "/System/Applications/App Store.app"
    "/System/Applications/System Settings.app"
  ];
}

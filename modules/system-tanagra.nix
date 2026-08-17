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
    pkgs.jetbrains.idea
    pkgs.lynx
  ];

  environment.shellAliases = {
  };


  homebrew.casks = [
    "github-copilot-for-xcode"
    "zoom"
  ];

  homebrew.masApps = {
    "Slack for Desktop" = 803453959;
  };

  system.defaults.dock.persistent-apps = [
    "/System/Applications/Apps.app"
    "/Applications/Brave Browser.app"
    "/Applications/Ghostty.app"
    "/Applications/Xcode-26.5.0.app"
    "/Applications/GitHub Copilot for Xcode.app"
    "/Applications/Slack.app"
    "/System/Applications/App Store.app"
    "/System/Applications/System Settings.app"
    "/Applications/Admin By Request.app"
  ];
}

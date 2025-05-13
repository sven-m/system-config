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

  environment.shellAliases = {
    rebuild-cfg = "darwin-rebuild switch --flake $CFG_HOME#tanagra";
  };


  homebrew.casks = [
    "zoom"
  ];

  homebrew.masApps = {
  };

  system.defaults.dock.persistent-apps = [
    "/System/Applications/Launchpad.app"
    "/Applications/Google Chrome.app"
    "/Applications/Ghostty.app"
    "/Applications/Xcode-16.3.0.app"
    "/Applications/Slack.app"
    "/Applications/Microsoft Teams.app"
    "/Applications/Microsoft Outlook.app"
    "/System/Applications/App Store.app"
    "/System/Applications/System Settings.app"
  ];
}

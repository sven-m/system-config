{ config, lib, pkgs, ... }:

{
  users.users.sven.home = "/Users/sven";

  homebrew.casks = [
    "zoom"
  ];

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

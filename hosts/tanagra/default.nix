{ config, lib, pkgs, username, ... }:

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
    ../../modules/1password
    ../../modules/nvim
    ../../modules/xcode
    ../../modules/android
    ../../modules/sublime
    ../../modules/ansible
    ../../modules/npm
    ../../modules/gdu
    ../../modules/cfg
  ];

  users.users.${username}.home = "/Users/${username}";

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

  # App Store apps are installed by hand, not through homebrew.masApps
  #   "Slack for Desktop" = 803453959;

  system.defaults.dock.persistent-apps = [
    "/System/Applications/Apps.app"
    "/Applications/Brave Browser.app"
    "/Applications/Ghostty.app"
    "/Applications/Xcode-27.0.0.app"
    "/Applications/Slack.app"
    "/System/Applications/App Store.app"
    "/System/Applications/System Settings.app"
    "/Applications/Admin By Request.app"
  ];
}

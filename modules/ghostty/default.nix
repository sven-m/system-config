/*

Ghostty config (the app itself: cask on macOS, host packages on Linux)

*/

{ username, ... }:

{
  home-manager.users.${username} = {
    xdg.configFile."ghostty/config".source = ./config;
  };
}

/*

lazygit

*/

{ pkgs, username, ... }:

{
  environment.systemPackages = [ pkgs.lazygit ];

  home-manager.users.${username} = {
    xdg.configFile."lazygit/config.yml".source = ./config.yml;
  };
}

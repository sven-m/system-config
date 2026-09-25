/*

gdu, disk usage analyzer

*/

{ pkgs-unstable, username, ... }:

{
  environment.systemPackages = [ pkgs-unstable.gdu ];

  home-manager.users.${username} = {
    xdg.configFile."gdu/gdu.yaml".source = ./gdu.yaml;
  };
}

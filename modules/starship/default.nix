/*

Starship prompt

*/

{ pkgs, username, ... }:

{
  environment.systemPackages = [ pkgs.starship ];

  home-manager.users.${username} = {
    xdg.configFile."starship.toml".source = ./starship.toml;
  };
}

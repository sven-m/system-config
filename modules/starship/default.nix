/*

Starship prompt

*/

{ lib, pkgs, username, ... }:

{
  environment.systemPackages = [ pkgs.starship ];

  home-manager.users.${username} = {
    xdg.configFile."starship.toml".source = ./starship.toml;

    # last, since it sets the prompt
    programs.bash.initExtra = lib.mkAfter ''
      eval "$(${pkgs.starship}/bin/starship init bash)"
    '';
  };
}

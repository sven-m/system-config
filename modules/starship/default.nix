/*

Starship prompt, through home-manager: settings from ./starship.toml, prompt
hook in ~/.bashrc (after the other init code)

*/

{ username, ... }:

{
  home-manager.users.${username} = {
    programs.starship = {
      enable = true;
      enableBashIntegration = true;
      settings = builtins.fromTOML (builtins.readFile ./starship.toml);
    };
  };
}

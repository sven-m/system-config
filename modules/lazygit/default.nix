/*

lazygit

*/

{ pkgs, username, ... }:

{
  environment.systemPackages = [ pkgs.lazygit ];

  home-manager.users.${username} = {
    xdg.configFile."lazygit/config.yml".source = ./config.yml;

    # lazygit's default on macOS is ~/Library/Application Support/lazygit
    programs.bash.bashrcExtra = ''
      export LG_CONFIG_FILE="''${XDG_CONFIG_HOME:-$HOME/.config}/lazygit/config.yml"
    '';
  };
}

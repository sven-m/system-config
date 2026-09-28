{ pkgs, username, ... }:

{
  environment.systemPackages = [ pkgs.lazygit ];

  # lazygit's default on macOS is ~/Library/Application Support/lazygit
  environment.variables.LG_CONFIG_FILE = "\${XDG_CONFIG_HOME:-$HOME/.config}/lazygit/config.yml";

  home-manager.users.${username} = {
    xdg.configFile."lazygit/config.yml".source = ./config.yml;
  };
}

{ username, ... }:

{
  home-manager.users.${username} = {
    xdg.configFile."ghostty/config".source = ./config;
  };
}

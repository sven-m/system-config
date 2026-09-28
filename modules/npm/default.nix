{ username, ... }:

{
  home-manager.users.${username} = { config, ... }: {
    home.file.".npmrc".text = ''
      prefix=${config.home.homeDirectory}/.local
    '';
  };
}

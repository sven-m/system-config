{ pkgs, username, ... }:

{
  environment.systemPackages = [
    pkgs.git
    pkgs.git-lfs
    pkgs.diff-so-fancy
  ];

  home-manager.users.${username} = {
    xdg.configFile."git/config".source = ./config;

    programs.bash.shellAliases = {
      gs = "git status";
      gl = "git lg1";
      gll = "git lg2";
    };
  };
}

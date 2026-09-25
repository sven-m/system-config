/*

git, git-lfs, diff-so-fancy and the shared git config

The shared config includes, in order:
- config.host: per host, written by the host module
- ~/.config/git/config.local: uncommitted, e.g. the email address

*/

{ pkgs, username, ... }:

{
  environment.systemPackages = [
    pkgs.git
    pkgs.git-lfs
    pkgs.diff-so-fancy
  ];

  home-manager.users.${username} = {
    xdg.configFile."git/config".source = ./config;
  };
}

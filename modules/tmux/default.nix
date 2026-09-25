/*

tmux, and the session picker its create-session alias runs

*/

{ pkgs, username, ... }:

{
  environment.systemPackages = [
    pkgs.tmux
    (pkgs.writeShellScriptBin "session-dir-picker" (builtins.readFile ./session-dir-picker))
  ];

  home-manager.users.${username} = {
    xdg.configFile."tmux/tmux.conf".source = ./tmux.conf;
  };
}

/*

tmux, the session picker its create-session alias runs, and the git
subcommand that both the picker and the status bar use for the branch name

*/

{ pkgs, username, ... }:

{
  environment.systemPackages = [
    pkgs.tmux
    pkgs.git
    (pkgs.writeShellScriptBin "session-dir-picker" (builtins.readFile ./session-dir-picker))
    (pkgs.writeShellScriptBin "git-symbolic-ref-or-commit" (builtins.readFile ./git-symbolic-ref-or-commit))
  ];

  home-manager.users.${username} = {
    xdg.configFile."tmux/tmux.conf".source = ./tmux.conf;
  };
}

/*

fzf, and its bash key bindings (Ctrl-r history, Ctrl-t files, Alt-c cd)

*/

{ pkgs, username, ... }:

{
  # system-wide, for scripts such as tmux's session-dir-picker
  environment.systemPackages = [ pkgs.fzf ];

  # not programs.fzf.historyWidgetOptions: that goes through home.sessionVariables
  environment.variables.FZF_CTRL_R_OPTS = "--reverse";

  # adds `eval "$(fzf --bash)"` to ~/.bashrc
  home-manager.users.${username}.programs.fzf.enable = true;
}

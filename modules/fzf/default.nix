{ pkgs, username, ... }:

{
  # system-wide for tmux's session-dir-picker
  environment.systemPackages = [ pkgs.fzf ];

  # not historyWidgetOptions, which uses home.sessionVariables
  environment.variables.FZF_CTRL_R_OPTS = "--reverse";

  home-manager.users.${username}.programs.fzf.enable = true;
}

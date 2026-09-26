/*

tmux, the session picker its create-session alias runs, and the git
subcommand that both the picker and the status bar use for the branch name

On macOS, tmux comes from nix-darwin's programs.tmux: its wrapper clears the
once-per-shell guards, so every pane re-runs nix-darwin's environment setup
(a login shell runs path_helper, which would otherwise put /usr/bin in front
of the Nix paths). The wrapper only loads /etc/tmux.conf, which sources ours.

*/

{ lib, pkgs, username, ... }:

{
  environment.systemPackages = [
    pkgs.git
    (pkgs.writeShellScriptBin "session-dir-picker" (builtins.readFile ./session-dir-picker))
    (pkgs.writeShellScriptBin "git-symbolic-ref-or-commit" (builtins.readFile ./git-symbolic-ref-or-commit))
  ] ++ lib.optional (!pkgs.stdenv.isDarwin) pkgs.tmux;

  programs.tmux = lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;
    extraConfig = ''
      # panes rebuild PATH (see above), so they must re-run home-manager's
      # session variables (home.sessionPath) instead of inheriting its marker
      set-environment -g -u __HM_SESS_VARS_SOURCED
      source-file ~/.config/tmux/tmux.conf
    '';
  };

  home-manager.users.${username} = {
    xdg.configFile."tmux/tmux.conf".source = ./tmux.conf;

    programs.bash.initExtra = ''
      tmux() {
        command_and_reset_cursor tmux "$@"
      }
    '';
  };
}

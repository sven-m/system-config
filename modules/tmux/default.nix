/*

tmux, the session picker its create-session alias runs, and the git
subcommand that both the picker and the status bar use for the branch name

tmux comes from programs.tmux on both platforms. On macOS it matters:
nix-darwin's wrapper clears the once-per-shell guards, so every pane re-runs
nix-darwin's environment setup (a login shell runs path_helper, which would
otherwise put /usr/bin in front of the Nix paths), and it only loads
/etc/tmux.conf, which sources ours. On NixOS tmux loads ~/.config/tmux/tmux.conf
itself, after /etc/tmux.conf.

*/

{ lib, pkgs, username, ... }:

{
  environment.systemPackages = [
    pkgs.git
    (pkgs.writeShellScriptBin "session-dir-picker" (builtins.readFile ./session-dir-picker))
    (pkgs.writeShellScriptBin "git-symbolic-ref-or-commit" (builtins.readFile ./git-symbolic-ref-or-commit))
  ];

  programs.tmux.enable = true;
  programs.tmux.extraConfig = lib.mkIf pkgs.stdenv.isDarwin ''
    # panes rebuild PATH (see above), so they must re-run home-manager's
    # session variables (home.sessionPath) instead of inheriting its marker
    set-environment -g -u __HM_SESS_VARS_SOURCED
    source-file ~/.config/tmux/tmux.conf
  '';

  home-manager.users.${username} = {
    xdg.configFile."tmux/tmux.conf".source = ./tmux.conf;

    # resets the cursor to a vertical bar afterwards
    programs.bash.initExtra = ''
      tmux() {
        command tmux "$@"
        local status=$?
        printf "\e[6 q"
        return $status
      }
    '';
  };
}

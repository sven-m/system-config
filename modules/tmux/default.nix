# programs.tmux on macOS: nix-darwin's wrapper makes each pane (a login shell,
# where path_helper puts /usr/bin first) redo nix-darwin's environment setup

{ lib, pkgs, username, ... }:

{
  environment.systemPackages = [
    pkgs.git
    (pkgs.writeShellScriptBin "session-dir-picker" (builtins.readFile ./session-dir-picker))
    (pkgs.writeShellScriptBin "git-symbolic-ref-or-commit" (builtins.readFile ./git-symbolic-ref-or-commit))
  ];

  programs.tmux.enable = true;
  programs.tmux.extraConfig = lib.mkIf pkgs.stdenv.isDarwin ''
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

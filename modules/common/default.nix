/*

Configuration for all systems (nixOS and macOS)

- system-wide nix packages
- shell: environment variables, shell aliases
- home-manager defaults, bat

*/

{ config, lib, pkgs, pkgs-unstable, home-manager, username, ... }:

{
  environment.shells = [ pkgs.bashInteractive ];
  programs.bash.completion.enable = true;

  environment.systemPackages = with pkgs; [
    claude-code
    coreutils
    eza
    fd
    fzf
    gnused
    less
    jq
    ripgrep
    tree
    universal-ctags
    uv
    vscode
    yamllint
  ];

  # System-wide (root too). Personal shell setup is in home-manager's
  # programs.bash, in the module it belongs to.
  environment.variables = {
    PAGER = "less";
    CLICOLOR = "1";
  };

  environment.shellAliases = {
    ll = "eza -l --git --icons=auto";
    la = "eza -a --git --icons=auto";
    lla = "eza -la --git --icons=auto";
  };

  fonts.packages = [ pkgs.nerd-fonts.meslo-lg ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = false;
  home-manager.users.${username} = {
    home.stateVersion = "23.11";

    programs.bat.enable = true;
    programs.bat.config.theme = "TwoDark";

    programs.bash.bashrcExtra = ''
      export THEOS="$HOME/theos"
    '';

    programs.bash.initExtra = ''
      export FZF_CTRL_R_OPTS="--reverse"
      eval "$(${pkgs.fzf}/bin/fzf --bash)"
    '';
  };
}

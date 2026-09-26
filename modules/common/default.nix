/*

Configuration for all systems (nixOS and macOS)

- system-wide nix packages
- shell: environment variables, shell aliases
- home-manager defaults, bat, eza

*/

{ config, lib, pkgs, pkgs-unstable, home-manager, username, ... }:

{
  environment.shells = [ pkgs.bashInteractive ];
  programs.bash.completion.enable = true;

  environment.systemPackages = with pkgs; [
    claude-code
    coreutils
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

  environment.variables = {
    ANDROID_HOME = "$HOME/Library/Android/sdk";
    THEOS = "$HOME/theos";

    EDITOR = "nvim";
    PAGER = "less";
    CLICOLOR = "1";
  };

  environment.shellAliases = {
    ll = "eza -l";
    la = "eza -a";
    lla = "eza -la";
    gs = "git status";
    gl = "git lg1";
    gll = "git lg2";
  };

  fonts.packages = [ pkgs.nerd-fonts.meslo-lg ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = false;
  home-manager.users.${username} = {
    home.stateVersion = "23.11";

    programs.bat.enable = true;
    programs.bat.config.theme = "TwoDark";

    programs.bash.initExtra = ''
      export FZF_CTRL_R_OPTS="--reverse"
      eval "$(${pkgs.fzf}/bin/fzf --bash)"
    '';

    programs.eza.enable = true;
    programs.eza.git = true;
    programs.eza.icons = "auto";
    # no ls/ll/la/lt aliases from home-manager; environment.shellAliases above has ours
    programs.eza.enableBashIntegration = false;
  };
}

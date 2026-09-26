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

  # System-wide (root too). Personal shell setup goes through home-manager,
  # in the module it belongs to.
  environment.variables = {
    PAGER = "less";
    CLICOLOR = "1";
    THEOS = "$HOME/theos";
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

    # eza plus its aliases (ls, ll, la, lt, lla), all with these options
    programs.eza.enable = true;
    programs.eza.git = true;
    programs.eza.icons = "auto";
  };
}

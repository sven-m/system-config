{ config, lib, pkgs, pkgs-unstable, home-manager, username, ... }:

{
  environment.shells = [ pkgs.bashInteractive ];
  programs.bash.completion.enable = true;

  environment.systemPackages = with pkgs; [
    claude-code
    coreutils
    fd
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

  # system-wide, so root gets them too
  environment.variables = {
    PAGER = "less";
    CLICOLOR = "1";
    THEOS = "$HOME/theos";
  };

  fonts.packages = [ pkgs.nerd-fonts.meslo-lg ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = false;
  home-manager.users.${username} = {
    home.stateVersion = "26.05";

    programs.bat.enable = true;
    programs.bat.config.theme = "TwoDark";

    # also aliases ls, ll, la, lt, lla
    programs.eza.enable = true;
    programs.eza.git = true;
    programs.eza.icons = "auto";
  };
}

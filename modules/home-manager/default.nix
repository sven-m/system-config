{pkgs, ...}: {
  home.stateVersion = "23.11";
  home.packages = with pkgs; [ 
    coreutils
    less
    alacritty
    ipatool
  ];
  home.sessionVariables = {
    PAGER = "less";
    CLICOLOR = "1";
  };
  home.shellAliases = {
    gs = "git status";
    nixswitch = "~/src/system-config/nixswitch.sh";
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    # used for more complex zsh configuration
    initExtra = "source ~/.config/zshrc_extra";
  };
  programs.neovim.enable = true;
  programs.bat.enable = true;
  programs.bat.config.theme = "TwoDark";
  programs.eza.enable = true;
  programs.git = {
    enable = true;
    diff-so-fancy = {
      enable = true;
      changeHunkIndicators = true;
    };
    extraConfig = {
      include = { path = "~/.config/git/config_extra"; };
    };
  };
  home.file.".config/git/config_extra".source = ./dotfiles/gitconfig;
  programs.ssh = {
    enable = true;
  };
  home.file.".ssh/config".source = ./dotfiles/ssh_config;
  home.file.".config/alacritty/alacritty.toml".source = ./dotfiles/alacritty.toml;
  home.file.".config/zshrc_extra".source = ./dotfiles/zshrc;
  home.file.".config/nvim/init.lua".source = ./dotfiles/nvim/init.lua;
}
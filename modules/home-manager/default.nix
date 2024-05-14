{pkgs, lib, ...}: {
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
    nixswitchflake = "nix run nix-darwin -- switch --flake";
    nixswitchmain = "nixswitchflake github:sven-m/system-config";
    nixswitchlocal = "nixswitchflake ~/src/system-config";
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
      # I prefer to have configuration in gitconfig format
      include = { path = "~/.config/git/config_extra"; };
    };
  };
  programs.ssh = {
    enable = true;
  };
  home = {
    file = {
      # These are named "*_extra" because home-manager already puts the normal file in place
      ".config/git/config_extra".source = ./dotfiles/gitconfig;
      ".config/zshrc_extra".source = ./dotfiles/zshrc;
      ".ssh/config".source = ./dotfiles/ssh_config;
      ".config/alacritty/alacritty.toml".source = ./dotfiles/alacritty.toml;
      ".config/nvim/init.lua".source = ./dotfiles/nvim/init.lua;
      "./Library/Application Support/Sublime Text/Packages/Declarative/Preferences.sublime-settings" = {
        source = ./dotfiles/Preferences.sublime-settings;
      };
    };
    activation = {
      copyAppSymLinks = lib.hm.dag.entryAfter ["writeBoundary"] ''
        rm -rf "$HOME/Applications/NixLaunchPadFix"
        mkdir "$HOME/Applications/NixLaunchPadFix"
        cp -P "$HOME/Applications/Home Manager Apps"/*.app "$HOME/Applications/NixLaunchPadFix"
      '';
    };
  };
}
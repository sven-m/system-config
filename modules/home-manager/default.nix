{ config, lib, pkgs, pkgs-unstable, ...}: 
let touchLocalConfigsScript = 
    configFileName: lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p "$(dirname "${configFileName}")"
      touch "${configFileName}"
    '';
in {
  home.stateVersion = "23.11";

  
  # Packages

  home.packages = [ 
    pkgs.coreutils
    pkgs.less
    pkgs.ipatool
    pkgs-unstable.jdk22
    pkgs.transmission
  ];


  # Shell configuration

  home.sessionVariables = {
    PAGER = "less";
    CLICOLOR = "1";
    ANDROID_HOME = "$HOME/Library/Android/sdk";
  };
  home.sessionPath = with config.home.sessionVariables; [
    "${ANDROID_HOME}/cmdline-tools/latest/bin"
    "${ANDROID_HOME}/build-tools/35.0.0-rc3/"
    "${ANDROID_HOME}/platform-tools"
    "${ANDROID_HOME}/emulator"
  ];
  home.shellAliases = {
    ll = "eza -l";
    la = "eza -a";
    lla = "eza -la";
    gs = "git status";
    gl = "git lg1";
    gll = "git lg2";
    nix-darwin-switch = "nix run nix-darwin -- switch";
    sconf = "nix-darwin-switch --flake ~/src/system-config#sven-mbp";
    econf = "nvim ~/src/system-config";
  };


  # ZSH

  programs.zsh = {
    enable = true;
    # These settings are so convenient, that the added complexity of having a generated .zshrc is
    # worth it. 
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    enableAutosuggestions = true;
    # The remaining shell configuration is done through the below included file.
    initExtra = lib.fileContents ./dotfiles/zsh/zshrc.inc.zsh;
  };
  home.activation.touchLocalZshConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    config="$HOME/.config/zsh/local.zshrc.zsh"
    mkdir -p "$(dirname "$config")"
    touch "$config"
  '';

  # Alacritty

  programs.alacritty = {
    enable = true;
    package = pkgs-unstable.alacritty;
  };
  xdg.configFile."alacritty/alacritty.toml".source = ./dotfiles/alacritty/alacritty.toml;
  

  # Neovim

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    # These settings are so convenient, that the added complexity of having a generated init.lua is
    # worth it. 
    plugins = with pkgs.vimPlugins; [
      vim-nix
      nvim-tree-lua
      {
        plugin = pkgs.vimPlugins.vim-startify;
        config = "let g:startify_change_to_vcs_root = 0";
      }
    ];
    # The remaining nvim configuration is done through the below included file.
    extraLuaConfig = lib.fileContents ./dotfiles/nvim/init.inc.lua;
  };
  home.activation.touchLocalNvimConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    config="$HOME/.config/nvim/init-local.lua"
    mkdir -p "$(dirname "$config")"
    touch "$config"
  '';


  # SSH

  programs.ssh.enable = true;
  home.file.".ssh/config".source = ./dotfiles/ssh/config;
  home.activation.touchLocalSSHConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    config="$HOME/.ssh/local_config"
    mkdir -p "$(dirname "$config")"
    touch "$config"
  '';
  

  # Git

  programs.git = {
    enable = true;
    # These settings are so convenient, that the added complexity of having a generated .gitconfig
    # is worth it. 
    diff-so-fancy = {
      enable = true;
      changeHunkIndicators = true;
    };
    # The remaining git configuration is done through the below included file.
    extraConfig = {
      # I prefer to have configuration in gitconfig format
      include = { path = "~/.config/git/extra.gitconfig"; };
    };
  };
  xdg.configFile."git/extra.gitconfig".source = ./dotfiles/git/extra.gitconfig;
  home.activation.touchLocalGitConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    config="$HOME/.config/git/local.gitconfig"
    mkdir -p "$(dirname "$config")"
    touch "$config"
  '';

  
  # Other programs

  programs.bat.enable = true;
  programs.bat.config.theme = "TwoDark";
  programs.eza = {
    enable = true;
    git = true;
    icons = true;
  };

  # Sublime Text
  home.file."./Library/Application Support/Sublime Text/Packages/Declarative/Preferences.sublime-settings" = {
    source = ./dotfiles/sublime/Preferences.sublime-settings;
  };


  # Copy all macOS application symlinks to ~/Applicationos

  home.activation.copyAppSymLinks = 
  lib.hm.dag.entryAfter ["writeBoundary"] ''
    fix_path="$HOME/Applications/NixLaunchPadFix"
    rm -rf "$fix_path"
    mkdir "$fix_path"
    cp -P "$HOME/Applications/Home Manager Apps"/*.app "$fix_path"
  '';
}

{ config, lib, pkgs, pkgs-unstable, dotfilesDir, ...}: 
let dotfilesDir = "${config.home.homeDirectory}/src/system-config/modules/home-manager/dotfiles"; in
{
  home.stateVersion = "23.11";

  
  # Packages

  home.packages = [ 
    pkgs.coreutils
    pkgs.less
    pkgs.ipatool
    pkgs.transmission_3
    pkgs.gnused
    pkgs.s3cmd
    pkgs.iperf2
    pkgs.kubernetes-helm
    pkgs.sshpass
    pkgs.chatgpt-cli
    pkgs.yamllint
    pkgs.vscode
    pkgs.nodePackages.nodejs
    pkgs.tree
    pkgs.ideviceinstaller
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
    # These settings are so convienent, that the added complexity of splitting the config between
    # this file and "dotfiles/zsh/zshrc" is worth it
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    dotDir = ".config/zsh";
    initExtra = /* sh */ ''
    source "${dotfilesDir}/zsh/zshrc"
    '';
    envExtra = /* sh */ ''
    source "${dotfilesDir}/zsh/zshenv_local"
    '';
  };

  # This allows for having local env variables that I do not want to risk checking into source control
  home.activation.touchLocalZshenv = lib.hm.dag.entryAfter ["writeBoundary"] /* sh */ ''
    touch "${dotfilesDir}/zsh/zshenv_local"
  '';


  # fzf

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    fileWidgetOptions = [
      "--preview 'bat {}'"
    ];
  };


  # Alacritty

  programs.alacritty = {
    enable = true;
    package = pkgs.alacritty;
  };
  xdg.configFile."alacritty/alacritty.toml".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/alacritty/alacritty.toml";
  

  # Neovim

  programs.neovim = {
    # These settings are so convenient, that the added complexity of having a generated init.lua is
    # worth it. 
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      nvim-tree-lua
      {
        plugin = pkgs.vimPlugins.vim-startify;
        config = "let g:startify_change_to_vcs_root = 0";
      }
      nvim-treesitter.withAllGrammars
    ];
    # This will include nvim/lua/settings.lua
    extraLuaConfig = /* lua */ ''
    require("settings")
    '';
  };

  # This will take all files in nvim/lua and link them in ~/.config/nvim/lua
  xdg.configFile."nvim/lua".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/nvim/lua";

  # SSH

  programs.ssh.enable = true;
  home.file.".ssh/config".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/ssh/config";
  

  # Git

  programs.git = {
    # These settings are so convienent, that the added complexity of splitting the config between
    # this file and "main.gitconfig" is worth it
    enable = true;
    diff-so-fancy = {
      enable = true;
      changeHunkIndicators = true;
    };
    includes = [
      # I prefer to have configuration in gitconfig format
      { path = "${dotfilesDir}/git/main.gitconfig"; }
    ];
  };

  
  # Other programs

  programs.bat.enable = true;
  programs.bat.config.theme = "TwoDark";
  programs.eza = {
    enable = true;
    git = true;
    icons = "auto";
  };
  programs.gpg.enable = true;

  # Sublime Text
  home.file."./Library/Application Support/Sublime Text/Packages/Declarative/Preferences.sublime-settings" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/sublime/Preferences.sublime-settings";
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

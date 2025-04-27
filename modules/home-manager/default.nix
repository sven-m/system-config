{ config, lib, pkgs, pkgs-unstable, systemName, ...}: 
let
  systemConfigDir = "${config.home.homeDirectory}/src/system-config";
  dotfilesDir = "${systemConfigDir}/modules/home-manager/dotfiles";
in {

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

  # Shell configuration, here so that I can switch shells without migrating these. Never happens.
  home.sessionVariables = {
    PAGER = "less";
    CLICOLOR = "1";
    ANDROID_HOME = "$HOME/Library/Android/sdk";
    THEOS = "$HOME/theos";
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
    sconf = "nix run nix-darwin -- switch --flake ${systemConfigDir}#${systemName}";
    econf = "$EDITOR ${systemConfigDir}";
  };

  # ZSH
  # This will install zsh and apply some really convenient home-manager options, which will make
  # ~/.zshrc a link to a read-only file in the nix store. The remaining configuration is done
  # through `dotfiles/zsh/zshrc`, which is configured to be sourced below.
  #
  # Local env variables that must not be checked into source control go into 
  # `dotfiles/zsh/zshenv_local`.
  programs.zsh = {
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
  home.activation.touchLocalZshenv = lib.hm.dag.entryAfter ["writeBoundary"] /* sh */ ''
    touch "${dotfilesDir}/zsh/zshenv_local"
  '';

  # Install fzf, all configuration is here.
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    fileWidgetOptions = [
      "--preview 'bat {}'"
    ];
  };

  # Alacritty
  # This will install the Alacritty app. All configuration is done through files in the
  # `dotfiles/alacritty` directory.
  programs.alacritty.enable = true;
  xdg.configFile."alacritty" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/alacritty";
  };

  # Neovim.
  # This will install neovim. Plugins are listed here, remaining configuration is done through
  # files in `dotfiles/nvim` directory.
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      nvim-tree-lua
      vim-startify
      nvim-treesitter.withAllGrammars
    ];
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/nvim";
  };

  # SSH
  programs.ssh.enable = true;
  home.file.".ssh/config" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/ssh/config";
  };

  # Git
  # This will install git and apply some really convenient home-manager options. This will make
  # ~/.config/git to be a link to a read-only file in the nix store. The remaining configuration
  # is done through `dotfiles/git/config`.
  programs.git = {
    enable = true;
    diff-so-fancy = {
      enable = true;
      changeHunkIndicators = true;
    };
    includes = [
      { path = "${dotfilesDir}/git/config"; }
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
  # Configuration of sublime text is done through `dotfiles/sublime/Preferences.sublime-settings`.
  home.file."./Library/Application Support/Sublime Text/Packages/Declarative/Preferences.sublime-settings" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/sublime/Preferences.sublime-settings";
  };

  # Copy all macOS application symlinks to ~/Applications, so that Launch Pad finds them
  home.activation.copyAppSymLinks = 
  lib.hm.dag.entryAfter ["writeBoundary"] ''
    fix_path="$HOME/Applications/NixLaunchPadFix"
    rm -rf "$fix_path"
    mkdir "$fix_path"
    cp -P "$HOME/Applications/Home Manager Apps"/*.app "$fix_path"
  '';
}

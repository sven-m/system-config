/*

Configuration for all systems (nixOS and macOS)

- system-wide nix packages
- shell: environment variables, shell aliases
- home-manager: tmux plugins, bat, eza, neovim plugins
*/

{ config, lib, pkgs, pkgs-unstable, home-manager, username, ... }:

{
  environment.shells = [ pkgs.bashInteractive ];
  programs.bash.completion.enable = true;

  environment.systemPackages = with pkgs; [
    btop
    coreutils
    diff-so-fancy # used in gitconfig
    fzf
    git
    git-lfs # needed for some projects
    gnused
    ideviceinstaller
    ipatool
    iperf2
    kubernetes-helm
    lazygit
    less
    mitmproxy
    nodePackages.nodejs
    s3cmd
    sshpass
    starship # prompt for shell
    stow # used for dotfiles
    tmux
    tree
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

    home.file.".config/tmux/plugins" = let
      tmuxPlugins = with pkgs.tmuxPlugins; pkgs.linkFarm "tmux-plugins" [
        {
          name = "catppuccin";
          path = "${catppuccin}/share/tmux-plugins/catppuccin";
        }
        {
          name = "cpu";
          path = "${cpu}/share/tmux-plugins/cpu";
        }
        {
          name = "battery";
          path = "${battery}/share/tmux-plugins/battery";
        }
        {
          name = "resurrect";
          path = "${resurrect}/share/tmux-plugins/resurrect";
        }
      ];
    in {
      source = tmuxPlugins;
    };

    programs.bat.enable = true;
    programs.bat.config.theme = "TwoDark";

    programs.eza.enable = true;
    programs.eza.git = true;
    programs.eza.icons = "auto";


    programs.neovim.enable = true;
    programs.neovim.plugins = with pkgs.vimPlugins; [
      vim-nix
      nvim-tree-lua
      vim-startify
      nvim-treesitter.withAllGrammars
      vimwiki
      catppuccin-nvim
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-path
      cmp-buffer
    ];
  };
}

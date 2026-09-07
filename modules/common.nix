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
    claude-code
    coreutils
    diff-so-fancy
    fd
    fzf
    git
    git-lfs
    gnused
    lazygit
    less
    jq
    ripgrep
    starship
    stow
    tmux
    tree
    universal-ctags
    uv
    vscode
    yamllint
  ];

  environment.variables = {
    ANDROID_HOME = "$HOME/Library/Android/sdk";
    THEOS = "$HOME/theos";
    ANSIBLE_VAULT_PASSWORD_FILE = "$HOME/.local/bin/personal-ansible-vault-pass";

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
    programs.neovim.withRuby = true;
    programs.neovim.withPython3 = false;
    programs.neovim.plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      cmp-buffer
      cmp-nvim-lsp
      cmp-path
      gitsigns-nvim
      lualine-nvim
      nvim-cmp
      nvim-dap
      nvim-dap-ui
      nvim-lsp-file-operations
      nvim-tree-lua
      nvim-treesitter.withAllGrammars
      nui-nvim
      lualine-nvim
      snacks-nvim
      telescope-fzf-native-nvim
      telescope-nvim
      vim-gutentags
      vim-nix
      (
        pkgs.vimUtils.buildVimPlugin {
          pname = "xcodebuild-nvim";
          version = "unstable";
          nvimSkipModules = [
            "xcodebuild.integrations.fzf-lua"
            "xcodebuild.integrations.telescope-nvim"
            "xcodebuild.integrations.snacks-picker"
            "xcodebuild.code_coverage.report"
          ];
          src = pkgs.fetchFromGitHub {
            owner = "wojciech-kulik";
            repo = "xcodebuild.nvim";
            rev = "633eb71c0b354581837025581b7261dbe5361226";
            hash = "sha256-8Ooyiq9ECBTr3o2hn6cPesA8YZ2hmcCBWAVL3FciBRU=";
          };
        }
      )
      (
        pkgs.vimUtils.buildVimPlugin {
          pname = "vimwiki-wikilinks";
          version = "v2024.01.24-wikilinks";
          src = pkgs.fetchFromGitHub {
            owner = "sven-m";
            repo = "vimwiki";
            rev= "602920c7dc66badb58540b91ba0be872bf430375";
            hash = "sha256-jHR0Q3XLEdn2Og5AzTNXIFEvVpz9SCjUb2ms5V7YjSY=";
          };
        }
      )
    ];
  };
}

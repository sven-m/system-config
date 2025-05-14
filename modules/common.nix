/*

Configuration for all systems (nixOS and macOS)

- system-wide nix packages
- shell: environment variables, shell aliases
- home-manager: tmux plugins, bat, eza, neovim plugins
*/

{ config, lib, pkgs, home-manager, username, ... }:

{
  environment.shells = [ pkgs.bashInteractive ];
  programs.bash.completion.enable = true;

  environment.systemPackages = with pkgs; [
    git
    btop
    coreutils
    diff-so-fancy # used in gitconfig
    fzf
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
    BASH_ENV = "$HOME/.bash_env";
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
    modify-cfg = "$EDITOR \"$CFG_HOME\"";
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

    home.activation.cfgEnvironment = let 
      configHomeEnvFile = "$HOME/.config/cfg_home_env";
      gitConfigLocalFile = "$HOME/.config/git/config.local";
      gitConfigCommand = /* sh */ "${pkgs.git}/bin/git config --file ${gitConfigLocalFile} user.email";
    in
    home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ] /* sh */ ''
    set -euo pipefail

    if ! ${gitConfigCommand}
    then
      read -p "Git author email: " user_email

      if [ -n "$user_email" ]
      then
        ${gitConfigCommand} "$user_email"
        echo "✅ Git user.email set to $user_email in ${gitConfigLocalFile}"
      else
        echo "Not configuring git user.email."
      fi
    fi

    echo "Loading CFG_HOME from ~/.config/cfg_home_env..."
    source "$HOME/.config/cfg_home_env" 

    pushd "$CFG_HOME/dotfiles"
    echo ${pkgs.stow}/bin/stow --verbose .
    popd

    '';
  };
}

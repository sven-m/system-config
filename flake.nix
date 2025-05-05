{
  description = "nix macos sven-mbp";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {self, nixpkgs, home-manager, darwin, ... }:
  let
    username = "sven";
    system = "aarch64-darwin";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    darwin-config = rec {
      environment.shells = [ pkgs.bash pkgs.zsh ];
      environment.systemPackages = with pkgs; [
        kitty # main terminal
        alacritty
        stow # used for dotfiles
        tmux
        fzf
        diff-so-fancy # used in gitconfig
        starship # prompt for shell
        xcodes
        coreutils
        tree
        less
        sshpass
        ipatool
        transmission_3
        gnused
        s3cmd
        iperf2
        kubernetes-helm
        yamllint
        vscode
        nodePackages.nodejs
        ideviceinstaller
      ];
      homebrew = {
        enable = true;
        onActivation = {
          cleanup = "zap";
          autoUpdate = true;
          upgrade = true;
        };
        brews = [
          "libimobiledevice"
          "qemu"
          "cirruslabs/cli/tart"
          "cirruslabs/cli/orchard"
          "libvirt"
          "libvirt-glib"
          "ansible"
          "aria2"
          "ideviceinstaller"
        ];
        taps = [
          "cirruslabs/cli"
        ];
        casks = [
          "xcodes"
          "daisydisk"
          "qlmarkdown"
          "wireshark"
          "whatsapp"
          "mac-mouse-fix"
          "transmit"
          "sublime-text"
          "spotify"
          "1password"
          "1password-cli"
          "android-studio"
          "google-drive"
          "vagrant"
          "utm"
          "docker"
          "vmware-fusion"
          "vagrant-vmware-utility"
          "balenaetcher"
          "raspberry-pi-imager"
          "google-chrome"
          "electrum"
          "bitcoin-core"
          "nordvpn"
          "ledger-live"
          "obsidian"
          "sf-symbols"
          "caffeine"
        ];
        masApps = {
          "1Password for Safari" = 1569813296;
          "Apple Configurator" = 1037126344;
          "Things" = 904280696;
          "Pages" = 409201541;
          "Numbers" = 409203825;
          "Keynote" = 409183694;
          "Hush" = 1544743900;
        };
      };
      environment.variables = {
        BASH_ENV = "$HOME/.bash_env";
        ZDOTDIR = "$HOME/.config/zsh";
        ANDROID_HOME = "$HOME/Library/Android/sdk";
        THEOS = "$HOME/theos";

        EDITOR = "nvim";
        PAGER = "less";
        CLICOLOR = "1";
      };
      environment.systemPath = with environment.variables; [
        "${ANDROID_HOME}/cmdline-tools/latest/bin"
        "${ANDROID_HOME}/build-tools/35.0.0-rc3/"
        "${ANDROID_HOME}/platform-tools"
        "${ANDROID_HOME}/emulator"
      ];
      environment.shellAliases = {
        ll = "eza -l";
        la = "eza -a";
        lla = "eza -la";
        gs = "git status";
        gl = "git lg1";
        gll = "git lg2";
        rebuild-cfg = "sh \"$CFG_DIR\"/rebuild.sh";
        modify-cfg = "$EDITOR \"$CFG_DIR\"";
      };
      programs.bash = {
        enable = true;
        completion.enable = true;
      };
      fonts.packages = [ 
        pkgs.nerd-fonts.meslo-lg
      ];
      nix.enable = false;
      security.pam.services.sudo_local = {
        touchIdAuth = true;
        reattach = true;
      };
      system.defaults.finder.AppleShowAllExtensions = true;
      system.defaults.finder._FXShowPosixPathInTitle = true;
      system.defaults.NSGlobalDomain = {
        InitialKeyRepeat = 14;
        KeyRepeat = 1;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        ApplePressAndHoldEnabled = false;
      };
      system.defaults = {
        dock = {
          mineffect = "scale";
          mru-spaces = false;
          orientation = "left";
          showhidden = true;
          expose-animation-duration = 0.3;
          persistent-apps = [
            "/System/Applications/Launchpad.app"
            "${pkgs.alacritty}/Applications/Alacritty.app"
            "${pkgs.kitty}/Applications/kitty.app"
            "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
            "/Applications/Xcode-16.3.0.app"
            "/System/Applications/App Store.app"
            "/System/Applications/System Settings.app"
          ];
        };
        finder.FXPreferredViewStyle = "Nlsv";
        finder.ShowStatusBar = true;
        finder.FXEnableExtensionChangeWarning = false;
        menuExtraClock.ShowSeconds = true;
        menuExtraClock.ShowDayOfWeek = true;
      };
      networking.hostName = networking.computerName;
      networking.computerName = "sven-mbp";

      system.stateVersion = 4;

      users.users.${username}.home = "/Users/${username}";
    };
    home-config = {
      home.stateVersion = "23.11";

      home.file = let
        tmuxPlugins = pkgs.linkFarm "tmux-plugins" [
          { name = "catppuccin"; path = "${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin"; }
        ];
      in {
        ".config/tmux/plugins".source = tmuxPlugins;
      };

      programs.bat = {
        enable = true;
        config.theme = "TwoDark";
      };
      programs.eza = {
        enable = true;
        git = true;
        icons = "auto";
      };
      programs.neovim = {
        enable = true;
        plugins = with pkgs.vimPlugins; [
          vim-nix
          nvim-tree-lua
          vim-startify
          nvim-treesitter.withAllGrammars
          catppuccin-vim
        ];
      };
    };
  in
  {
    packages.${system}.stow = pkgs.stow;
    darwinConfigurations.macbook = darwin.lib.darwinSystem {
      inherit system;
      inherit pkgs;
      modules = [
        darwin-config
        home-manager.darwinModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = false;
            users.${username} = home-config;
          };
        }
      ];
    };
  };
}

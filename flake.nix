{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {self, nixpkgs, home-manager, darwin, ... }@inputs:
  let
    system = "aarch64-darwin";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    common-config = rec {
      system.stateVersion = 4;

      nix.enable = false;

      environment.shells = [ pkgs.bash pkgs.zsh ];
      environment.systemPackages = with pkgs; [
        btop
        bundler
        coreutils
        diff-so-fancy # used in gitconfig
        dockutil # useful for getting dockitems
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
        xcodes
        yamllint
      ];
      homebrew.enable = true;
      homebrew.onActivation = {
        cleanup = "zap";
        autoUpdate = true;
        upgrade = true;
      };
      homebrew.brews = [
        "mas"
        "libimobiledevice"
        "ansible"
        "aria2"
        "ideviceinstaller"
      ];
      homebrew.taps = [
      ];
      homebrew.casks = [
        "1password-cli"
        "1password"
        "android-studio"
        "caffeine"
        "charles"
        "daisydisk"
        "ghostty"
        "google-chrome"
        "mac-mouse-fix"
        "qlmarkdown"
        "sf-symbols"
        "spotify"
        "sublime-text"
        "transmit"
        "wireshark"
        "xcodes"
      ];
      homebrew.masApps = {
        "1Password for Safari" = 1569813296;
        "Apple Configurator" = 1037126344;
        "Things" = 904280696;
      };

      environment.variables = {
        BASH_ENV = "$HOME/.bash_env";
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

      programs.bash.enable = true;
      programs.bash.completion.enable = true;
      fonts.packages = [ pkgs.nerd-fonts.meslo-lg ];
      security.pam.services.sudo_local.touchIdAuth = true;
      security.pam.services.sudo_local.reattach = true;
      system.keyboard.enableKeyMapping = true;
      system.keyboard.nonUS.remapTilde = true;
      system.defaults.NSGlobalDomain = {
        InitialKeyRepeat = 14;
        KeyRepeat = 1;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        ApplePressAndHoldEnabled = false;
      };
      system.defaults.dock = {
        mineffect = "scale";
        mru-spaces = false;
        orientation = "left";
        showhidden = true;
        expose-animation-duration = 0.3;
      };
      system.defaults.menuExtraClock.ShowSeconds = true;
      system.defaults.menuExtraClock.ShowDayOfWeek = true;
      system.defaults.finder = {
        FXPreferredViewStyle = "Nlsv";
        ShowStatusBar = true;
        FXEnableExtensionChangeWarning = false;
        AppleShowAllExtensions = true;
        _FXShowPosixPathInTitle = true;
      };

      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = false;
      home-manager.users.sven = {
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

        home.activation.copyFile = let 
          catppuccin-xcode = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "xcode";
            rev = "6b483ce504a8b0c558d85a0663ebbcbfc457c2b0";
            sha256 = "sha256-F9sUoBPJ2kE2wt2FIIrOWhJOacsxYC1tp1ksh++TDG8=";
          };
          filename = "Catppuccin Mocha.xccolortheme";
          source = "${catppuccin-xcode}/themes/${filename}";
          destination = "$HOME/Library/Developer/Xcode/UserData/FontAndColorThemes/${filename}";
        in
        inputs.home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ] /* sh */ ''
        cp "${source}" "${destination}"
        chmod 644 "${destination}"
        '';

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
        ];
      };
    };

    darmok = {
      users.users.sven.home = "/Users/sven";

      environment.systemPackages = [ pkgs.transmission_3 ];

      homebrew.casks = [
        "balenaetcher"
        "bitcoin-core"
        "docker"
        "electrum"
        "google-drive"
        "ledger-live"
        "nordvpn"
        "obsidian"
        "raspberry-pi-imager"
        "utm"
        "vagrant-vmware-utility"
        "vagrant"
        "vmware-fusion"
        "whatsapp"
      ];
      homebrew.masApps = {
        "Pages" = 409201541;
        "Numbers" = 409203825;
        "Keynote" = 409183694;
        "Hush" = 1544743900;
      };
      system.defaults.dock.persistent-apps = [
        "/System/Applications/Launchpad.app"
        "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
        "/Applications/Ghostty.app"
        "/Applications/Xcode-16.3.0.app"
        "/System/Applications/App Store.app"
        "/System/Applications/System Settings.app"
      ];
    };

    tanagra = {
      users.users.sven.home = "/Users/sven";

      homebrew.casks = [
        "zoom"
      ];

      system.defaults.dock.persistent-apps = [
        "/System/Applications/Launchpad.app"
        "/Applications/Google Chrome.app"
        "/Applications/Ghostty.app"
        "/Applications/Xcode-16.3.0.app"
        "/Applications/Slack.app"
        "/Applications/Microsoft Teams.app"
        "/Applications/Microsoft Outlook.app"
        "/System/Applications/App Store.app"
        "/System/Applications/System Settings.app"
      ];
    };
  in
  {
    packages.${system}.stow = pkgs.stow;

    darwinConfigurations.darmok = darwin.lib.darwinSystem {
      inherit system;
      inherit pkgs;
      modules = [
        home-manager.darwinModules.home-manager
        common-config
        darmok
      ];
    };

    darwinConfigurations.tanagra = darwin.lib.darwinSystem {
      inherit system;
      inherit pkgs;
      modules = [
        home-manager.darwinModules.home-manager
        common-config
        tanagra
      ];
    };
  };
}

{
  description = "nix macos sven-mbp";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin/nix-darwin-24.11";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {self, nixpkgs, nixpkgs-unstable, home-manager, darwin, ... }:
  let
    system = "aarch64-darwin";
    pkgs = import nixpkgs {
      config.allowUnfree = true;
      inherit system;
    };
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
    darwin-config = rec {
      environment.shells = [ pkgs.bash pkgs.zsh ];
      environment.systemPackages = with pkgs; [
        alacritty
        xcodes
        coreutils
        less
        ipatool
        transmission_3
        gnused
        s3cmd
        iperf2
        kubernetes-helm
        sshpass
        chatgpt-cli
        yamllint
        vscode
        nodePackages.nodejs
        tree
        ideviceinstaller
        stow
        fzf
        diff-so-fancy
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
        ZDOTDIR = "$HOME/.config/zsh";
        EDITOR = "nvim";
        PAGER = "less";
        CLICOLOR = "1";
        ANDROID_HOME = "$HOME/Library/Android/sdk";
        THEOS = "$HOME/theos";
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
      programs.zsh = {
        enable = true;
        enableFastSyntaxHighlighting = true;
        enableFzfCompletion = true;
        enableFzfGit = true;
        enableFzfHistory = true;
        #programs.zsh.enableSyntaxHighlighting = true;
        interactiveShellInit = ''
        HISTFILE=$ZDOTDIR/zsh_history
        HISTSIZE=10000
        SAVEHIST=10000
        '';
      };
      fonts.packages = [ 
        (pkgs.nerdfonts.override { fonts = [
          "Meslo"
        ]; })
      ];
      nix.enable = false;
      security.pam.enableSudoTouchIdAuth = true;
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
      system.defaults.dock.mineffect = "scale";
      system.defaults.dock.mru-spaces = false;
      system.defaults.dock.orientation = "left";
      system.defaults.dock.showhidden = true;
      system.defaults.dock.expose-animation-duration = 0.3;
      system.defaults.finder.FXPreferredViewStyle = "Nlsv";
      system.defaults.finder.ShowStatusBar = true;
      system.defaults.finder.FXEnableExtensionChangeWarning = false;
      system.defaults.menuExtraClock.ShowSeconds = true;
      system.defaults.menuExtraClock.ShowDayOfWeek = true;
      networking.computerName = "sven-mbp";
      networking.hostName = networking.computerName;
      system.stateVersion = 4;

      users.users.sven.home = "/Users/sven";
    };
    home-config = {
      home.stateVersion = "23.11";
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
            users.sven = home-config;
          };
        }
      ];
    };
  };
}

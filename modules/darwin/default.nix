{ config, lib, pkgs, ... }: {
  users.users.sven.home = "/Users/sven";
  environment.shells = [ pkgs.bash pkgs.zsh ];
  environment.systemPackages = with pkgs; [
    # prefer using home.packages in home-manager
    xcodes
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
    # prefer using home.sessionVariables in home-manager
  };
  environment.shellAliases = {
    # prefer using home.shellAliases in home-manager
  };
  programs.zsh.enable = true;
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
  networking.hostName = config.networking.computerName;
  system.stateVersion = 4;
}

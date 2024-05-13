{ pkgs, ... }: {
  users.users.sven.home = "/Users/sven";
  environment.shells = [ pkgs.bash pkgs.zsh ];
  environment.loginShell = pkgs.zsh;
  environment.systemPackages = with pkgs; [
    # prefer using home.packages in home-manager
    xcodes
  ];
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    brews = [
      "libimobiledevice"
    ];
    taps = [
      "majd/repo"
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
      "android-studio"
    ];
    masApps = {
      "1Password for Safari" = 1569813296;
      "Apple Configurator" = 1037126344;
      "Things" = 904280696;
    };
  };
  environment.variables = {
    # prefer using home.sessionVariables in home-manager
  };
  environment.shellAliases = {
    # prefer using home.shellAliases in home-manager
  };
  programs.zsh.enable = true;
  fonts.fontDir.enable = true;
  fonts.fonts = [ 
    (pkgs.nerdfonts.override { fonts = [
      "Meslo"
    ]; })
  ];
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  services.nix-daemon.enable = true;
  security.pam.enableSudoTouchIdAuth = true;
  system.defaults.finder.AppleShowAllExtensions = true;
  system.defaults.finder._FXShowPosixPathInTitle = true;
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 14;
  system.defaults.NSGlobalDomain.KeyRepeat = 1;
  system.defaults.dock.mineffect = "scale";
  system.defaults.dock.mru-spaces = false;
  system.defaults.dock.orientation = "left";
  system.defaults.dock.showhidden = true;
  system.defaults.finder.FXPreferredViewStyle = "Nlsv";
  system.defaults.finder.ShowStatusBar = true;
  system.defaults.menuExtraClock.ShowSeconds = true;
  system.defaults.menuExtraClock.ShowDayOfWeek = true;
  networking.computerName = "sven-mbp";
  networking.hostName = "sven-mbp";
  system.stateVersion = 4;
}
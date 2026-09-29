{ config, lib, pkgs, inputs, username, ... }:

{
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  system.stateVersion = 7;
  system.primaryUser = username;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ username ];
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };

  environment.systemPackages = with pkgs; [
    aria2
    betterdisplay
    bundler
    container
    mas
    rustup
    xcp
  ];

  # only Homebrew itself; formulae and casks still come from Homebrew's API
  nix-homebrew = {
    enable = true;
    user = username;
    autoMigrate = true; # take over a Homebrew that was installed by hand
  };

  homebrew.enable = true;
  homebrew.enableBashIntegration = true;
  # never uninstalls; `brew bundle cleanup` lists what is not declared here
  homebrew.onActivation.cleanup = "none";
  homebrew.global.brewfile = true;
  homebrew.casks = [
    "apparency"
    "brave-browser"
    "caffeine"
    "charles"
    "daisydisk"
    "ghostty"
    "google-chrome"
    "leader-key"
    "mac-mouse-fix"
    "proxyman"
    "spotify"
    "sublime-text"
    "transmit"
    "tuna"
    "wireshark-app"
  ];

  # App Store apps are installed by hand, not through homebrew.masApps
  #   "1Password for Safari" = 1569813296;
  #   "Apple Configurator" = 1037126344;
  #   "Hush Nag Blocker" = 1544743900;
  #   "Things" = 904280696;

  programs.bash.enable = true;

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
    expose-animation-duration = 0.1;
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

  home-manager.users.${username} = {
    services.syncthing.enable = true;
  };
}

/*

Configuration for all macOS systems

- Homebrew itself (nix-homebrew) and the shared casks
- system-wide nix packages
- macOS system settings

*/

{ config, lib, pkgs, inputs, username, ... }:

{
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  system.stateVersion = 4;
  system.primaryUser = username;

  nix.enable = false; # using determinate systems nix

  environment.systemPackages = with pkgs; [
    aria2
    betterdisplay
    bundler
    container
    mas
    rustup
    xcp
  ];

  # Installs and pins Homebrew itself. Taps are not declared, so formulae and
  # casks still come from Homebrew's API.
  nix-homebrew = {
    enable = true;
    user = username;
    autoMigrate = true; # take over a Homebrew that was installed by hand
  };

  # A switch only installs what is missing and never uninstalls. With
  # global.brewfile, `brew bundle cleanup` compares against this configuration
  # (add --force to remove what it lists).
  homebrew.enable = true;
  # `brew shellenv` (PATH, HOMEBREW_*) and Homebrew's completions in /etc/bashrc
  homebrew.enableBashIntegration = true;
  homebrew.onActivation.cleanup = "none";
  homebrew.global.brewfile = true;
  homebrew.casks = [
    "1password-cli"
    "1password"
    "android-studio"
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

    # Android Studio's SDK and its tools
    home.sessionVariables.ANDROID_HOME = "$HOME/Library/Android/sdk";
    home.sessionPath = [
      "$ANDROID_HOME/emulator"
      "$ANDROID_HOME/platform-tools"
      "$ANDROID_HOME/build-tools/35.0.0-rc3"
      "$ANDROID_HOME/cmdline-tools/latest/bin"
    ];
  };
}

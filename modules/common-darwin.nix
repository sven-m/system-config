/* 

Configuration for all macOS systems

- system-wide nix packages
- homebrew formulas and casks
- macOS system settings
- Xcode theme
*/

{ config, lib, pkgs, home-manager, username, ... }:

{
  system.stateVersion = 4;
  system.primaryUser = username;

  nix.enable = false; # using determinate systems nix

  environment.systemPackages = with pkgs; [
    betterdisplay
    bundler
    xcodes
    rustup
  ];

  environment.shellAliases = {
  };

  homebrew.enable = true;
  homebrew.onActivation = {
    cleanup = "zap";
  };
  homebrew.brews = [
    "ansible"
    "aria2"
    "ideviceinstaller"
    "libimobiledevice"
    "mas"
    "openssh"
    "swiftformat"
    "xcbeautify"
    "xcode-build-server"
  ];
  homebrew.taps = [
  ];
  homebrew.casks = [
    "1password-cli"
    "1password"
    "android-studio"
    "apparency"
    "brave-browser"
    "caffeine"
    "charles"
    "daisydisk"
    "drawio"
    "ghostty"
    "google-chrome"
    "leader-key"
    "mac-mouse-fix"
    "proxyman"
    "qlmarkdown"
    "sf-symbols"
    "spotify"
    "sublime-text"
    "transmit"
    "wireshark-app"
    "xcodes-app"
  ];
  homebrew.masApps = {
    "1Password for Safari" = 1569813296;
    "Apple Configurator" = 1037126344;
    "Things" = 904280696;
  };

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
    home.activation.xcodeCatppuccinTheme = let 
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
    home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ] /* sh */ ''
    cp "${source}" "${destination}"
    chmod 644 "${destination}"
    '';

    home.activation.sshAgentSocket = home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ] /* sh */ ''
      ln -sf "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock" "$HOME/.ssh/agent.sock"
    '';
  };
}

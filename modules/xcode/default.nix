{ lib, pkgs, home-manager, username, ... }:

let
  # per file, next to the files modules/nvim links into ~/.config/nvim
  nvimFiles = lib.listToAttrs (map
    (file: {
      name = "nvim/${lib.removePrefix "${toString ./nvim}/" (toString file)}";
      value.source = file;
    })
    (lib.filesystem.listFilesRecursive ./nvim));
in
{
  environment.systemPackages = with pkgs; [
    ideviceinstaller
    libimobiledevice
    swiftformat
    xcbeautify
    xcodes
    (writeShellScriptBin "delete-derived-data" (builtins.readFile ./delete-derived-data))
  ];

  homebrew.brews = [
    "xcode-build-server"
  ];

  homebrew.casks = [
    "sf-symbols"
    "xcodes-app"
  ];

  home-manager.users.${username} = {
    programs.neovim.plugins = [
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
    ];

    xdg.configFile = nvimFiles;

    home.activation.xcodeCatppuccinTheme = let
      catppuccin-xcode = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "xcode";
        rev = "6b483ce504a8b0c558d85a0663ebbcbfc457c2b0";
        sha256 = "sha256-F9sUoBPJ2kE2wt2FIIrOWhJOacsxYC1tp1ksh++TDG8=";
      };
      filename_latte = "Catppuccin Latte.xccolortheme";
      filename_mocha = "Catppuccin Mocha.xccolortheme";
      source_dir = "${catppuccin-xcode}/themes";
      destination_dir = "$HOME/Library/Developer/Xcode/UserData/FontAndColorThemes";
    in
    home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ] /* sh */ ''
    cp "${source_dir}/${filename_latte}" "${destination_dir}/${filename_latte}"
    cp "${source_dir}/${filename_mocha}" "${destination_dir}/${filename_mocha}"
    chmod 644 "${destination_dir}/${filename_latte}"
    chmod 644 "${destination_dir}/${filename_mocha}"
    '';
  };
}

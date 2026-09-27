{ lib, ... }:

let
  sdk = "$HOME/Library/Android/sdk";
in
{
  homebrew.casks = [ "android-studio" ];

  environment.variables.ANDROID_HOME = sdk;
  environment.systemPath = lib.mkAfter [
    "${sdk}/emulator"
    "${sdk}/platform-tools"
    "${sdk}/build-tools/35.0.0-rc3"
    "${sdk}/cmdline-tools/latest/bin"
  ];
}

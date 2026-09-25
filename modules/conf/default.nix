/*

conf: edit, build, switch and dev-shell this configuration from anywhere

CFG_HOME is where the checkout lives; hosts override it when it lives elsewhere.

*/

{ lib, pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "conf" (builtins.readFile ./conf))
  ];

  environment.variables = {
    CFG_HOME = lib.mkDefault "$HOME/src/system-config";
  };
}

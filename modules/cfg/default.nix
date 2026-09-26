/*

Working with this configuration

- `cfg`: flake registry name for the repository on GitHub, so `cfg`,
  `cfg/<branch>` and `cfg#preview-tmux` work in any nix command
- `rebuild-switch [flake]`: switch this machine (default flake: .)

*/

{ pkgs, username, ... }:

let
  rebuild = if pkgs.stdenv.isDarwin then "darwin-rebuild" else "nixos-rebuild";

  # The repository is private, so root can't fetch it (no SSH agent, no GitHub
  # host key): fetch it as this user, then let root build from the copy in the
  # store. The configuration is picked by hostname.
  rebuild-switch = pkgs.writeShellScriptBin "rebuild-switch" ''
    set -euo pipefail
    src=$(nix flake metadata --refresh --json "''${1:-.}" | ${pkgs.jq}/bin/jq -r .path)
    exec sudo "$(command -v ${rebuild})" switch --flake "$src"
  '';
in
{
  environment.systemPackages = [ rebuild-switch ];

  home-manager.users.${username} = {
    nix.registry.cfg.to = {
      type = "git";
      url = "ssh://git@github.com/sven-m/system-config";
    };
  };
}

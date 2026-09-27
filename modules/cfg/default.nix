/*

Working with this configuration

- `cfg`: flake registry name for github:sven-m/system-config, so `cfg` and
  `cfg/<branch>` (`cfg?ref=<branch>` when the branch has a slash) work in
  any nix command
- a bash key binding that puts a command on the prompt, cursor on the flake:
    Ctrl-x s  switch this machine

*/

{ lib, pkgs, username, ... }:

let
  rebuild = if pkgs.stdenv.isDarwin then "darwin-rebuild" else "nixos-rebuild";

  cfgFlake = {
    type = "github";
    owner = "sven-m";
    repo = "system-config";
  };
in
{
  # `_cfg_prefill <text>` replaces the command line with <text>, cursor at the
  # `@` (which is removed). The switch picks the configuration by hostname.
  home-manager.users.${username}.programs.bash.initExtra = ''
    _cfg_prefill() {
      local after_cursor="''${1#*@}"
      READLINE_LINE="''${1/@/}"
      READLINE_POINT=$(( ''${#1} - ''${#after_cursor} - 1 ))
    }
    bind -x '"\C-xs": _cfg_prefill "sudo ${rebuild} switch --flake .@"'
  '';

  # The system registry (/etc/nix/registry.json), so root sees `cfg` too:
  # darwin-rebuild runs with root's HOME, which has no user registry. On macOS
  # Nix is not managed by nix-darwin (Determinate), so the file is written
  # directly.
  nix.registry = lib.mkIf pkgs.stdenv.isLinux {
    cfg.to = cfgFlake;
  };
  environment.etc = lib.mkIf pkgs.stdenv.isDarwin {
    "nix/registry.json".text = builtins.toJSON {
      version = 2;
      flakes = [ { from = { type = "indirect"; id = "cfg"; }; to = cfgFlake; } ];
    };
  };
}

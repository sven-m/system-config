/*

Working with this configuration

- `cfg`: flake registry name for the repository on GitHub, so `cfg`,
  `cfg/<branch>` and `cfg#preview-tmux` work in any nix command
- bash key bindings that put a command on the prompt, cursor on the flake:
    Ctrl-x s  switch this machine
    Ctrl-x p  preview a program

*/

{ lib, pkgs, username, ... }:

let
  rebuild = if pkgs.stdenv.isDarwin then "darwin-rebuild" else "nixos-rebuild";

  cfgFlake = {
    type = "git";
    url = "ssh://git@github.com/sven-m/system-config";
  };
in
{
  # `_cfg_prefill <text>` replaces the command line with <text>, cursor at the
  # `@` (which is removed). The switch picks the configuration by hostname;
  # root can fetch `cfg` through your SSH agent (see modules/ssh).
  home-manager.users.${username}.programs.bash.initExtra = ''
    _cfg_prefill() {
      local after_cursor="''${1#*@}"
      READLINE_LINE="''${1/@/}"
      READLINE_POINT=$(( ''${#1} - ''${#after_cursor} - 1 ))
    }
    bind -x '"\C-xs": _cfg_prefill "sudo ${rebuild} switch --flake .@"'
    bind -x '"\C-xp": _cfg_prefill "nix run .#preview-@"'
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

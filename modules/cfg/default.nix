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
  # Ctrl-x s puts the switch command on the prompt, cursor at the `@`
  home-manager.users.${username}.programs.bash.initExtra = ''
    _cfg_prefill() {
      local after_cursor="''${1#*@}"
      READLINE_LINE="''${1/@/}"
      READLINE_POINT=$(( ''${#1} - ''${#after_cursor} - 1 ))
    }
    bind -x '"\C-xs": _cfg_prefill "sudo ${rebuild} switch --flake .@"'
  '';

  # System registry, as darwin-rebuild runs with root's HOME. Written directly
  # on macOS, where Determinate Nix disables nix-darwin's nix.* options.
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

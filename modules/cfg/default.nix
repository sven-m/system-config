/*

Working with this configuration

- `cfg`: flake registry name for the repository on GitHub, so `cfg`,
  `cfg/<branch>` and `cfg#preview-tmux` work in any nix command
- bash key bindings that put a command on the prompt, cursor on the flake:
    Ctrl-x s  switch this machine
    Ctrl-x p  preview a program

*/

{ pkgs, username, ... }:

let
  rebuild = if pkgs.stdenv.isDarwin then "darwin-rebuild" else "nixos-rebuild";
in
{
  # `_cfg_prefill <text>` replaces the command line with <text>, cursor at the
  # `@` (which is removed).
  #
  # The switch command fetches the flake as you and hands root the copy in the
  # store: the repository is private, and root has no SSH agent or GitHub host
  # key. The configuration is picked by hostname.
  programs.bash.interactiveShellInit = ''
    _cfg_prefill() {
      local after_cursor="''${1#*@}"
      READLINE_LINE="''${1/@/}"
      READLINE_POINT=$(( ''${#1} - ''${#after_cursor} - 1 ))
    }
    bind -x '"\C-xs": _cfg_prefill "sudo ${rebuild} switch --flake \"\$(nix flake metadata --refresh --json .@ | jq -r .path)\""'
    bind -x '"\C-xp": _cfg_prefill "nix run .#preview-@"'
  '';

  home-manager.users.${username} = {
    nix.registry.cfg.to = {
      type = "git";
      url = "ssh://git@github.com/sven-m/system-config";
    };
  };
}

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

    # cfg-develop [branch] [host]; only pushed branches exist for the cfg registry entry
    cfg-develop() {
      nix develop "flake:cfg''${1:+?ref=$1}''${2:+#$2}"
    }
    _cfg_develop() {
      [[ $COMP_CWORD -eq 1 ]] || return
      local branches
      branches=$(git ls-remote --heads https://github.com/${cfgFlake.owner}/${cfgFlake.repo} 2>/dev/null | sed 's|.*refs/heads/||')
      COMPREPLY=($(compgen -W "$branches" -- "''${COMP_WORDS[1]}"))
    }
    complete -F _cfg_develop cfg-develop
  '';

  # System registry, as darwin-rebuild runs with root's HOME
  nix.registry.cfg.to = cfgFlake;
}

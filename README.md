# system-config

nix-darwin and NixOS configurations for darmok, tanagra (macOS), jalad and
temba (NixOS), with home-manager for the dotfiles.

## Install

1. Install the flake from GitHub. Pick the configuration by name
   (`darmok`, `tanagra`, `jalad`, `temba`). The build runs as you, so your
   SSH agent can fetch the private repository; `sudo` only activates it.

   macOS:
   ```sh
   nix build 'git+ssh://git@github.com/sven-m/system-config#darwinConfigurations.darmok.system'
   sudo nix-env -p /nix/var/nix/profiles/system --set ./result
   sudo ./result/activate
   ```

   NixOS:
   ```sh
   nix build 'git+ssh://git@github.com/sven-m/system-config#nixosConfigurations.jalad.config.system.build.toplevel'
   sudo nix-env -p /nix/var/nix/profiles/system --set ./result
   sudo ./result/bin/switch-to-configuration switch
   ```

   For a branch, add `?ref=<branch>` before the `#`.

## Development

1. Clone the repository:
   ```sh
   git clone git@github.com:sven-m/system-config.git ~/src/system-config
   ```
2. Install the flake from the local copy:
   ```sh
   cd ~/src/system-config

   # macOS
   sudo darwin-rebuild switch --flake .#darmok

   # NixOS
   sudo nixos-rebuild switch --flake .#jalad
   ```

The flake only sees files git knows about: `git add` new files first.

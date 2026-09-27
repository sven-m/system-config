# system-config

nix-darwin and NixOS configurations for darmok, tanagra (macOS), jalad and
temba (NixOS), with home-manager for the dotfiles.

## Install

1. Switch to the flake from GitHub. Pick the configuration by name
   (`darmok`, `tanagra`, `jalad`, `temba`):
   ```sh
   # macOS
   sudo nix run nix-darwin -- switch --flake github:sven-m/system-config#darmok

   # NixOS
   sudo nixos-rebuild switch --flake github:sven-m/system-config#jalad
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

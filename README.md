# system-config

System configuration for nix-darwin and nixos.

## Install

```sh
# macOS
sudo nix run nix-darwin -- switch --flake github:sven-m/system-config

# NixOS
sudo nixos-rebuild switch --flake github:sven-m/system-config

# a branch
sudo nix run nix-darwin -- switch --flake 'github:sven-m/system-config?ref=<branch>'
```

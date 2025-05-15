# system-config

The primary system configuration for my macbook that uses `nix`, `nix-darwin` and `home-manager`.

## Installation

1. Clone the repository
   ```sh
   git clone https://github.com/sven-m/system-config.git
   ```
2. Set `$CFG_HOME` in `~/.config/cfg_home_env`
   ```
   cd system-config
   echo export CFG_HOME=\"$PWD\" > ~/.config/cfg_home_env
   ```

4. Apply the configuration by running:
   ```sh
   # nix-darwin
   nix run nix-darwin -- switch --flake .#variant

   # nixos
   nixos-rebuild switch --flake .#variant
   ```

## Edit & Update Aliases

The configuration defines 2 aliases useful for changing and updating the configuration from anywhere.
```sh
modify-cfg  # open the root folder of the sytem config repository in $EDITOR
rebuild-cfg # re-apply the configuration
```

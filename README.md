# system-config

The primary system configuration for my macbook that uses `nix`, `nix-darwin` and `home-manager`.

## Installation

Run the following command to apply the configuration on the local system:
```sh
nix run nix-darwin -- switch --flake github:sven-m/system-config#sven-mbp
```

## Local development

Clone the repository and run the installation command on the local checkout:
```sh
# Assuming you put your checkouts in ~/src
cd ~/src
git clone https://github.com/sven-m/system-config.git
nix run nix-darwin -- switch --flake ~/src/system-config
```
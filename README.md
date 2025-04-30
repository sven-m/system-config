# system-config

The primary system configuration for my macbook that uses `nix`, `nix-darwin` and `home-manager`.

## Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/sven-m/system-config.git
    ```

2. Apply the configuration by running:
    ```sh
    system-config/rebuild.sh
    ```

## Edit Configuration

Run the following command to edit the configuration
```sh
modify-cfg
```

## Apply updated configuration

Run the following command to apply changes to the configuration to the system:
```sh
rebuild-cfg
```

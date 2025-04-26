{
  description = "nix macos sven-mbp";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin/nix-darwin-24.11";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {self, nixpkgs, nixpkgs-unstable, home-manager, darwin, ... }:
  let system = "aarch64-darwin"; in
  {
    darwinConfigurations.sven-mbp = darwin.lib.darwinSystem {
      inherit system;
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      modules = [
        ./modules/darwin
        home-manager.darwinModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.sven.imports = [
              ./modules/home-manager
            ];
          };
          home-manager.extraSpecialArgs = {
            pkgs-unstable = import nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };
          };
        }
      ];
    };
  };
}

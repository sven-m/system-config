{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    #nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    #home-manager-unstable.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin/nix-darwin-25.05";
    #darwin-unstable.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {self, nixpkgs, home-manager, darwin, disko, ... }@inputs:
  let
    darwin64-system = "aarch64-darwin";
    linux64-system = "x86_64-linux";

    darwin-pkgs = import nixpkgs {
      system = darwin64-system;
      config.allowUnfree = true;
    };

    linux-pkgs = import nixpkgs {
      system = linux64-system;
      config.allowUnfree = true;
    };
  in
  {
    packages.${darwin64-system}.stow = darwin-pkgs.stow;
    packages.${linux64-system}.stow = linux-pkgs.stow;

    darwinConfigurations.darmok = darwin.lib.darwinSystem {
      system = darwin64-system;
      pkgs = darwin-pkgs;
      specialArgs = { username = "sven"; inherit home-manager; };
      modules = [
        home-manager.darwinModules.home-manager
        ./modules/common.nix
        ./modules/common-darwin.nix
        ./modules/system-darmok.nix
      ];
    };

    nixosConfigurations.jalad = nixpkgs.lib.nixosSystem {
      system = linux64-system;
      pkgs = linux-pkgs;
      specialArgs = { username = "sven"; inherit home-manager; };
      modules = [
        home-manager.nixosModules.home-manager
        disko.nixosModules.disko
        ./modules/common.nix
        ./modules/system-jalad.nix
      ];
    };

    darwinConfigurations.tanagra = darwin.lib.darwinSystem {
      system = darwin64-system;
      pkgs = darwin-pkgs;
      specialArgs = { username = "sven"; inherit home-manager; };
      modules = [
        home-manager.darwinModules.home-manager
        ./modules/common.nix
        ./modules/common-darwin.nix
        ./modules/system-tanagra.nix
      ];
    };
  };
}

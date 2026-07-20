{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    #home-manager-unstable.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin/nix-darwin-26.05";
    #darwin-unstable.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {self, nixpkgs, nixpkgs-unstable, home-manager, darwin, disko, ... }@inputs:
  let
    darwin64-system = "aarch64-darwin";
    linux-x86_64-system = "x86_64-linux";
    linux-aarch64-system = "aarch64-linux";

    darwin-pkgs = import nixpkgs {
      system = darwin64-system;
      config.allowUnfree = true;
    };

    darwin-pkgs-unstable = import nixpkgs-unstable {
      system = darwin64-system;
      config.allowUnfree = true;
    };

    linux-pkgs = import nixpkgs {
      system = linux-x86_64-system;
      config.allowUnfree = true;
    };

    linux-pkgs-unstable = import nixpkgs-unstable {
      system = linux-x86_64-system;
      config.allowUnfree = true;
    };

    linux-aarch64-pkgs = import nixpkgs {
      system = linux-aarch64-system;
      config.allowUnfree = true;
    };

    linux-aarch64-pkgs-unstable = import nixpkgs-unstable {
      system = linux-aarch64-system;
      config.allowUnfree = true;
    };
  in
  {
    packages.${darwin64-system} = with darwin-pkgs; {
      inherit stow;
      inherit git;
      inherit dockutil;
      rebuild = darwin.packages.${darwin64-system}.darwin-rebuild;
    };
    packages.${linux-x86_64-system} = with linux-pkgs; {
      inherit stow;
      inherit git;
      rebuild = linux-pkgs.nixos-rebuild;
    };

    darwinConfigurations.darmok = darwin.lib.darwinSystem {
      system = darwin64-system;
      pkgs = darwin-pkgs;
      specialArgs = {
        username = "sven";
        inherit home-manager;
        pkgs-unstable = darwin-pkgs-unstable;
      };
      modules = [
        home-manager.darwinModules.home-manager
        ./modules/common.nix
        ./modules/common-packages.nix
        ./modules/common-darwin.nix
        ./modules/system-darmok.nix
      ];
    };

    nixosConfigurations.jalad = nixpkgs.lib.nixosSystem {
      system = linux-x86_64-system;
      pkgs = linux-pkgs;
      specialArgs = {
        username = "sven";
        inherit home-manager;
        pkgs-unstable = linux-pkgs-unstable;
      };
      modules = [
        home-manager.nixosModules.home-manager
        disko.nixosModules.disko
        ./modules/common.nix
        ./modules/common-packages.nix
        ./modules/system-jalad.nix
      ];
    };

    nixosConfigurations.temba = nixpkgs.lib.nixosSystem {
      system = linux-aarch64-system;
      pkgs = linux-aarch64-pkgs;
      specialArgs = {
        username = "sven";
        inherit home-manager;
        pkgs-unstable = linux-aarch64-pkgs-unstable;
      };
      modules = [
        home-manager.nixosModules.home-manager
        ./modules/common.nix
        ./modules/system-temba.nix
      ];
    };

    darwinConfigurations.tanagra = darwin.lib.darwinSystem {
      system = darwin64-system;
      pkgs = darwin-pkgs;
      specialArgs = {
        username = "sven";
        inherit home-manager;
        pkgs-unstable = darwin-pkgs-unstable;
      };
      modules = [
        home-manager.darwinModules.home-manager
        ./modules/common.nix
        ./modules/common-packages.nix
        ./modules/common-darwin.nix
        ./modules/system-tanagra.nix
      ];
    };
  };
}

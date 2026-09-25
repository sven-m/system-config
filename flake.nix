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

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };
  outputs = {self, nixpkgs, nixpkgs-unstable, home-manager, darwin, disko, ... }@inputs:
  let
    username = "sven";

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

    specialArgs = pkgs-unstable: {
      inherit username home-manager inputs pkgs-unstable;
    };

    # Each host's own modules are imported from hosts/<name>/default.nix
    mkDarwin = name: pkgs: pkgs-unstable: darwin.lib.darwinSystem {
      inherit pkgs;
      system = pkgs.stdenv.hostPlatform.system;
      specialArgs = specialArgs pkgs-unstable;
      modules = [
        home-manager.darwinModules.home-manager
        ./hosts/${name}
      ];
    };

    mkNixos = name: pkgs: pkgs-unstable: extraModules: nixpkgs.lib.nixosSystem {
      inherit pkgs;
      system = pkgs.stdenv.hostPlatform.system;
      specialArgs = specialArgs pkgs-unstable;
      modules = [
        home-manager.nixosModules.home-manager
        ./hosts/${name}
      ] ++ extraModules;
    };

    # `nix develop .#<name>`: that host's packages and the dotfiles
    # home-manager would install, built from the working tree, without
    # switching. Sources the dev copy of .bashrc (starship prompt shows the
    # shell's name).
    mkDevShell = name: pkgs: host:
      let
        hm = host.config.home-manager.users.${username};
        homeFiles = hm.home-files;

        # A separate tmux server that loads only the dev tmux.conf (without
        # -f, tmux also loads ~/.config/tmux/tmux.conf, which then wins).
        tmux-dev = pkgs.writeShellScriptBin "tmux" ''
          exec ${pkgs.tmux}/bin/tmux -L dev -f ${homeFiles}/.config/tmux/tmux.conf "$@"
        '';

        # For shells started from the dev shell (tmux panes, :terminal): the
        # system bashrc resets PATH, so put the dev shell's PATH back, then
        # load the dev .bashrc.
        devBashrc = pkgs.writeText "dev-bashrc" ''
          export PATH="$CFG_DEV_PATH"
          source ${homeFiles}/.bashrc
        '';

        # $SHELL in the dev shell. nix develop sets SHELL to the minimal
        # build bash (no `complete`, no readline prompt handling).
        dev-bash = pkgs.writeShellScriptBin "dev-bash" ''
          exec ${pkgs.bashInteractive}/bin/bash --rcfile ${devBashrc} "$@"
        '';
      in pkgs.mkShell {
        inherit name;
        # shown by the starship prompt; nix develop turns `name` into <name>-env
        CFG_DEV_SHELL = name;
        packages = [ tmux-dev host.config.system.path hm.home.path ];
        shellHook = ''
          export XDG_CONFIG_HOME=${homeFiles}/.config
          export STARSHIP_CONFIG=$XDG_CONFIG_HOME/starship.toml
          export SHELL=${dev-bash}/bin/dev-bash
          export CFG_DEV_PATH="$PATH"
          source ${homeFiles}/.bashrc
        '';
      };
  in
  {
    packages.${darwin64-system} = with darwin-pkgs; {
      inherit git;
      inherit dockutil;
      rebuild = darwin.packages.${darwin64-system}.darwin-rebuild;
    };
    packages.${linux-x86_64-system} = with linux-pkgs; {
      inherit git;
      rebuild = nixos-rebuild;
    };
    packages.${linux-aarch64-system} = with linux-aarch64-pkgs; {
      inherit git;
      rebuild = nixos-rebuild;
    };

    darwinConfigurations.darmok = mkDarwin "darmok" darwin-pkgs darwin-pkgs-unstable;
    darwinConfigurations.tanagra = mkDarwin "tanagra" darwin-pkgs darwin-pkgs-unstable;
    nixosConfigurations.jalad = mkNixos "jalad" linux-pkgs linux-pkgs-unstable [ disko.nixosModules.disko ];
    nixosConfigurations.temba = mkNixos "temba" linux-aarch64-pkgs linux-aarch64-pkgs-unstable [ ];

    devShells.${darwin64-system} = {
      darmok = mkDevShell "darmok" darwin-pkgs self.darwinConfigurations.darmok;
      tanagra = mkDevShell "tanagra" darwin-pkgs self.darwinConfigurations.tanagra;
    };
    devShells.${linux-x86_64-system} = {
      jalad = mkDevShell "jalad" linux-pkgs self.nixosConfigurations.jalad;
    };
    devShells.${linux-aarch64-system} = {
      temba = mkDevShell "temba" linux-aarch64-pkgs self.nixosConfigurations.temba;
    };
  };
}

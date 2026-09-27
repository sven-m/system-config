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

    mkSpecialArgs = pkgs-unstable: {
      inherit username home-manager inputs pkgs-unstable;
    };

    mkDarwin = name: pkgs: pkgs-unstable: darwin.lib.darwinSystem {
      inherit pkgs;
      system = pkgs.stdenv.hostPlatform.system;
      specialArgs = mkSpecialArgs pkgs-unstable;
      modules = [
        home-manager.darwinModules.home-manager
        ./hosts/${name}
      ];
    };

    mkNixos = name: pkgs: pkgs-unstable: extraModules: nixpkgs.lib.nixosSystem {
      inherit pkgs;
      system = pkgs.stdenv.hostPlatform.system;
      specialArgs = mkSpecialArgs pkgs-unstable;
      modules = [
        home-manager.nixosModules.home-manager
        ./hosts/${name}
      ] ++ extraModules;
    };

    # `nix develop .#<name>`: the host's packages, environment and dotfiles
    # from the working tree, without switching
    mkDevShell = name: pkgs: host:
      let
        cfg = host.config;
        hm = cfg.home-manager.users.${username};
        homeFiles = hm.home-files;

        # without -f, tmux also loads ~/.config/tmux/tmux.conf, which then wins
        tmux-dev = pkgs.writeShellScriptBin "tmux" ''
          exec ${pkgs.tmux}/bin/tmux -L dev -f ${homeFiles}/.config/tmux/tmux.conf "$@"
        '';

        devPath = pkgs.lib.makeBinPath [ tmux-dev cfg.system.path hm.home.path ];

        # Run by every shell in the dev shell. PATH keeps the installed system,
        # so dev packages can add and override but not remove.
        devBashrc = pkgs.writeText "dev-bashrc" ''
          source ${cfg.system.build.setEnvironment}
          # Ensures /etc/bashrc runs its interactive setup instead of returning
          # early (dev-bash's NOSYSBASHRC, or the installed /etc/bashrc already read
          # by this shell). Prevents NixOS's /etc/bashrc from sourcing the installed
          # /etc/profile, which would redo the installed environment over the above.
          unset NOSYSBASHRC
          unset __ETC_BASHRC_SOURCED
          export __ETC_PROFILE_DONE=1
          source ${cfg.environment.etc.bashrc.source}
          export PATH="${devPath}:$PATH"
          source ${homeFiles}/.bashrc
          # home-manager's starship module points login shells at the installed one
          export STARSHIP_CONFIG=${homeFiles}/.config/starship.toml
        '';

        dev-bash = pkgs.writeShellScriptBin "dev-bash" ''
          # nix develop's bash lacks readline and `complete`
          NOSYSBASHRC=1 exec ${pkgs.bashInteractive}/bin/bash --rcfile ${devBashrc} "$@"
        '';
      in pkgs.mkShellNoCC {
        inherit name;
        # for the prompt; nix develop turns `name` into <name>-env
        CFG_DEV_SHELL = name;
        shellHook = ''
          export XDG_CONFIG_HOME=${homeFiles}/.config
          # tmux panes start $SHELL, which nix develop set to its minimal bash
          export SHELL=${dev-bash}/bin/dev-bash
          source ${devBashrc}
        '';
      };
  in
  {
    darwinConfigurations.darmok = mkDarwin "darmok" darwin-pkgs darwin-pkgs-unstable;
    darwinConfigurations.tanagra = mkDarwin "tanagra" darwin-pkgs darwin-pkgs-unstable;
    nixosConfigurations.jalad = mkNixos "jalad" linux-pkgs linux-pkgs-unstable [ disko.nixosModules.disko ];
    nixosConfigurations.temba = mkNixos "temba" linux-aarch64-pkgs linux-aarch64-pkgs-unstable [ ];

    devShells.${darwin64-system} = rec {
      darmok = mkDevShell "darmok" darwin-pkgs self.darwinConfigurations.darmok;
      tanagra = mkDevShell "tanagra" darwin-pkgs self.darwinConfigurations.tanagra;
      default = darmok;
    };
    devShells.${linux-x86_64-system} = rec {
      jalad = mkDevShell "jalad" linux-pkgs self.nixosConfigurations.jalad;
      default = jalad;
    };
    devShells.${linux-aarch64-system} = rec {
      temba = mkDevShell "temba" linux-aarch64-pkgs self.nixosConfigurations.temba;
      default = temba;
    };

    packages.${darwin64-system} = with darwin-pkgs; {
      inherit git;
      inherit dockutil;
    };
    packages.${linux-x86_64-system} = with linux-pkgs; {
      inherit git;
    };
    packages.${linux-aarch64-system} = with linux-aarch64-pkgs; {
      inherit git;
    };
  };
}

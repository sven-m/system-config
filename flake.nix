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

    # Each host's own modules are imported from hosts/<name>/default.nix
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

    # `nix develop .#<name>`: that host's packages, environment and the
    # dotfiles home-manager would install, built from the working tree,
    # without switching. The starship prompt shows the shell's name.
    mkDevShell = name: pkgs: host:
      let
        cfg = host.config;
        hm = cfg.home-manager.users.${username};
        homeFiles = hm.home-files;

        # A separate tmux server that loads only the dev tmux.conf (without
        # -f, tmux also loads ~/.config/tmux/tmux.conf, which then wins).
        tmux-dev = pkgs.writeShellScriptBin "tmux" ''
          exec ${pkgs.tmux}/bin/tmux -L dev -f ${homeFiles}/.config/tmux/tmux.conf "$@"
        '';

        devPath = pkgs.lib.makeBinPath [ tmux-dev cfg.system.path hm.home.path ];

        # Every shell in the dev shell (the shell itself, tmux panes,
        # :terminal) starts the way a pane does after a switch, but from this
        # configuration. PATH still names the installed /run/current-system, so
        # the dev packages can add and override but not remove.
        devBashrc = pkgs.writeText "dev-bashrc" ''
          # NOSYSBASHRC: when set, bash skips /etc/bashrc at startup and /etc/bashrc returns
          # at its top. dev-bash sets it; unsetting lets the new /etc/bashrc below run and
          # makes other shells started from here read /etc/bashrc normally.
          unset NOSYSBASHRC
          # __ETC_BASHRC_SOURCED: /etc/bashrc sets it and returns at its top when it is set.
          # It is set if this shell already read the installed /etc/bashrc (the nix develop
          # shell, before its shellHook); unsetting lets the new /etc/bashrc below run.
          unset __ETC_BASHRC_SOURCED
          # the new configuration's environment variables and PATH (replacing what nix develop
          # added). It exports its once-per-shell marker, so /etc/bashrc below skips it.
          source ${cfg.system.build.setEnvironment}
          # __ETC_PROFILE_DONE: NixOS's /etc/bashrc sources the installed /etc/profile when it
          # is unset, which would run the installed set-environment over the line above.
          export __ETC_PROFILE_DONE=1
          # the new configuration's aliases, completion and interactive setup
          source ${cfg.environment.etc.bashrc.source}
          # so the new packages win over the installed system that set-environment put in PATH
          export PATH="${devPath}:$PATH"
          # to get your new .bashrc, last as in a normal startup, so it can rely on the lines above
          source ${homeFiles}/.bashrc
          # login shells get the installed ~/.config/starship.toml from home-manager's starship module
          export STARSHIP_CONFIG=${homeFiles}/.config/starship.toml
        '';

        # $SHELL in the dev shell, so tmux panes and other child shells go
        # through dev-bashrc too.
        dev-bash = pkgs.writeShellScriptBin "dev-bash" ''
          # full bash (nix develop's lacks readline and `complete`), skipping the installed /etc/bashrc (dev-bashrc sources the new one)
          NOSYSBASHRC=1 exec ${pkgs.bashInteractive}/bin/bash --rcfile ${devBashrc} "$@"
        '';
      in pkgs.mkShellNoCC {
        inherit name;
        # shown by the starship prompt; nix develop turns `name` into <name>-env
        CFG_DEV_SHELL = name;
        shellHook = ''
          # to point nvim, git, lazygit, tmux, … at the new config
          export XDG_CONFIG_HOME=${homeFiles}/.config
          # because nix develop set SHELL to its minimal build bash, which tmux would start in panes
          export SHELL=${dev-bash}/bin/dev-bash
          # so this shell, which nix develop started itself, gets the same setup as every child shell
          source ${devBashrc}
        '';
      };
  in
  {
    darwinConfigurations.darmok = mkDarwin "darmok" darwin-pkgs darwin-pkgs-unstable;
    darwinConfigurations.tanagra = mkDarwin "tanagra" darwin-pkgs darwin-pkgs-unstable;
    nixosConfigurations.jalad = mkNixos "jalad" linux-pkgs linux-pkgs-unstable [ disko.nixosModules.disko ];
    nixosConfigurations.temba = mkNixos "temba" linux-aarch64-pkgs linux-aarch64-pkgs-unstable [ ];

    # `default` is the platform's host: plain `nix develop`
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

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
          # so programs started from this shell read /etc/bashrc normally again
          unset NOSYSBASHRC
          # so the new /etc/bashrc runs, not "already sourced" from the installed one
          unset __ETC_BASHRC_SOURCED
          # so the new set-environment runs on macOS (nix-darwin's once-per-shell marker)
          unset __NIX_DARWIN_SET_ENVIRONMENT_DONE
          # so the new set-environment runs on NixOS (NixOS's once-per-shell marker)
          unset __NIXOS_SET_ENVIRONMENT_DONE
          # so the new .bashrc runs the new home.sessionVariables/sessionPath (home-manager's marker)
          unset __HM_SESS_VARS_SOURCED
          # to get the new configuration's environment variables, and a PATH free of what nix develop added
          source ${cfg.system.build.setEnvironment}
          # to keep the new /etc/bashrc from sourcing the installed /etc/profile on NixOS
          export __ETC_PROFILE_DONE=1
          # to get the new configuration's aliases, completion and interactive setup
          source ${cfg.environment.etc.bashrc.source}
          # so the new packages win over the installed system that set-environment put in PATH
          export PATH="${devPath}:$PATH"
          # to get your new .bashrc, last as in a normal startup, so it can rely on the lines above
          source ${homeFiles}/.bashrc
          # after .bashrc, whose session variables set it to the installed ~/.config/starship.toml
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

    # `nix run .#preview-<program>`: one program with the config home-manager
    # would install for that platform's host, built from the flake. Everything
    # else (the shell, PATH, other programs) is the installed system. `suffix`
    # tells hosts apart while a platform has more than one.
    mkPreviews = suffix: pkgs: host:
      let
        hm = host.config.home-manager.users.${username};
        homeFiles = hm.home-files;
      in {
        # A separate tmux server (kill it with `tmux -L preview kill-server`
        # to pick up changes). On macOS it clears the same guards as
        # nix-darwin's tmux wrapper, so panes start like in the real tmux.
        "preview-tmux${suffix}" = pkgs.writeShellScriptBin "preview-tmux" (
          pkgs.lib.optionalString pkgs.stdenv.isDarwin ''
            export __ETC_BASHRC_SOURCED= __ETC_ZPROFILE_SOURCED= __ETC_ZSHENV_SOURCED= __ETC_ZSHRC_SOURCED= __NIX_DARWIN_SET_ENVIRONMENT_DONE=
          '' + ''
            exec ${pkgs.tmux}/bin/tmux -L preview -f ${homeFiles}/.config/tmux/tmux.conf "$@"
          '');

        # nvim with the new plugins (home-manager's own nvim package) and the
        # new ~/.config/nvim
        "preview-nvim${suffix}" = pkgs.writeShellScriptBin "preview-nvim" ''
          XDG_CONFIG_HOME=${homeFiles}/.config exec ${hm.programs.neovim.finalPackage}/bin/nvim "$@"
        '';
      };
  in
  {
    darwinConfigurations.darmok = mkDarwin "darmok" darwin-pkgs darwin-pkgs-unstable;
    darwinConfigurations.tanagra = mkDarwin "tanagra" darwin-pkgs darwin-pkgs-unstable;
    nixosConfigurations.jalad = mkNixos "jalad" linux-pkgs linux-pkgs-unstable [ disko.nixosModules.disko ];
    nixosConfigurations.temba = mkNixos "temba" linux-aarch64-pkgs linux-aarch64-pkgs-unstable [ ];

    # `default` is the platform's host, like the previews: plain `nix develop`
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
    }
      // mkPreviews "" darwin-pkgs self.darwinConfigurations.darmok
      // mkPreviews "-tanagra" darwin-pkgs self.darwinConfigurations.tanagra;
    packages.${linux-x86_64-system} = with linux-pkgs; {
      inherit git;
    }
      // mkPreviews "" linux-pkgs self.nixosConfigurations.jalad;
    packages.${linux-aarch64-system} = with linux-aarch64-pkgs; {
      inherit git;
    }
      // mkPreviews "" linux-aarch64-pkgs self.nixosConfigurations.temba;
  };
}

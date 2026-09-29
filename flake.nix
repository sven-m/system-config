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

        # home-manager links plugins into ~/.local/share/nvim/site rather than
        # the wrapper, so nvim would load the installed generation's plugins
        nvim-dev = pkgs.writeShellScriptBin "nvim" ''
          exec ${hm.programs.neovim.finalPackage}/bin/nvim --cmd ${pkgs.lib.escapeShellArg ''
            lua vim.opt.packpath:remove(vim.fn.stdpath("data") .. "/site"); vim.opt.packpath:prepend("${homeFiles}/.local/share/nvim/site")
          ''} "$@"
        '';

        devPath = pkgs.lib.makeBinPath [ tmux-dev nvim-dev cfg.system.path hm.home.path ];

        # Interactive initialisation script for each shell:
        # - We unset NOSYSBASHRC because dev-bash sets it
        # - We source the built config's /etc/bashrc and ~/.bashrc
        devBashrc = pkgs.writeText "dev-bashrc" ''
          unset NOSYSBASHRC
          source ${cfg.environment.etc.bashrc.source}
          source ${homeFiles}/.bashrc
        '';

        # Custom invocation of bash:
        # - Suppress installed /etc/bashrc by setting NOSYSBASHRC
        # - Pass custom interactive initialisation script (above)
        dev-bash = pkgs.writeShellScriptBin "dev-bash" ''
          NOSYSBASHRC=1 exec ${pkgs.bashInteractive}/bin/bash --rcfile ${devBashrc} "$@"
        '';
      in pkgs.mkShellNoCC {
        inherit name;
        # for the prompt; nix develop turns `name` into <name>-env
        CFG_DEV_SHELL = name;
        shellHook = ''
          # Apply built config's environment
          source ${cfg.system.build.setEnvironment}

          # Prepend devPath to $PATH, because built environment refers to
          # installed profile
          export PATH="${devPath}:$PATH"

          # Override XDG, Starship configuration
          export XDG_CONFIG_HOME=${homeFiles}/.config
          export STARSHIP_CONFIG=${homeFiles}/.config/starship.toml

          # Customise invocation of bash to use custom initialisation scripts
          # and to use bash which has readline+complete (the original $SHELL
          # lacks readline+complete)
          export SHELL=${dev-bash}/bin/dev-bash

          # Unset, so that cfg.environment.etc.bashrc.source can do its work
          unset __ETC_BASHRC_SOURCED
          # Suppress NixOS default behavior of sourcing /etc/profile as part of /etc/bashrc.
          export __ETC_PROFILE_DONE=1
          source ${devBashrc}
        '';
      };
  in
  {
    darwinConfigurations.sven-mbp = mkDarwin "sven-mbp" darwin-pkgs darwin-pkgs-unstable;
    nixosConfigurations.archibald = mkNixos "archibald" linux-pkgs linux-pkgs-unstable [ disko.nixosModules.disko ];
    nixosConfigurations.temba = mkNixos "temba" linux-aarch64-pkgs linux-aarch64-pkgs-unstable [ ];

    devShells.${darwin64-system} = rec {
      sven-mbp = mkDevShell "sven-mbp" darwin-pkgs self.darwinConfigurations.sven-mbp;
      default = sven-mbp;
    };
    devShells.${linux-x86_64-system} = rec {
      archibald = mkDevShell "archibald" linux-pkgs self.nixosConfigurations.archibald;
      default = archibald;
    };
    devShells.${linux-aarch64-system} = rec {
      temba = mkDevShell "temba" linux-aarch64-pkgs self.nixosConfigurations.temba;
      default = temba;
    };
  };
}

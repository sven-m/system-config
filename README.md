# system-config

System configuration for my Macs (`nix-darwin`) and Linux machines (NixOS),
with `home-manager` deploying all dotfiles.

## Layout

```
flake.nix             inputs, one helper per platform, per-host devShells
hosts/<name>/         one directory per machine: what it imports, host packages, casks, Dock
modules/<name>/       one directory per feature: default.nix plus the files it deploys
```

Every `modules/<name>/default.nix` is a system-level (nix-darwin / NixOS)
module. Its home-manager part lives in `home-manager.users.${username}`, and
the dotfiles it links sit next to it (e.g. `modules/tmux/tmux.conf` becomes
`~/.config/tmux/tmux.conf`). A host picks its modules in its `imports` list.

Bash is configured through home-manager's `programs.bash` (`modules/bash`);
other modules add their own lines to it (`programs.bash.bashrcExtra` for exports
and `PATH`, `programs.bash.initExtra` for interactive setup), so e.g. the `nvim`
wrapper function lives in `modules/nvim`.

| Module | Contents |
|---|---|
| `common` | base CLI packages, fonts, env vars, aliases, bat/eza, home-manager defaults |
| `packages` | extra tools for the full machines |
| `darwin` | macOS settings, Homebrew (nix-homebrew) and shared casks, macOS-only tools |
| `bash`, `starship`, `tmux`, `git`, `lazygit`, `ghostty`, `ssh`, `nvim`, `gdu`, `npm`, `ansible`, `sublime` | the tool and its config |
| `xcode` | Xcode tooling, `xcode-build-server`, xcodebuild.nvim and the Swift parts of the Neovim config, Xcode themes |
| `cfg` | the `cfg` flake registry name and the Ctrl-x key bindings below |

Only files tracked by git are visible to the flake: `git add` new files before
building.

## Installation

1. Install Nix ([Determinate](https://determinate.systems/nix-installer/)).
   Homebrew does not need to be installed by hand; nix-homebrew does that.
2. Clone the repository to `~/src/system-config` (the tmux `apply-config`
   alias expects it there):
   ```sh
   git clone git@github.com:sven-m/system-config.git ~/src/system-config
   ```
3. Apply the configuration for this machine. Configurations are named after
   the hostname:
   ```sh
   cd ~/src/system-config

   # nix-darwin
   sudo nix run nix-darwin -- switch --flake .#<name>

   # nixos
   sudo nixos-rebuild switch --flake .#<name>
   ```
   After that, Ctrl-x s does this (see below).
4. Put private git settings in `~/.config/git/config.local` (not in the repo):
   ```ini
   [user]
     email = …
   ```

## Workflow

Every command is *command* + *flake*. The flake is one of:

| | Flake reference |
|---|---|
| the checkout you are in | `.` |
| GitHub, main | `cfg` |
| GitHub, a branch | `cfg/<branch>` (with slashes in the name: `'cfg?ref=claude/x'`) |

`cfg` is a flake registry name (system-wide, `/etc/nix/registry.json`, from
`modules/cfg`) for `git+ssh://git@github.com/sven-m/system-config`.

Two bash key bindings put the command on the prompt without running it, with
the cursor on the flake:

- **Ctrl-x s**: switch this machine (the configuration is picked by hostname)
  ```sh
  sudo darwin-rebuild switch --flake .|
  ```
  Backspace over the `.` and type `cfg` or `cfg/<branch>` for GitHub. On NixOS
  it is `nixos-rebuild`. The repository is private: root reaches GitHub through
  your 1Password SSH agent (system-wide `IdentityAgent` for github.com and
  GitHub's host key, from `modules/ssh`). Check once with
  `sudo ssh -T git@github.com`.
- **Ctrl-x p**: preview a program
  ```sh
  nix run .#preview-|
  ```
  Type `tmux` or `nvim`, or change the `.` to `cfg` / `cfg/<branch>`.

(`|` marks the cursor.) The same pattern, command + flake, covers the rest:

| | Switch | Preview a program |
|---|---|---|
| local | Ctrl-x s | `nix run .#preview-tmux` |
| main | Ctrl-x s, `cfg` | `nix run cfg#preview-tmux` |
| branch | Ctrl-x s, `cfg/<branch>` | `nix run cfg/<branch>#preview-nvim -- file` |

- Build without switching: `darwin-rebuild build --flake <flake>` /
  `nixos-rebuild build --flake <flake>`.
- Remote references are cached for a while; add `--refresh` right after
  pushing.
- In tmux: the `apply-config` alias switches from `~/src/system-config`.

### Trying changes in a dev shell

`nix develop` (this platform's host; `.#<name>` for another) opens a shell with that host's packages,
environment variables, aliases and the dotfiles home-manager *would* install,
built from the working tree (uncommitted changes included), without switching:

- `XDG_CONFIG_HOME` points at the shell's copy of `~/.config`, so nvim, git,
  lazygit, starship and friends use the new config.
- `tmux` runs a separate server (`-L dev`) that loads only the new
  `tmux.conf`; its panes (and other shells started from the dev shell) are dev
  shells too.
- The dev copy of `.bashrc` is sourced; the prompt shows the shell's name,
  e.g. `(tanagra)`.
- Machine-local files are referenced through `~`, so they keep working.
- Every shell in it (including tmux panes) starts the way a pane does after a
  switch: the new configuration's set-environment and `/etc/bashrc`, then the
  new packages in front of `PATH`, then the new `.bashrc`. Packages removed in
  the new configuration are still found in the installed system.
- The shell is a snapshot: after editing, `exit` and enter it again.

Also from a branch on GitHub, without a checkout:

```sh
nix develop cfg/<branch>
```

System-level changes (macOS defaults, services, casks) cannot be tried in a
shell; a `build` at least checks that they build.

### Previewing a single program

`nix run <flake>#preview-<program>` runs one program with the config
home-manager would install for this platform's host (darmok, jalad, temba),
built from the flake. Everything else (your shell, `PATH`, other programs)
stays the installed system.

```sh
nix run .#preview-tmux              # separate tmux server (-L preview) with the new tmux.conf
nix run .#preview-nvim -- file      # nvim with the new plugins and ~/.config/nvim
nix run cfg/<branch>#preview-tmux   # from a branch, without a checkout
```

tanagra's previews are `preview-tmux-tanagra` and `preview-nvim-tanagra`.

A running preview tmux server keeps its config: `tmux -L preview kill-server`
before previewing a change.

## Git config

`modules/git/config` is shared. At the end it includes:

1. `config.host`: per host, committed, written by the host module, e.g.
   ```nix
   home-manager.users.${username}.xdg.configFile."git/config.host".text = ''
     [includeIf "gitdir:~/src/work/"]
       path = ~/.config/git/work.local
   '';
   ```
2. `~/.config/git/config.local`: uncommitted, for private settings such as the
   email address.

Later includes override earlier settings; missing files are skipped.

## Homebrew

- nix-homebrew installs and pins Homebrew itself (`flake.lock`). Taps are not
  declared, so formulae and casks come from Homebrew's API.
- CLI tools come from nixpkgs. The only formula is `xcode-build-server`
  (`modules/xcode`), which nixpkgs does not have.
- Casks are listed in `homebrew.casks` (`modules/darwin`, `modules/xcode`,
  hosts).
- App Store apps are not managed; install them by hand.
- A switch only installs what is missing, it never uninstalls
  (`onActivation.cleanup = "none"`). `brew bundle` uses the generated
  Brewfile, so cleaning up is:
  ```sh
  brew bundle cleanup           # list what is installed but not configured
  brew bundle cleanup --force   # remove it
  ```
  The generated Brewfile for a host:
  `nix eval --raw .#darwinConfigurations.<name>.config.homebrew.brewfile`

## Moving a machine from the stow setup

1. **Before pulling this version**, remove the stow links from the old checkout:
   `stow -D .`
2. Pull, then step 3 of the installation.
   home-manager refuses to overwrite files it does not manage; move any it
   reports out of the way and switch again. It now also writes `~/.profile`
   (bash is configured through `programs.bash`), so an existing one will be
   reported.
3. Check that `~/.config/git/config.local` has the email address.
4. On a Mac: check that `brew` works (nix-homebrew's `autoMigrate` takes over
   the existing installation), then `brew bundle cleanup` to see leftover
   formulae that now come from Nix, and `brew bundle cleanup --force` to
   remove them.
5. Anything that was in uncommitted changes to the old dotfiles (e.g. per-host
   git settings) goes into the host module or `config.local`.

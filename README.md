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

| Module | Contents |
|---|---|
| `common` | base CLI packages, fonts, env vars, aliases, bat/eza, home-manager defaults |
| `packages` | extra tools for the full machines |
| `darwin` | macOS settings, Homebrew (nix-homebrew) and shared casks, macOS-only tools |
| `bash`, `starship`, `tmux`, `git`, `lazygit`, `ghostty`, `ssh`, `nvim`, `gdu`, `npm`, `ansible`, `sublime` | the tool and its config |
| `xcode` | Xcode tooling, `xcode-build-server`, xcodebuild.nvim and the Swift parts of the Neovim config, Xcode themes |
| `conf` | the `conf` command |

Only files tracked by git are visible to the flake: `git add` new files before
building.

## Installation

1. Install Nix ([Determinate](https://determinate.systems/nix-installer/)).
   Homebrew does not need to be installed by hand; nix-homebrew does that.
2. Clone the repository to `~/src/system-config` (or set `CFG_HOME` in the host
   module to where it lives):
   ```sh
   git clone https://github.com/sven-m/system-config.git ~/src/system-config
   ```
3. Apply the configuration for this machine:
   ```sh
   cd ~/src/system-config

   # nix-darwin
   sudo nix run nix-darwin -- switch --flake .#<name>

   # nixos
   sudo nixos-rebuild switch --flake .#<name>
   ```
4. Put private git settings in `~/.config/git/config.local` (not in the repo):
   ```ini
   [user]
     email = …
   ```
   `conf switch` asks for the email address when it is missing.

## Workflow

`conf` works from any directory (it uses `$CFG_HOME`, and `$CFG_NAME` which
each host sets to its configuration name):

```sh
conf edit      # open the checkout in $EDITOR
conf dev       # dev shell for this host, from the working tree
conf build     # build without switching
conf switch    # build and switch (also: conf apply)
conf           # build, then wait for a key press
```

### Trying changes in a dev shell

`nix develop .#<name>` (or `conf dev`) opens a shell with that host's packages
and the dotfiles home-manager *would* install, built from the working tree
(uncommitted changes included), without switching:

- `XDG_CONFIG_HOME` points at the shell's copy of `~/.config`, so nvim, git,
  lazygit, starship and friends use the new config.
- `tmux` runs a separate server (`-L dev`) so the new `tmux.conf` is loaded.
- The dev copy of `.bashrc` is sourced; the prompt shows the shell's name,
  e.g. `(tanagra)`.
- Machine-local files are referenced through `~`, so they keep working.
- The shell is a snapshot: after editing, `exit` and enter it again.

Also from a branch on GitHub, without a checkout:

```sh
nix develop "git+ssh://git@github.com/sven-m/system-config?ref=<branch>#$CFG_NAME"
```

System-level changes (macOS defaults, services, casks) cannot be tried in a
shell; `conf build` at least checks that they build.

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
2. Pull, then `conf switch` (or step 3 of the installation).
   home-manager refuses to overwrite files it does not manage; move any it
   reports out of the way and switch again.
3. Check that `~/.config/git/config.local` has the email address.
4. On a Mac: check that `brew` works (nix-homebrew's `autoMigrate` takes over
   the existing installation), then `brew bundle cleanup` to see leftover
   formulae that now come from Nix, and `brew bundle cleanup --force` to
   remove them.
5. Anything that was in uncommitted changes to the old dotfiles (e.g. per-host
   git settings) goes into the host module or `config.local`.

# system-config

The primary system configuration for my macbook that uses `nix`, `nix-darwin` and `home-manager`.

## Installation

1. Clone the repository
   ```sh
   git clone https://github.com/sven-m/system-config.git
   ```
2. Set `$CFG_HOME` in `~/.config/cfg_home_env`
   ```
   cd system-config
   echo export CFG_HOME=\"$PWD\" > ~/.config/cfg_home_env
   ```

4. Apply the configuration by running:
   ```sh
   # nix-darwin
   nix run nix-darwin -- switch --flake .#variant

   # nixos
   nixos-rebuild switch --flake .#variant
   ```

## Edit & Update Aliases

The configuration defines 2 aliases useful for changing and updating the configuration from anywhere.
```sh
modify-cfg  # open the root folder of the sytem config repository in $EDITOR
rebuild-cfg # re-apply the configuration
```

## Migration plan (proposal)

Status: under evaluation, nothing below is implemented yet (except the demo
`devShell` in `flake.nix`).

Goal: drop stow, let home-manager deploy all dotfiles from per-module
directories, test changes in a per-host `nix develop` shell before switching,
and make Homebrew itself part of the flake.

### 1. Structure

- One directory per feature, `modules/<name>/default.nix`, with the files that
  module deploys living next to it. One directory per machine,
  `hosts/<name>/default.nix`. The `dotfiles/` directory goes away.
- Every module is a system-level module (nix-darwin or NixOS). Its
  home-manager settings go inside `home-manager.users.${username}`. Hosts pull
  modules in with a single `imports = [ … ];` list.

```
system-config/
├── flake.nix                        // inputs (+ nix-homebrew), one helper per host, per-host devShells
├── flake.lock
├── README.md
├── hosts/
│   ├── darmok/default.nix           // CFG_NAME, host packages (incl. libssh, openssh) and casks, Dock, tailscale, imports
│   ├── tanagra/default.nix          // CFG_NAME, work casks, Dock, git config.host, imports
│   ├── jalad/
│   │   ├── default.nix              // boot + initrd SSH unlock, GNOME/xrdp, users, 1Password, Steam
│   │   ├── hardware.nix
│   │   └── disko.nix
│   └── temba/
│       ├── default.nix              // UTM VM: 9p share, i3, autologin
│       └── hardware.nix
└── modules/
    ├── common/default.nix           // base CLI packages, fonts, env vars, aliases, bat/eza, home-manager defaults
    ├── packages/default.nix         // was common-packages.nix (extra tools; not imported on temba)
    ├── darwin/default.nix           // macOS defaults, Touch ID sudo, nix-homebrew, general casks,
    │                                // aria2, xcp, mas, container, syncthing
    ├── bash/                        // bashrc, bash_profile
    ├── starship/                    // starship.toml (+ $nix_shell for the dev-shell prompt)
    ├── tmux/                        // tmux.conf, session-dir-picker (packaged onto PATH)
    ├── git/                         // config (includes config.host and config.local), git-symbolic-ref-or-commit
    ├── lazygit/                     // config.yml
    ├── ghostty/                     // config (config.orig dropped)
    ├── ssh/                         // config + 1Password agent.sock link (Darwin/Linux path chosen by platform)
    ├── nvim/
    │   ├── default.nix              // plugins (minus xcodebuild), vimwiki-diary-template on nvim's PATH only
    │   ├── vimwiki-diary-template
    │   └── config/                  // → ~/.config/nvim (lsp.lua without the sourcekit line)
    ├── xcode/                       // macOS only
    │   ├── default.nix              // xcodebuild.nvim, Catppuccin Xcode theme, swiftformat, xcbeautify,
    │   │                            // libimobiledevice, ideviceinstaller, brew "xcode-build-server"
    │   ├── delete-derived-data      // packaged onto PATH
    │   └── nvim/                    // merged into ~/.config/nvim: xcodebuild.lua, sourcekit (lsp + enable),
    │                                // xcode_preset.lua, after/ftplugin/swift.lua, Swift treesitter queries
    ├── sublime/                     // macOS only: Preferences.sublime-settings
    ├── ansible/                     // ansible.cfg (vault path fixed), personal-ansible-vault-pass
    ├── npm/                         // npmrc, written with the real home directory
    ├── gdu/                         // gdu.yaml
    └── conf/                        // conf script (+ `conf dev`, stow parts removed)
```

### 2. Dotfiles through home-manager

- Each module links its own files into `~`, one link per file
  (`xdg.configFile`/`home.file` with `recursive = true` for directories).
- Shell scripts are packaged (`writeShellScriptBin`) and moved into the module
  that uses them; `~/.local/bin` is no longer managed by the repo.
- Stow, `.stowrc` and the stow parts of `conf` are removed.
- Only files tracked by git are seen by the flake: new files need `git add`.

### 3. Git config layering

The shared `config` includes, in order:

1. `~/.config/git/config.host`: per host, committed, written by the host module
   (e.g. `xdg.configFile."git/config.host".text = …`).
2. `~/.config/git/config.local`: uncommitted, not managed by Nix. Holds the
   email address and anything else private. Missing files are silently skipped
   by git.

### 4. Homebrew

- **nix-homebrew** (new flake input) in `modules/darwin/`:
  ```nix
  nix-homebrew = {
    enable = true;
    user = username;
    autoMigrate = true;   # take over the existing, manually installed Homebrew
  };
  ```
  Homebrew itself is pinned by `flake.lock` and installed automatically on a
  new Mac. No taps are declared, so formulae and casks still come from
  Homebrew's API (unpinned), which suits self-updating casks.
- **Formulae** move to Nix packages, except `xcode-build-server` (not in
  nixpkgs), which stays a formula in the `xcode` module.

  | Formula | Moves to |
  |---|---|
  | `aria2`, `xcp`, `mas` | `darwin` / `common` |
  | `container` | `darwin` (Apple Silicon only) |
  | `swiftformat`, `xcbeautify`, `libimobiledevice`, `ideviceinstaller` | `xcode` |
  | `libssh`, `openssh` | darmok host |
  | `xcode-build-server` | stays `homebrew.brews` in `xcode` |

- **Casks** stay in nix-darwin's `homebrew.casks`, split over modules and hosts.
- **App Store apps**: no `masApps`. Managed by hand; `switch` never checks them.
- **Cleanup**: `homebrew.onActivation.cleanup = "none"`, so a switch only
  installs and never uninstalls. `homebrew.global.brewfile = true` points
  `brew bundle` at the generated Brewfile, so manual cleanup is:
  ```sh
  brew bundle cleanup           # list what is installed but not in the config
  brew bundle cleanup --force   # remove it
  ```
  The generated Brewfile can be printed without switching:
  `nix eval --raw .#darwinConfigurations.$CFG_NAME.config.homebrew.brewfile`

### 5. Per-host dev shells

- `devShells.<system>.<CFG_NAME>`, generated from each configuration, built
  from that host's `home.path` (packages, nvim with plugins) and `home-files`
  (the dotfiles home-manager would install). Replaces the demo shell.
  ```sh
  nix develop .#$CFG_NAME
  nix develop "git+ssh://git@github.com/sven-m/system-config?ref=<branch>#$CFG_NAME"
  ```
- `XDG_CONFIG_HOME` points at the shell's store copy of `.config`; programs
  that need a flag get a wrapper on `PATH` (e.g. `tmux -L dev -f …`) rather than
  an alias, so it also applies to programs started from the shell.
- Machine-local files are referenced through `~` (never `$XDG_CONFIG_HOME`), so
  they keep working inside the dev shell.
- **Prompt**: starship's `$nix_shell` module added to the format, the shell's
  `name` set to the host name, `STARSHIP_CONFIG` pointed at the store copy and
  `starship init bash` run from `shellHook`, so the prompt shows e.g.
  `(tanagra)`.
- The shell is a snapshot: after editing, leave and re-enter it.

### 6. `conf` and README

- `conf dev` runs `nix develop "$PWD#$CFG_NAME"`.
- The fallback `git`/`stow` aliases in `conf` (never expanded in a script) are
  replaced with functions or removed.
- README rewritten for the new install steps and the
  edit → dev shell → switch workflow.

### 7. Small fixes along the way

- tmux reload binding sources `~/.config/tmux/tmux.conf` instead of the file
  actually loaded.
- `.ansible.cfg` points at `~/bin/…`; the script lives elsewhere.
- `.npmrc` hard-codes `/Users/sven`.
- `lualine-nvim` is listed twice in the neovim plugins.
- `ghostty/config.orig` is a stray file.

### Hand-over on each machine

1. `stow -D .` in the old checkout before the first switch (or set
   `home-manager.backupFileExtension`).
2. Create `~/.config/git/config.local` with the email address if missing.
3. After the first switch, check that `brew` still works (nix-homebrew
   `autoMigrate` takes over the existing installation).
4. `brew bundle cleanup` to find and remove leftover formulae.
5. Re-run `xcode-build-server config` in Xcode projects only if their
   `buildServer.json` stops resolving.

### Implementation order

1. Module layout (move files, no behaviour change yet).
2. home-manager deploys the dotfiles; stow removed.
3. Homebrew: nix-homebrew, formulae to Nix, cleanup settings.
4. Per-host dev shells and the prompt.
5. `conf dev` and the README rewrite.

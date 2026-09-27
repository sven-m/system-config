# system-config

nix-darwin and NixOS configurations for darmok, tanagra (macOS), jalad and
temba (NixOS), with home-manager for the dotfiles.

## Install

1. Switch to the flake from GitHub. Pick the configuration by name
   (`darmok`, `tanagra`, `jalad`, `temba`).

   Root does the fetch but has no access to the private repository yet, so
   hand it your SSH agent (`SSH_AUTH_SOCK`) and your `known_hosts` for this
   one command.

   macOS (1Password's agent):
   ```sh
   sudo env \
     SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock" \
     GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=$HOME/.ssh/known_hosts" \
     nix run nix-darwin -- switch --flake 'git+ssh://git@github.com/sven-m/system-config#darmok'
   ```

   NixOS (the agent in your current `SSH_AUTH_SOCK`):
   ```sh
   sudo env \
     SSH_AUTH_SOCK="$SSH_AUTH_SOCK" \
     GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=$HOME/.ssh/known_hosts" \
     nixos-rebuild switch --flake 'git+ssh://git@github.com/sven-m/system-config#jalad'
   ```

   With a key file instead of an agent, leave out `SSH_AUTH_SOCK` and add
   `-i $HOME/.ssh/<key>` to `GIT_SSH_COMMAND`. For a branch, add
   `?ref=<branch>` before the `#`.

   After this, root reaches GitHub through your agent on its own
   (`modules/ssh`):
   ```sh
   sudo darwin-rebuild switch --flake cfg    # or nixos-rebuild
   ```

## Development

1. Clone the repository:
   ```sh
   git clone git@github.com:sven-m/system-config.git ~/src/system-config
   ```
2. Install the flake from the local copy:
   ```sh
   cd ~/src/system-config

   # macOS
   sudo darwin-rebuild switch --flake .#darmok

   # NixOS
   sudo nixos-rebuild switch --flake .#jalad
   ```

The flake only sees files git knows about: `git add` new files first.

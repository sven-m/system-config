#!/usr/bin/env bash

set -e
set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BASH_ENV_LOCAL="$SCRIPT_DIR/dotfiles/.bash_env"

touch "$BASH_ENV_LOCAL"
touch "$SCRIPT_DIR/dotfiles/.config/git/config.email"
source "$BASH_ENV_LOCAL"

if [ -z "$CFG_DIR" ] || [ -z "$CFG_VARIANT" ]
then
  echo "Add to $BASH_ENV_LOCAL and adjust:"
  echo
  echo "export CFG_DIR=${CFG_DIR:-$SCRIPT_DIR}"
  echo "export CFG_VARIANT=darmok/tanagra"

  echo
  echo "Then re-run this command. Exiting."
  exit 1
fi

echo
echo "==> Running stow"
# Run stow
pushd "$CFG_DIR/dotfiles"
nix run "$CFG_DIR#stow" -- --verbose .
popd

# Apply nix flake
echo
echo "==> Applying nix flake at $CFG_DIR"
nix run nix-darwin -- switch --flake "$CFG_DIR#$CFG_VARIANT"

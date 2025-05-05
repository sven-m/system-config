#!/usr/bin/env bash

set -e
set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

ZSHENV_LOCAL="$SCRIPT_DIR/dotfiles/.bash_env"
CFG_LINE="export CFG_DIR=\"$SCRIPT_DIR\""

# Ensure dotfiles/.config/zsh/zshenv.local contains CFG= line
if ! grep -qF "$CFG_LINE" "$ZSHENV_LOCAL"
then
  echo "$CFG_LINE" >> "$ZSHENV_LOCAL"
  echo "Added \"$CFG_LINE\" to $ZSHENV_LOCAL"
  echo "Future rebuilds will rely on this to detect flake and stow location"
fi

source "$ZSHENV_LOCAL"

# Run stow
cd "$SCRIPT_DIR/dotfiles"
nix run "$SCRIPT_DIR#stow" -- --verbose .

# Apply nix flake
echo "Applying nix flake at $SCRIPT_DIR"
nix run nix-darwin -- switch --flake "$SCRIPT_DIR#macbook"

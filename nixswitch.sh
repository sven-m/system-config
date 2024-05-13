#!/usr/bin/env sh

pushd ~/src/system-config

nix --extra-experimental-features "nix-command flakes" build .#darwinConfigurations.sven-mbp.system \
  && ./result/sw/bin/darwin-rebuild switch --flake ~/src/system-config

popd
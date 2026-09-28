# nix-darwin installs the app and CLI where 1Password needs them for the app
# to unlock the CLI. Updates come from nixpkgs, not the app.

{ ... }:

{
  programs._1password.enable = true;
  programs._1password-gui.enable = true;
}

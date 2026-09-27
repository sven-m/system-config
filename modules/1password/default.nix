/*

1Password: the app and the `op` CLI, from nixpkgs on both platforms

On macOS nix-darwin copies the app to /Applications/1Password.app and the CLI
to /usr/local/bin/op, the locations 1Password needs for the app to unlock the
CLI. The app does not update itself; it follows nixpkgs.

The SSH agent socket is used in modules/ssh.

*/

{ ... }:

{
  programs._1password.enable = true;
  programs._1password-gui.enable = true;
}

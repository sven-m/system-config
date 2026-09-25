/*

ssh client config, and the ~/.ssh/agent.sock link to the 1Password agent that
it points IdentityAgent at

*/

{ pkgs, home-manager, username, ... }:

let
  onePasswordAgentSocket =
    if pkgs.stdenv.isDarwin
    then "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    else "$HOME/.1password/agent.sock";
in
{
  home-manager.users.${username} = {
    home.file.".ssh/config".source = ./config;

    home.activation.sshAgentSocket = home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ] /* sh */ ''
      ln -sf "${onePasswordAgentSocket}" "$HOME/.ssh/agent.sock"
    '';
  };
}

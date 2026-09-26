/*

ssh client config, and the ~/.ssh/agent.sock link to the 1Password agent that
it points IdentityAgent at

System-wide, for root: `sudo darwin-rebuild switch --flake cfg` makes root
fetch the private repository over SSH. Root has no ~/.ssh/config of its own,
so the system config sends it to the same agent for github.com, and GitHub's
host key is known system-wide. Your own ~/.ssh/config is read first and wins.

*/

{ config, pkgs, home-manager, username, ... }:

let
  onePasswordAgentSocket =
    if pkgs.stdenv.isDarwin
    then "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    else "$HOME/.1password/agent.sock";
in
{
  programs.ssh.extraConfig = ''
    Host github.com
      IdentityAgent ${config.users.users.${username}.home}/.ssh/agent.sock
  '';

  # SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU, as published by GitHub
  programs.ssh.knownHosts."github.com".publicKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";

  home-manager.users.${username} = {
    home.file.".ssh/config".source = ./config;

    home.activation.sshAgentSocket = home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ] /* sh */ ''
      ln -sf "${onePasswordAgentSocket}" "$HOME/.ssh/agent.sock"
    '';
  };
}

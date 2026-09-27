# System-wide config, so root can use the 1Password agent for GitHub too

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

  # SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU
  programs.ssh.knownHosts."github.com".publicKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";

  home-manager.users.${username} = {
    home.file.".ssh/config".source = ./config;

    home.activation.sshAgentSocket = home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ] /* sh */ ''
      ln -sf "${onePasswordAgentSocket}" "$HOME/.ssh/agent.sock"
    '';
  };
}

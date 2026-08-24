{ pkgs, pkgs-unstable, ... }:

{
  environment.systemPackages = with pkgs; [
    bruno
    bruno-cli
    btop
    ipatool
    iperf2
    jekyll
    kubernetes-helm
    mitmproxy
    nodejs
    pkgs-unstable.gdu
    s3cmd
    sshpass
    syncthing
  ];
}

{ pkgs, ... }:

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
    ncdu
    nodejs
    s3cmd
    sshpass
    syncthing
  ];
}

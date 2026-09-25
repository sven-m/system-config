/*

Extra tools for the full machines (not the temba VM)

*/

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
    nodejs
    s3cmd
    sshpass
    syncthing
  ];
}

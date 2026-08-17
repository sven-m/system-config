{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bruno
    bruno-cli
    btop
    diff-so-fancy # used in gitconfig
    fzf
    git
    git-lfs # needed for some projects
    gnused
    ipatool
    iperf2
    jekyll
    kubernetes-helm
    lazygit
    less
    mitmproxy
    nodejs
    s3cmd
    sshpass
    starship # prompt for shell
    stow # used for dotfiles
    syncthing
    tmux
    tree
    vscode
    yamllint
  ];
}

{ username, ... }:

{
  # environment.localBinInPath does this, but is NixOS-only
  environment.extraInit = ''
    export PATH="$HOME/.local/bin:$PATH"
  '';

  home-manager.users.${username} = {
    programs.bash = {
      enable = true;

      historyControl = [ "ignorespace" ];

      historySize = null;
      historyFileSize = null;
      shellOptions = [ ];
      # programs.bash.completion in modules/common
      enableCompletion = false;
    };
  };
}

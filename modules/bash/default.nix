{ username, ... }:

{
  # environment.localBinInPath does this, but is NixOS-only
  environment.extraInit = ''
    export PATH="$HOME/.local/bin:$PATH"
  '';

  # temporary, not exported: set only in shells that ran this themselves
  programs.bash.interactiveShellInit = ''
    BASH_INTERACTIVE_INIT_MARKER=1
  '';

  home-manager.users.${username} = {
    # temporary: shows which shells load home-manager's session variables
    home.sessionVariables.HM_SESSION_VARS_MARKER = "1";

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

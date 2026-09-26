/*

Bash, through home-manager: it generates ~/.bashrc, ~/.bash_profile and
~/.profile. Other modules add to it:

- aliases: programs.bash.shellAliases
- functions, key bindings, integrations: programs.bash.initExtra

*/

{ username, ... }:

{
  # first in PATH, ahead of everything else. What NixOS's
  # environment.localBinInPath does, but that option is NixOS-only.
  environment.extraInit = ''
    export PATH="$HOME/.local/bin:$PATH"
  '';

  home-manager.users.${username} = {
    programs.bash = {
      enable = true;

      historyControl = [ "ignorespace" ];

      # keep bash's own defaults rather than home-manager's
      historySize = null;
      historyFileSize = null;
      shellOptions = [ ];
      # completion comes from the system (programs.bash.completion in modules/common)
      enableCompletion = false;
    };
  };
}

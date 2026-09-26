/*

Bash, through home-manager: it generates ~/.bashrc, ~/.bash_profile and
~/.profile. Other modules add to it:

- paths and path-like variables: home.sessionPath, home.sessionVariables
- aliases: programs.bash.shellAliases
- functions, key bindings, integrations: programs.bash.initExtra

*/

{ lib, username, ... }:

{
  home-manager.users.${username} = { config, ... }: {
    # first in PATH, ahead of the other modules' entries
    home.sessionPath = lib.mkBefore [ "$HOME/.local/bin" ];

    programs.bash = {
      enable = true;

      historyControl = [ "ignorespace" ];

      # keep bash's own defaults rather than home-manager's
      historySize = null;
      historyFileSize = null;
      shellOptions = [ ];
      # completion comes from the system (programs.bash.completion in modules/common)
      enableCompletion = false;

      # home-manager only loads the session variables from ~/.profile (login
      # shells); terminals on NixOS start non-login shells. The script guards
      # itself, so this is a no-op when a login shell already ran it.
      bashrcExtra = lib.mkBefore ''
        source "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh"
      '';
    };
  };
}

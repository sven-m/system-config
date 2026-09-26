/*

Bash, through home-manager: it generates ~/.bashrc, ~/.bash_profile and
~/.profile. Other modules add their own lines (programs.bash.bashrcExtra for
exports and PATH, programs.bash.initExtra for interactive setup).

*/

{ lib, username, ... }:

{
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

      bashrcExtra = lib.mkMerge [
        # before the other modules' bashrcExtra, which use prepend_path
        (lib.mkBefore ''
          prepend_path () {
            case ":$PATH:" in
              *:"$1":*)
                ;;
              *)
                PATH="$1''${PATH:+:$PATH}"
            esac
          }
        '')
        # after them, so it ends up first in PATH
        (lib.mkAfter ''
          prepend_path "$HOME/.local/bin"
        '')
      ];

      initExtra = ''
        # Runs command and all arguments and resets cursor back to vertical bar
        command_and_reset_cursor() {
          command "$@"
          local status=$?
          printf "\e[6 q"
          return $status
        }
      '';
    };
  };
}

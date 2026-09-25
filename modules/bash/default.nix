/*

Bash: ~/.bashrc and ~/.bash_profile

*/

{ username, ... }:

{
  home-manager.users.${username} = {
    home.file.".bashrc".source = ./bashrc;
    home.file.".bash_profile".source = ./bash_profile;
  };
}

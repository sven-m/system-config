/*

Ansible: vault password from 1Password

*/

{ pkgs, username, ... }:

let
  vault-pass = pkgs.writeShellScriptBin "personal-ansible-vault-pass" (builtins.readFile ./personal-ansible-vault-pass);
in
{
  environment.systemPackages = [ vault-pass ];

  home-manager.users.${username} = {
    programs.bash.bashrcExtra = ''
      export ANSIBLE_VAULT_PASSWORD_FILE=${vault-pass}/bin/personal-ansible-vault-pass
    '';

    home.file.".ansible.cfg".text = ''
      [defaults]
      vault_password_file = ${vault-pass}/bin/personal-ansible-vault-pass
    '';
  };
}

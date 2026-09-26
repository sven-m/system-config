/*

Neovim: plugins, config and helper scripts

Swift/Xcode support lives in modules/xcode, which adds its own plugin and
files to ~/.config/nvim.

*/

{ pkgs, username, ... }:

let
  vimwiki-diary-template = pkgs.writeShellScriptBin "vimwiki-diary-template"
    (builtins.readFile ./vimwiki-diary-template);
in
{
  # system-wide, so root (sudoedit, sudo -i) gets it too
  environment.variables.EDITOR = "nvim";

  home-manager.users.${username} = {
    programs.neovim.enable = true;
    programs.neovim.sideloadInitLua = true;
    programs.neovim.withRuby = true;
    programs.neovim.withPython3 = false;

    # only on nvim's PATH, used by after/ftplugin/vimwiki.lua
    programs.neovim.extraPackages = [ vimwiki-diary-template ];

    programs.neovim.plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      adwaita-nvim
      fzf-lua
      gitsigns-nvim
      lualine-nvim
      nvim-dap
      nvim-dap-ui
      nvim-dap-virtual-text
      nvim-nio
      nvim-lsp-file-operations
      nvim-treesitter.withAllGrammars
      nui-nvim
      vim-nix
      vim-vinegar
      (
        pkgs.vimUtils.buildVimPlugin {
          pname = "vimwiki-wikilinks";
          version = "v2024.01.24-wikilinks";
          src = pkgs.fetchFromGitHub {
            owner = "sven-m";
            repo = "vimwiki";
            rev= "602920c7dc66badb58540b91ba0be872bf430375";
            hash = "sha256-jHR0Q3XLEdn2Og5AzTNXIFEvVpz9SCjUb2ms5V7YjSY=";
          };
        }
      )
    ];

    # resets the cursor to a vertical bar afterwards
    programs.bash.initExtra = ''
      nvim() {
        command nvim "$@"
        local status=$?
        printf "\e[6 q"
        return $status
      }
    '';

    # each file under config/ linked individually into ~/.config/nvim/
    xdg.configFile."nvim" = {
      source = ./config;
      recursive = true;
    };
  };
}

# modules/xcode adds its own plugin and files to ~/.config/nvim

{ pkgs, username, ... }:

let
  vimwiki-diary-template = pkgs.writeShellScriptBin "vimwiki-diary-template"
    (builtins.readFile ./vimwiki-diary-template);
in
{
  # system-wide, so root (sudoedit) gets it too
  environment.variables.EDITOR = "nvim";

  home-manager.users.${username} = {
    programs.neovim.enable = true;
    programs.neovim.sideloadInitLua = true;
    programs.neovim.withRuby = true;
    programs.neovim.withPython3 = false;

    # used by after/ftplugin/vimwiki.lua
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
          version = "2024-10-13";
          src = pkgs.fetchFromGitHub {
            owner = "vimwiki";
            repo = "vimwiki";
            rev = "72792615e739d0eb54a9c8f7e0a46a6e2407c9e8";
            hash = "sha256-O85nZUWxIKm0gFILAkWH9WqfVcEbnbxR56grqMmum3A=";
          };
          # use [[wikilinks]] instead of markdown links, also in markdown syntax
          patches = [ ./vimwiki-wikilinks.patch ];
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

    # per file, so modules/xcode can add files to the same directory
    xdg.configFile."nvim" = {
      source = ./config;
      recursive = true;
    };
  };
}

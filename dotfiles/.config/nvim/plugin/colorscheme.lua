require("catppuccin").setup({
  background = { light = "latte", dark = "mocha" },
  integrations = {
    vimwiki = true,
    lualine = true,
    gitsigns = true,
    fzf = true,
    dap = true,
    dap_ui = true,
  },
  custom_highlights = function(C)
    return {
      -- muted text (plugin/lualine.lua)
      SvenMuted = { fg = C.overlay1 },

      -- netrw (plugin/netrw.lua)
      netrwMarkFile = { fg = C.base, bg = C.peach, bold = true },

      -- dap (plugin/xcodebuild.lua); was hardcoded #313244, which is surface0
      DapStoppedLine = { bg = C.surface0 },
    }
  end,
})

-- The same groups for github-nvim-theme (only its light variant is used).
-- Values are paths into the theme's spec (bg1 = background, fg1 = text, fg3 =
-- line numbers) or its palette.
require("github-theme").setup({
  groups = {
    all = {
      SvenMuted = { fg = "fg3" },

      netrwMarkFile = { fg = "bg1", bg = "palette.orange", style = "bold" },

      DapStoppedLine = { bg = "palette.attention.subtle" },
    },
  },
})

-- loads `colors/github-mocha.lua`. Not until VimEnter: the themes set
-- 'background' while loading, and if that has happened by VimEnter Neovim
-- stops updating 'background' from the terminal's light/dark mode. This
-- autocmd runs after Neovim's check.
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  nested = true,
  callback = function()
    vim.cmd.colorscheme "github-mocha"
  end,
})

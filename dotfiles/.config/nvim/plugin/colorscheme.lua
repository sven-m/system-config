-- Which theme to use: "github-mocha" (GitHub Light Default when light,
-- Catppuccin Mocha when dark; colors/github-mocha.lua) or "catppuccin" (Latte
-- when light, Mocha when dark). Both follow the terminal's light/dark mode.
-- Theme-specific colours used elsewhere (netrw marks, dap, lualine's muted
-- text) are highlight groups defined for both themes below, so switching is
-- just this line.
local theme = "github-mocha"

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

vim.cmd.colorscheme(theme)

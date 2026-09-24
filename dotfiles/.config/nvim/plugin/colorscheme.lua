-- Which theme to use: "github-mocha" (GitHub Light Default when light,
-- Catppuccin Mocha when dark; colors/github-mocha.lua) or "catppuccin" (Latte
-- when light, Mocha when dark). Both follow the terminal's light/dark mode.
-- Theme-specific colours used elsewhere (tabline pills, netrw marks, dap,
-- lualine's muted text) are highlight groups defined for both themes below,
-- so switching is just this line.
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

      -- pill tabline (plugin/tabline.lua)
      TabLine = { bg = "NONE", fg = C.overlay0 },
      TabLineFill = { bg = "NONE" },

      SvenPillActiveLeft = { fg = C.mauve, bg = C.base },
      SvenPillActiveIndex = { fg = C.base, bg = C.mauve, bold = true },
      SvenPillActiveName = { fg = C.text, bg = C.surface1 },
      SvenPillActiveRight = { fg = C.surface1, bg = C.base },

      SvenPillInactiveLeft = { fg = C.overlay2, bg = C.base },
      SvenPillInactiveIndex = { fg = C.base, bg = C.overlay2 },
      SvenPillInactiveName = { fg = C.text, bg = C.surface0 },
      SvenPillInactiveRight = { fg = C.surface0, bg = C.base },

      -- dap (plugin/xcodebuild.lua); was hardcoded #313244, which is surface0
      DapStoppedLine = { bg = C.surface0 },
    }
  end,
})

-- The same groups for github-nvim-theme (only its light variant is used). Values are paths into the theme's
-- spec (bg1 = background, fg1 = text, fg3 = line numbers) or its palette.
require("github-theme").setup({
  groups = {
    all = {
      SvenMuted = { fg = "fg3" },

      netrwMarkFile = { fg = "bg1", bg = "palette.orange", style = "bold" },

      TabLine = { bg = "NONE", fg = "fg3" },
      TabLineFill = { bg = "NONE" },

      SvenPillActiveLeft = { fg = "palette.accent.fg", bg = "bg1" },
      SvenPillActiveIndex = { fg = "bg1", bg = "palette.accent.fg", style = "bold" },
      SvenPillActiveName = { fg = "fg1", bg = "palette.neutral.muted" },
      SvenPillActiveRight = { fg = "palette.neutral.muted", bg = "bg1" },

      SvenPillInactiveLeft = { fg = "fg3", bg = "bg1" },
      SvenPillInactiveIndex = { fg = "bg1", bg = "fg3" },
      SvenPillInactiveName = { fg = "fg1", bg = "palette.neutral.subtle" },
      SvenPillInactiveRight = { fg = "palette.neutral.subtle", bg = "bg1" },

      DapStoppedLine = { bg = "palette.attention.subtle" },
    },
  },
})

vim.cmd.colorscheme(theme)

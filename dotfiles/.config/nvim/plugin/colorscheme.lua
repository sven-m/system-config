require("catppuccin").setup({
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

vim.cmd.colorscheme "catppuccin-mocha"

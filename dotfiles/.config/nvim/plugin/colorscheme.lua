require("catppuccin").setup({
  -- follow vim.o.background, which nvim detects from the terminal at startup
  background = { light = "latte", dark = "mocha" },
  -- Latte with accents at 80% of their OKLCH chroma: same hue and lightness,
  -- contrast on base no lower than stock, closer to Mocha's pastel feel
  color_overrides = {
    latte = {
      rosewater = "#d08f80",
      flamingo = "#d07f7e",
      pink = "#db7fc1",
      mauve = "#804bd4",
      red = "#bf3644",
      maroon = "#d3575c",
      peach = "#ea723e",
      yellow = "#d29247",
      green = "#549c45",
      teal = "#3e8f94",
      sky = "#44a4d6",
      sapphire = "#479cad",
      blue = "#326ad9",
      lavender = "#778ae7",
    },
  },
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

vim.cmd.colorscheme "catppuccin"

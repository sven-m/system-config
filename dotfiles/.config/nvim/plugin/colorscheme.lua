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

-- loads `colors/adwaita-mocha.lua`
vim.cmd.colorscheme "adwaita-mocha"

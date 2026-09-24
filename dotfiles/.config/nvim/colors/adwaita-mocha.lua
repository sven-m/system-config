-- composite colorscheme, combination of catppuccin mocha (dark) and adwaita (light)
if vim.o.background == "light" then
  vim.cmd.runtime("colors/adwaita.lua")

  -- same groups as catppuccin's custom_highlights (plugin/colorscheme.lua),
  -- from Adwaita's palette
  local c = require("adwaita.utils").gen_colors()
  vim.api.nvim_set_hl(0, "SvenMuted", { fg = c.dark_1 }) -- its comment grey
  vim.api.nvim_set_hl(0, "netrwMarkFile", { fg = c.light_2, bg = c.orange_4, bold = true })
  vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = c.yellow_1 })
else
  -- no flavour: picks Mocha from 'background' without setting it
  require("catppuccin").load()
end
vim.g.colors_name = "adwaita-mocha"

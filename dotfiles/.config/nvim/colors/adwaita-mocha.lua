-- Adwaita when 'background' is light, Catppuccin Mocha when dark. Neovim
-- reloads the current colorscheme when 'background' changes (it follows the
-- terminal's light/dark mode), so this has to be one colorscheme that picks,
-- the way "catppuccin" picks Latte/Mocha. (A :colorscheme in here would be
-- ignored.) Neither sets 'background' itself; if a colorscheme does that
-- during startup, Neovim stops following the terminal.
if vim.o.background == "light" then
  vim.cmd.runtime("colors/adwaita.lua")

  -- same groups as catppuccin's custom_highlights (plugin/colorscheme.lua),
  -- from Adwaita's palette
  vim.api.nvim_set_hl(0, "SvenMuted", { fg = "#77767b" }) -- dark_1, its comments
  vim.api.nvim_set_hl(0, "netrwMarkFile", { fg = "#fcfcfc", bg = "#e66100", bold = true }) -- light_2 on orange_4
  vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#f9f06b" }) -- yellow_1
else
  -- no flavour: picks Mocha from 'background' without setting it
  require("catppuccin").load()
end
vim.g.colors_name = "adwaita-mocha"

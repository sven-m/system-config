-- lualine's own generated theme (colours taken from the colorscheme's
-- highlight groups, grey NORMAL label) instead of the colorscheme's bundled
-- lualine theme, plus small tweaks. lualine re-runs this file whenever the
-- colorscheme changes, so it follows light/dark.

-- In light mode (Adwaita, colors/adwaita-mocha.lua) adwaita.nvim's own
-- lualine theme instead.
if vim.g.colors_name == "adwaita-mocha" and vim.o.background == "light" then
  return dofile(vim.api.nvim_get_runtime_file("lua/lualine/themes/adwaita.lua", false)[1])
end

-- lualine's auto theme loads a bundled theme matching g:colors_name if there
-- is one; hide the name for a moment so it generates one instead
local colors_name = vim.g.colors_name
vim.g.colors_name = nil
local ok, theme = pcall(dofile, vim.api.nvim_get_runtime_file("lua/lualine/themes/auto.lua", false)[1])
vim.g.colors_name = colors_name
assert(ok, theme)

if colors_name == "catppuccin-latte" then
  -- white VISUAL label text reads better on Latte
  theme.visual.a.fg = "#ffffff"
end

return theme

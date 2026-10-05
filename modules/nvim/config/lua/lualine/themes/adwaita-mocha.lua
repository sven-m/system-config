-- adwaita.nvim's lualine theme when light (colors/adwaita-mocha.lua),
-- lualine's generated one otherwise
local function load(name)
  return dofile(vim.api.nvim_get_runtime_file("lua/lualine/themes/" .. name .. ".lua", false)[1])
end

if vim.o.background == "light" then
  return load("adwaita")
end

-- auto loads the theme named after vim.g.colors_name, i.e. this file, so hide
-- it to make auto generate one instead of recursing
local colors_name = vim.g.colors_name
vim.g.colors_name = nil
local ok, theme = pcall(load, "auto")
vim.g.colors_name = colors_name
if not ok then error(theme) end
return theme

-- GitHub Light Default when 'background' is light, Catppuccin Mocha when
-- dark. Neovim reloads the current colorscheme when 'background' changes (it
-- follows the terminal's light/dark mode), so this has to be one colorscheme
-- that picks, the way "catppuccin" picks Latte/Mocha. Both are loaded the way
-- their own colorschemes load them; a :colorscheme in here would be ignored.
if vim.o.background == "light" then
  require("github-theme").load({ theme = "github_light_default" })
else
  require("catppuccin").load("mocha")
end
vim.g.colors_name = "github-mocha"

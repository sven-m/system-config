-- GitHub Light/Dark Default, picked from 'background' the way the
-- "catppuccin" colorscheme picks Latte/Mocha. Neovim reloads the current
-- colorscheme when 'background' changes (it follows the terminal's light/dark
-- mode), so it has to be one name for both variants, not
-- github_light_default/github_dark_default themselves. (Loaded the way those
-- load; a :colorscheme in here would be ignored.)
require("github-theme").load({
  theme = vim.o.background == "light" and "github_light_default" or "github_dark_default",
})
vim.g.colors_name = "github"

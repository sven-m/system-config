-- adwaita.nvim's lualine theme when light (colors/adwaita-mocha.lua),
-- catppuccin's when dark; not "auto", which would load this file again
-- via vim.g.colors_name
local name = vim.o.background == "light" and "adwaita" or "catppuccin-mocha"
return dofile(vim.api.nvim_get_runtime_file("lua/lualine/themes/" .. name .. ".lua", false)[1])

-- adwaita.nvim's lualine theme when light (colors/adwaita-mocha.lua),
-- lualine's generated one otherwise
local name = vim.o.background == "light" and "adwaita" or "auto"
return dofile(vim.api.nvim_get_runtime_file("lua/lualine/themes/" .. name .. ".lua", false)[1])

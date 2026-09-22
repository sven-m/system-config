-- netrw (using vinegar)
--
-- This runs before packages are sourced, so g:netrw_banner is set before
-- vinegar loads; vinegar guards its own default with `if !exists(...)` and
-- therefore leaves ours alone. The netrwMarkFile highlight is defined in
-- plugin/colorscheme.lua.

-- Override vinegar's default, I like the banner
vim.g.netrw_banner = 1

-- workaround for netrw bug where copying a file and a dir together fails
vim.g.netrw_localcopycmdopt = "-R"

vim.keymap.set('n', '<leader>t', function()
  vim.cmd('Ntree ' .. vim.fn.getcwd())
end)

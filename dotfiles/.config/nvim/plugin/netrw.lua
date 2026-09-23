vim.g.netrw_banner = 1

-- workaround for netrw bug where copying a file and a dir together fails
vim.g.netrw_localcopycmdopt = "-R"

vim.keymap.set('n', '<leader>t', function()
  vim.cmd('Ntree ' .. vim.fn.getcwd())
end)

-- These contents are included in the generated ~/.config/nvim/init.lua

vim.opt.compatible = false

vim.opt.breakindent = true

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.list = true

vim.opt.number = true

vim.opt.lazyredraw = true
vim.opt.wrap = false
vim.opt.showcmd = true
vim.opt.showmatch = true

package.path = package.path .. ";" .. os.getenv("HOME") .. "/.config/nvim/?.lua"
require("init-local")

-- End included portion
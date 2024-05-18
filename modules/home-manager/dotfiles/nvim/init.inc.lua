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

require("nvim-tree").setup({
  git = {
    enable = true,
  },
  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
  update_focused_file = {
    enable = true,
    update_root = true,
  },
})

vim.keymap.set('', '<Leader>qq', '<cmd>qa!<CR>')
vim.keymap.set('', '<Leader>wq', '<cmd>wqa<CR>')
vim.keymap.set('', '<Leader>tt', '<cmd>NvimTreeToggle<CR>')
vim.keymap.set('', '<Leader>tr', '<cmd>NvimTreeRefresh<CR>')
vim.keymap.set('', '<Leader>tf', '<cmd>NvimTreeFocus<CR>')
vim.keymap.set('', '<C-h>', '<C-w>h')
vim.keymap.set('', '<C-j>', '<C-w>j')
vim.keymap.set('', '<C-k>', '<C-w>k')
vim.keymap.set('', '<C-l>', '<C-w>l')

package.path = package.path .. ";" .. os.getenv("HOME") .. "/.config/nvim/?.lua"
require("init-local")

-- End included portion

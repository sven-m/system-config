vim.opt.compatible = false

vim.opt.breakindent = true

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.list = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.lazyredraw = true
vim.opt.wrap = true
vim.opt.showcmd = true
vim.opt.showmatch = true

vim.g.startify_change_to_vcs_root = 0

require("nvim-tree").setup({
  sort = {
    folders_first = false,
  },
  git = {
    enable = true,
    ignore = false,
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

require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
})

vim.keymap.set('', '<Leader>tt', '<cmd>NvimTreeToggle<CR>')
vim.keymap.set('', '<Leader>tr', '<cmd>NvimTreeRefresh<CR>')
vim.keymap.set('', '<Leader>tf', '<cmd>NvimTreeFocus<CR>')
vim.keymap.set('', '<C-h>', '<C-w>h')
vim.keymap.set('', '<C-j>', '<C-w>j')
vim.keymap.set('', '<C-k>', '<C-w>k')
vim.keymap.set('', '<C-l>', '<C-w>l')

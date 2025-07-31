vim.cmd.colorscheme "catppuccin-mocha"

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

-- startify

vim.g.startify_change_to_vcs_root = 0

-- vimwiki

vim.g.vimwiki_list = {
  {
    path = "~/Documents/vimwiki/",
    syntax = "markdown",
    ext = ".md"
  }
}
vim.g.vimwiki_auto_header = 1

-- nvim-tree

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

-- nvim-treesitter

require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
})

-- lspconfig

require('lspconfig').sourcekit.setup {
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  },
  root_dir = require('lspconfig.util').root_pattern('Package.swift', '.git'),
}

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP Actions',
  callback = function(args)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, {noremap = true, silent = true})
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {noremap = true, silent = true})
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)

    -- Go to next diagnostic
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

    -- Show signature help (function args)
    vim.keymap.set('n', '<C-s>', vim.lsp.buf.signature_help, opts)
  end,
})

-- nvim-cmp and friends

local cmp = require('cmp')

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  }),
})

vim.keymap.set('', '<Leader>tt', '<cmd>NvimTreeToggle<CR>')
vim.keymap.set('', '<Leader>tr', '<cmd>NvimTreeRefresh<CR>')
vim.keymap.set('', '<Leader>tf', '<cmd>NvimTreeFocus<CR>')
vim.keymap.set('', '<C-b>', '<C-w>w')

vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true })

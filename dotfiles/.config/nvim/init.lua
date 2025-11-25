vim.cmd.colorscheme "catppuccin-mocha"
vim.opt.breakindent = true
vim.opt.compatible = false
vim.opt.expandtab = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.lazyredraw = true
vim.opt.list = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2
vim.opt.showcmd = true
vim.opt.showmatch = true
vim.opt.tabstop = 2
vim.opt.wrap = true
vim.o.wildmenu = true
vim.o.wildmode = "longest:full,full"

vim.opt.textwidth = 120
vim.opt.wrapmargin = 0
vim.opt.formatoptions:append("t")
vim.opt.linebreak = true

-- startify

vim.g.startify_change_to_vcs_root = 0

-- vimwiki

vim.g.vimwiki_list = {
  {
    path = "~/Documents/vimwiki/",
    syntax = "markdown",
    ext = ".md",
    auto_diary_index = 1,
    auto_generate_links = 1,
    generated_links_caption = 1,
    listsyms = ' x'
  }
}
vim.g.vimwiki_auto_header = 1
vim.g.vimwiki_links_header = "All Files"

vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*/diary/[0-9]*.md",
  callback = function()
    vim.schedule(function()
      vim.cmd("silent! %!vimwiki-diary-template '%' '%:h/template.md'")
      vim.cmd("normal! G")
    end)
  end,
})

-- gutentags
vim.g.gutentags_enabled = 1
vim.g.gutentags_ctags_executable = "ctags"
vim.g.gutentags_add_default_project_roots = 0
vim.g.gutentags_project_root = {
  ".git",
}

vim.g.gutentags_cache_dir = vim.fn.expand("~/.cache/gutentags")
vim.g.gutentags_verbose = 1

vim.g.gutentags_ctags_extra_args = {
  "--fields=+l",  -- include language info
  "--extras=+q",  -- include qualified tags
  "--kinds-all=*" -- include function prototypes, properties etc.
}

-- gitsigns

require("gitsigns").setup()

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


-- lsp for iOS development

require("lspconfig").sourcekit.setup {
  cmd = { "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp" }, -- Path to sourcekit-lsp
  filetypes = { "swift", "objective-c", "objective-cpp" },
  root_dir = require('lspconfig.util').root_pattern('Package.swift', '.git', '*.xcodeproj'),
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  on_attach = function(_, bufnr)
    local opts = { noremap = true, silent = true }
    opts.buffer = bufnr

    -- Show line diagnostics
    opts.desc = "Show line diagnostics"
    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

    -- Show documentation for symbol under cursor
    opts.desc = "Show documentation under cursor"
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)

    -- Go to next diagnostic
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

    -- Show signature help (function args)
    vim.keymap.set('n', '<C-s>', vim.lsp.buf.signature_help, opts)
  end,
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

vim.keymap.set('', '<Leader>w<Leader>l', '<cmd>VimwikiGenerateLinks<CR>')

vim.keymap.set('', '<M-j>', '<Plug>VimwikiDiaryPrevDay<CR>')
vim.keymap.set('', '<M-k>', '<Plug>VimwikiDiaryNextDay<CR>')
vim.keymap.set('n', '<C-M-o>', '<Tab>', { noremap = true})
vim.keymap.set('n', '<Leader>wl', ':VimwikiSplitLink<CR>')
vim.keymap.set('n', '<Leader>wv', ':VimwikiVSplitLink<CR>')

vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true })

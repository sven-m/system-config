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

vim.treesitter.language.register("markdown", "vimwiki")

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = false
vim.opt.viewoptions = "folds,cursor"

vim.api.nvim_create_autocmd("BufWinLeave", {
  pattern = { "*.md", "*.wiki" },
  callback = function() vim.cmd("silent! mkview") end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = { "*.md", "*.wiki" },
  callback = function() vim.cmd("silent! loadview") end,
})

-- startify

vim.g.startify_change_to_vcs_root = 0

vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*/diary/[0-9]*.md",
  callback = function()
    vim.schedule(function()
      vim.cmd("silent! %!vimwiki-diary-template '%'")
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

-- lsp for iOS development

vim.lsp.config('sourcekit', {
  cmd = { vim.fn.trim(vim.fn.system('xcrun --find sourcekit-lsp 2>/dev/null')) },
  filetypes = { "swift", "objc", "objcpp" },
  root_markers = { 'Package.swift', '.git' },
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

vim.lsp.enable('sourcekit')

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP Actions',
  callback = function(args)
    local opts = { noremap = true, silent = true, buffer = args.buf }

    -- Show line diagnostics
    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

    -- Show documentation for symbol under cursor
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
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

-- telescope

local telescope = require('telescope')
local builtin = require('telescope.builtin')

telescope.setup({
  pickers = {
    find_files = {
      find_command = { 'fd', '--type', 'f', '--hidden', '--follow', '--exclude', '.git' },
    },
    live_grep = {
      additional_args = { '--hidden' },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
    },
  },
})

telescope.load_extension('fzf')

vim.keymap.set('n', '<leader>ff', builtin.find_files)
vim.keymap.set('n', '<leader>fg', builtin.live_grep)
vim.keymap.set('n', '<leader>fb', builtin.buffers)
vim.keymap.set('n', '<leader>fh', builtin.help_tags)
vim.keymap.set('n', '<leader>fr', builtin.oldfiles)
vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols)
vim.keymap.set('n', '<leader>fS', builtin.lsp_dynamic_workspace_symbols)
vim.keymap.set('n', '<leader>fd', builtin.diagnostics)
vim.keymap.set('n', '<leader>fR', builtin.lsp_references)
vim.keymap.set('n', '<leader>fD', builtin.lsp_definitions)
vim.keymap.set('n', '<leader>fi', builtin.lsp_implementations)

vim.keymap.set('', '<Leader>tt', '<cmd>NvimTreeToggle<CR>')
vim.keymap.set('', '<Leader>tr', '<cmd>NvimTreeRefresh<CR>')
vim.keymap.set('', '<Leader>tf', '<cmd>NvimTreeFocus<CR>')

vim.keymap.set('', '<M-j>', '<Plug>VimwikiDiaryPrevDay<CR>')
vim.keymap.set('', '<M-k>', '<Plug>VimwikiDiaryNextDay<CR>')
vim.keymap.set('n', '<C-M-o>', '<Tab>', { noremap = true})
vim.keymap.set('n', '<Leader>wl', ':VimwikiSplitLink<CR>')
vim.keymap.set('n', '<Leader>wv', ':VimwikiVSplitLink<CR>')

vim.keymap.set("n", "<M-h>", "<cmd>tabp<CR>", { silent = true })
vim.keymap.set("n", "<M-l>", "<cmd>tabn<CR>", { silent = true })

vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true })

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
vim.opt.path:append("**")
vim.o.wildmenu = true
vim.o.wildmode = "longest:full,full"
vim.opt.wildoptions:append("fuzzy")

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
vim.g.gutentags_init_user_func = "IsVimwikiDir"

vim.cmd([[
function! IsVimwikiDir(path)
  return a:path =~ expand('~/Documents/vimwiki')
endfunction
]])

vim.g.gutentags_ctags_executable = "ctags"
vim.g.gutentags_add_default_project_roots = 0
vim.g.gutentags_project_root = {
  ".git",
  ".gutentags-root-marker",
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

-- xcodebuild

require("xcodebuild").setup({
  project_config = {
    store_in_project_dir = false,
  },
})

vim.keymap.set("n", "<leader>X", "<cmd>XcodebuildPicker<cr>", { desc = "Show Xcodebuild Actions" })
vim.keymap.set("n", "<leader>xf", "<cmd>XcodebuildProjectManager<cr>", { desc = "Show Project Manager Actions" })

vim.keymap.set("n", "<leader>xb", "<cmd>XcodebuildBuild<cr>", { desc = "Build Project" })
vim.keymap.set("n", "<leader>xB", "<cmd>XcodebuildBuildForTesting<cr>", { desc = "Build For Testing" })
vim.keymap.set("n", "<leader>xr", "<cmd>XcodebuildBuildRun<cr>", { desc = "Build & Run Project" })

vim.keymap.set("n", "<leader>xt", "<cmd>XcodebuildTest<cr>", { desc = "Run Tests" })
vim.keymap.set("v", "<leader>xt", "<cmd>XcodebuildTestSelected<cr>", { desc = "Run Selected Tests" })
vim.keymap.set("n", "<leader>xT", "<cmd>XcodebuildTestClass<cr>", { desc = "Run Current Test Class" })
vim.keymap.set("n", "<leader>x.", "<cmd>XcodebuildTestRepeat<cr>", { desc = "Repeat Last Test Run" })

vim.keymap.set("n", "<leader>xl", "<cmd>XcodebuildToggleLogs<cr>", { desc = "Toggle Xcodebuild Logs" })
vim.keymap.set("n", "<leader>xc", "<cmd>XcodebuildToggleCodeCoverage<cr>", { desc = "Toggle Code Coverage" })
vim.keymap.set("n", "<leader>xC", "<cmd>XcodebuildShowCodeCoverageReport<cr>", { desc = "Show Code Coverage Report" })
vim.keymap.set("n", "<leader>xe", "<cmd>XcodebuildTestExplorerToggle<cr>", { desc = "Toggle Test Explorer" })
vim.keymap.set("n", "<leader>xs", "<cmd>XcodebuildFailingSnapshots<cr>", { desc = "Show Failing Snapshots" })

vim.keymap.set("n", "<leader>xp", "<cmd>XcodebuildPreviewGenerateAndShow<cr>", { desc = "Generate Preview" })
vim.keymap.set("n", "<leader>x<cr>", "<cmd>XcodebuildPreviewToggle<cr>", { desc = "Toggle Preview" })

vim.keymap.set("n", "<leader>xd", "<cmd>XcodebuildSelectDevice<cr>", { desc = "Select Device" })
vim.keymap.set("n", "<leader>xm", "<cmd>XcodebuildSelectScheme<cr>", { desc = "Select Scheme" })
vim.keymap.set("n", "<leader>xp", "<cmd>XcodebuildSelectTestPlan<cr>", { desc = "Select Test Plan" })
vim.keymap.set("n", "<leader>xq", "<cmd>Telescope quickfix<cr>", { desc = "Show QuickFix List" })

vim.keymap.set("n", "<leader>xx", "<cmd>XcodebuildQuickfixLine<cr>", { desc = "Quickfix Line" })
vim.keymap.set("n", "<leader>xa", "<cmd>XcodebuildCodeActions<cr>", { desc = "Show Code Actions" })

-- lualine

local function xcodebuild_device()
  if vim.g.xcodebuild_platform == "macOS" then
    return " macOS"
  end

  local deviceIcon = ""
  if vim.g.xcodebuild_platform:match("watch") then
    deviceIcon = "􀟤"
  elseif vim.g.xcodebuild_platform:match("tv") then
    deviceIcon = "􀡴 "
  elseif vim.g.xcodebuild_platform:match("vision") then
    deviceIcon = "􁎖 "
  end

  if vim.g.xcodebuild_os then
    return deviceIcon .. " " .. vim.g.xcodebuild_device_name .. " (" .. vim.g.xcodebuild_os .. ")"
  end

  return deviceIcon .. " " .. vim.g.xcodebuild_device_name
end

require("lualine").setup({
  sections = {
    lualine_b = {'diff', 'diagnostics'},
    lualine_x = {
      { "' ' .. vim.g.xcodebuild_scheme .. ' ' .. vim.g.xcodebuild_last_status", color = { fg = "Gray" } },
      { "'󰙨 ' .. vim.g.xcodebuild_test_plan", color = { fg = "#a6e3a1", bg = "#161622" } },
      { xcodebuild_device, color = { fg = "#f9e2af", bg = "#161622" } },
    },
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
  defaults = {
    path_display = { "truncate", "filename_first" },
  },
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

vim.keymap.set("n", "z;", "zMzr", { silent = true })
vim.keymap.set("n", "<M-h>", "<cmd>tabp<CR>", { silent = true })
vim.keymap.set("n", "<M-l>", "<cmd>tabn<CR>", { silent = true })

vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true })

vim.keymap.set("n", "]q", "<cmd>cnext<CR>", { silent = true })
vim.keymap.set("n", "[q", "<cmd>cprev<CR>", { silent = true })

vim.cmd.colorscheme "catppuccin-mocha"
vim.opt.breakindent = true
vim.opt.compatible = false
vim.opt.expandtab = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.lazyredraw = true
vim.opt.updatetime = 1000
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

-- treesitter textobjects

require("nvim-treesitter-textobjects").setup({
  select = { lookahead = true },
  move = { set_jumps = true },
})

local ts_select = require("nvim-treesitter-textobjects.select")
local ts_move = require("nvim-treesitter-textobjects.move")

vim.keymap.set({ "x", "o" }, "af", function() ts_select.select_textobject("@function.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "if", function() ts_select.select_textobject("@function.inner", "textobjects") end)
vim.keymap.set({ "x", "o" }, "ac", function() ts_select.select_textobject("@class.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "ic", function() ts_select.select_textobject("@class.inner", "textobjects") end)
vim.keymap.set({ "x", "o" }, "aa", function() ts_select.select_textobject("@parameter.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "ia", function() ts_select.select_textobject("@parameter.inner", "textobjects") end)

vim.keymap.set("n", "<leader>a", function() require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner") end)
vim.keymap.set("n", "<leader>A", function() require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner") end)

vim.keymap.set({ "n", "x", "o" }, "]m", function() ts_move.goto_next_start("@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "]]", function() ts_move.goto_next_start("@class.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "]M", function() ts_move.goto_next_end("@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[m", function() ts_move.goto_previous_start("@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[[", function() ts_move.goto_previous_start("@class.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[M", function() ts_move.goto_previous_end("@function.outer", "textobjects") end)

-- remember fold state 

vim.api.nvim_create_autocmd("BufWinLeave", {
  pattern = { "*.md", "*.wiki" },
  callback = function() vim.cmd("silent! mkview") end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = { "*.md", "*.wiki" },
  callback = function() vim.cmd("silent! loadview") end,
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

vim.g.gutentags_ctags_extra_args = {
  "--fields=+l",  -- include language info
  "--extras=+q",  -- include qualified tags
  "--kinds-all=*" -- include function prototypes, properties etc.
}

-- gitsigns

require("gitsigns").setup({
  on_attach = function(bufnr)
    local gs = require("gitsigns")
    local opts = { buffer = bufnr }

    vim.keymap.set("n", "]c", function() gs.nav_hunk("next") end, opts)
    vim.keymap.set("n", "[c", function() gs.nav_hunk("prev") end, opts)

    vim.keymap.set("n", "<leader>gh", gs.preview_hunk_inline, opts)
    vim.keymap.set("n", "<leader>gb", gs.blame_line, opts)
  end,
})

-- pill tabline

vim.api.nvim_set_hl(0, "TabLine", { bg = "NONE", fg = "#666666" })
vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })

vim.api.nvim_set_hl(0, "TabLinePillActiveLeft", { fg = "#ca9ee6", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "TabLinePillActiveIndex", { fg = "#1e1e2e", bg = "#ca9ee6", bold = true })
vim.api.nvim_set_hl(0, "TabLinePillActiveName", { fg = "#cdd6f4", bg = "#45475a" })
vim.api.nvim_set_hl(0, "TabLinePillActiveRight", { fg = "#45475a", bg = "#1e1e2e" })

vim.api.nvim_set_hl(0, "TabLinePillInactiveLeft", { fg = "#9399b2", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "TabLinePillInactiveIndex", { fg = "#1e1e2e", bg = "#9399b2" })
vim.api.nvim_set_hl(0, "TabLinePillInactiveName", { fg = "#cdd6f4", bg = "#313244" })
vim.api.nvim_set_hl(0, "TabLinePillInactiveRight", { fg = "#313244", bg = "#1e1e2e" })

vim.o.tabline = "%!v:lua.PillTabline()"

function _G.PillTabline()
  local s = ""
  local tabs = vim.api.nvim_list_tabpages()
  local current = vim.api.nvim_get_current_tabpage()

  for i, tab in ipairs(tabs) do
    local is_active = (tab == current)

    local win = vim.api.nvim_tabpage_get_win(tab)
    local buf = vim.api.nvim_win_get_buf(win)
    local name = vim.api.nvim_buf_get_name(buf)
    name = name ~= "" and vim.fn.pathshorten(vim.fn.fnamemodify(name, ":~:.")) or "[No Name]"

    local hl_left = is_active and "%#TabLinePillActiveLeft#" or "%#TabLinePillInactiveLeft#"
    local hl_index = is_active and "%#TabLinePillActiveIndex#" or "%#TabLinePillInactiveIndex#"
    local hl_name = is_active and "%#TabLinePillActiveName#" or "%#TabLinePillInactiveName#"
    local hl_right = is_active and "%#TabLinePillActiveRight#" or "%#TabLinePillInactiveRight#"

    s = s .. "%" .. i .. "T"
    s = s .. hl_left .. "\u{e0b6}"
    s = s .. hl_index .. i .. " "
    s = s .. hl_name .. " " .. name
    s = s .. "%T"
    s = s .. hl_right .. "\u{e0b4}"
    s = s .. "%#TabLine# "
  end

  return s
end

-- nvim-tree

local function nvim_tree_on_attach(bufnr)
  local api = require("nvim-tree.api")
  api.config.mappings.default_on_attach(bufnr)

  local opts = { buffer = bufnr, noremap = true, silent = true, nowait = true }
  vim.keymap.set("n", "<CR>", api.node.open.replace_tree_buffer, opts)
  vim.keymap.set("n", "o", api.node.open.replace_tree_buffer, opts)
end

require("nvim-tree").setup({
  on_attach = nvim_tree_on_attach,
  hijack_unnamed_buffer_when_opening = true,
  hijack_directories = {
    enable = true,
    auto_open = true,
  },
  prefer_startup_root = true,
  root_dirs = { "~/src" },
  actions = {
    change_dir = {
      enable = false,
    },
  },
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

vim.keymap.set("n", "<leader>xx", "<cmd>XcodebuildQuickfixLine<cr>", { desc = "Quickfix Line" })
vim.keymap.set("n", "<leader>xa", "<cmd>XcodebuildCodeActions<cr>", { desc = "Show Code Actions" })

-- dap (debugging, via xcodebuild's lldb integration)

local dap = require("dap")
local dapui = require("dapui")
local xcodebuild_dap = require("xcodebuild.integrations.dap")

xcodebuild_dap.setup()
dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

vim.keymap.set("n", "<leader>dd", xcodebuild_dap.build_and_debug, { desc = "Build & Debug" })
vim.keymap.set("n", "<leader>dr", xcodebuild_dap.debug_without_build, { desc = "Debug Without Building" })
vim.keymap.set("n", "<leader>dt", xcodebuild_dap.debug_tests, { desc = "Debug Tests" })
vim.keymap.set("n", "<leader>dT", xcodebuild_dap.debug_class_tests, { desc = "Debug Class Tests" })
vim.keymap.set("n", "<leader>b", xcodebuild_dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>B", xcodebuild_dap.toggle_message_breakpoint, { desc = "Toggle Message Breakpoint" })
vim.keymap.set("n", "<leader>dx", xcodebuild_dap.terminate_session, { desc = "Terminate Debugger" })

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
      {
        function()
           if vim.b.suppress_autosave then
             return "\u{e654} auto-saving disabled, conflicting changes on disk"
           end
           return ""
        end,
        color = { fg = "#f38ba8" },
      },
      { xcodebuild_device, color = { fg = "#f9e2af", bg = "#161622" } },
    },
  },
})

-- lsp for iOS development

vim.lsp.config('sourcekit', {
  cmd = { vim.fn.trim(vim.fn.system('xcrun --find sourcekit-lsp 2>/dev/null')) },
  filetypes = { "swift", "objc", "objcpp" },
  root_markers = { 'Package.swift', '.git' },
})

vim.lsp.enable('sourcekit')

function _G.__lsp_format_operator()
  local start_mark = vim.api.nvim_buf_get_mark(0, '[')
  local end_mark = vim.api.nvim_buf_get_mark(0, ']')
  vim.lsp.buf.format({
    range = { start = start_mark, ['end'] = end_mark },
  })
end

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

    -- Format buffer (normal mode), selection (visual mode), or as an
    -- operator taking a motion/textobject (e.g. <leader>cfi()
    vim.keymap.set('v', '<leader>cf', vim.lsp.buf.format, opts)
    vim.keymap.set('n', '<leader>cf', function()
      vim.go.operatorfunc = 'v:lua.__lsp_format_operator'
      return 'g@'
    end, vim.tbl_extend('force', opts, { expr = true }))

    vim.lsp.completion.enable(true, args.data.client_id, args.buf, { autotrigger = true })
  end,
})

-- native completion and snippets

vim.opt.completeopt = { "menuone", "noselect", "popup" }

-- fzf-lua

local fzf_lua = require('fzf-lua')

fzf_lua.setup({
  fzf_opts = { ["--layout"] = "default" },
})

vim.keymap.set('n', '<leader>F', fzf_lua.builtin)
vim.keymap.set('n', '<leader>ff', fzf_lua.files)
vim.keymap.set('n', '<leader>fg', fzf_lua.live_grep)
vim.keymap.set('n', '<leader>fp', fzf_lua.grep_project)
vim.keymap.set('n', '<leader>fb', fzf_lua.buffers)
vim.keymap.set('n', '<leader>fh', fzf_lua.help_tags)
vim.keymap.set('n', '<leader>fR', fzf_lua.oldfiles)
vim.keymap.set('n', '<leader>fs', fzf_lua.lsp_document_symbols)
vim.keymap.set('n', '<leader>fe', fzf_lua.diagnostics_workspace)
vim.keymap.set('n', '<leader>fr', fzf_lua.lsp_references)
vim.keymap.set('n', '<leader>fd', fzf_lua.lsp_definitions)
vim.keymap.set('n', '<leader>fq', fzf_lua.quickfix)
vim.keymap.set({ 'n', 'v' }, '<leader>fa', fzf_lua.lsp_code_actions)

vim.keymap.set('', '<Leader>t', function()
  require('nvim-tree.api').tree.toggle({ current_window = true })
end)

-- vimwiki

vim.keymap.set('', '<M-j>', '<Plug>VimwikiDiaryPrevDay<CR>')
vim.keymap.set('', '<M-k>', '<Plug>VimwikiDiaryNextDay<CR>')
vim.keymap.set('n', '<C-M-o>', '<Tab>', { noremap = true})

vim.keymap.set("n", "z;", "zMzr", { silent = true })
vim.keymap.set("n", "<M-h>", "<cmd>tabp<CR>", { silent = true })
vim.keymap.set("n", "<M-l>", "<cmd>tabn<CR>", { silent = true })

vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true })

vim.keymap.set("n", "]q", "<cmd>cnext<CR>", { silent = true })
vim.keymap.set("n", "[q", "<cmd>cprev<CR>", { silent = true })

vim.keymap.set("n", "]l", "<cmd>lnext<CR>", { silent = true })
vim.keymap.set("n", "[l", "<cmd>lprevious<CR>", { silent = true })

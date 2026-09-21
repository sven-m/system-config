-- ui
vim.opt.updatetime = 1000
require("catppuccin").setup({
  integrations = {
    vimwiki = true,
    lualine = true,
    gitsigns = true,
    fzf = true,
    dap = true,
    dap_ui = true,
  },
})
vim.cmd.colorscheme "catppuccin-mocha"

local C = require("catppuccin.palettes").get_palette("mocha")

vim.opt.list = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showmode = false
vim.opt.splitright = true

-- indentation, formatting
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.textwidth = 120

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- rendering text
vim.opt.showmatch = true 
vim.opt.linebreak = true
vim.opt.breakindent = true

-- folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = false
vim.opt.viewoptions = "folds,cursor"

-- command line / :find completion
vim.opt.path:append("**")
vim.opt.path:append("*/.config/**")
vim.o.wildmode = "longest:full,full"
vim.opt.wildoptions:append("fuzzy")


-- insert mode completion
--
-- No completion plugin: 'autocomplete' (0.12) opens the popup as you type and
-- collects candidates from every source in 'complete', in order.
--
-- "o" runs 'omnifunc', which the LSP client points at vim.lsp.omnifunc when a
-- server attaches -- that is how sourcekit-lsp gets in. It is async: the
-- request goes out, the menu fills when the reply lands, and sources listed
-- first get the largest time slice. The caret limits keep the cheap
-- text-scraping sources from burying the LSP items; "u" (unloaded buffers) and
-- "t" (tags) are dropped because sourcekit already covers what they would find.
vim.o.autocomplete = true
vim.o.complete = "o,.^10,w^5,b^5"

-- The knob to turn first if the popup feels twitchy: raise it slightly above
-- your typing speed so it stops opening mid-word.
vim.o.autocompletedelay = 100

-- 'autocomplete' forces "noselect" and only honours fuzzy/longest/popup/
-- preinsert/preview. The rest of this applies to manual <C-x> completion, which
-- still works and suspends autocompletion while it runs.
--
-- "fuzzy" earns its place in Swift: UIVC matches UIViewController. It does mean
-- nvim re-ranks by fuzzy score and discards the server's sortText -- add
-- "nosort" to keep sourcekit's own ordering while still filtering fuzzily.
vim.opt.completeopt = { "menuone", "noselect", "popup", "fuzzy" }

-- Swift symbol names and their signature previews are both long.
vim.o.pumheight = 12
vim.o.pummaxwidth = 60

-- No completion keymaps: <C-n>/<C-p> walk the menu and <C-y> accepts, which is
-- what ins-completion has always done. Nothing is ever preselected, so typing
-- never inserts text on its own and <CR> stays a newline. Only on <C-y> does
-- the LSP side apply snippets, additional text edits (imports) and commands --
-- sourcekit returns calls as snippets, one tabstop per argument, and <Tab>
-- jumps between them via Neovim's own default snippet mapping.


-- fzf-lua

local fzf_lua = require('fzf-lua')

fzf_lua.setup({
  fzf_opts = { ["--layout"] = "default" },
})

vim.keymap.set('n', '<leader>f', fzf_lua.builtin)
vim.keymap.set('n', '<leader>ff', fzf_lua.files)
vim.keymap.set('n', '<leader>fg', fzf_lua.live_grep)
vim.keymap.set('n', '<leader>fp', fzf_lua.grep_project)
vim.keymap.set('n', '<leader>fb', fzf_lua.buffers)
vim.keymap.set('n', '<leader>fh', fzf_lua.help_tags)
vim.keymap.set('n', '<leader>fo', fzf_lua.oldfiles)
vim.keymap.set('n', '<leader>fs', fzf_lua.lsp_document_symbols)
vim.keymap.set('n', '<leader>fws', fzf_lua.lsp_workspace_symbols)
vim.keymap.set('n', '<leader>fe', fzf_lua.diagnostics_workspace)
vim.keymap.set('n', '<leader>fr', fzf_lua.lsp_references)
vim.keymap.set('n', '<leader>fd', fzf_lua.lsp_definitions)
vim.keymap.set('n', '<leader>fl', fzf_lua.lsp_finder)
vim.keymap.set('n', '<leader>fq', fzf_lua.quickfix)
vim.keymap.set({ 'n', 'v' }, '<leader>fa', fzf_lua.lsp_code_actions)


-- netrw (using vinegar)

-- Override vinegar's default, I like the banner
vim.g.netrw_banner = 1

-- workaround for netrw bug where copying a file and a dir together fails
vim.g.netrw_localcopycmdopt = "-R"

vim.keymap.set('n', '<leader>t', function()
  vim.cmd('Ntree ' .. vim.fn.getcwd())
end)

vim.api.nvim_set_hl(0, "netrwMarkFile", { fg = C.base, bg = C.peach, bold = true })

-- gitsigns

require("gitsigns").setup({
  base = "HEAD",
  on_attach = function(bufnr)
    local gs = require("gitsigns")
    local opts = { buffer = bufnr }

    vim.keymap.set("n", "]c", function() gs.nav_hunk("next") end, opts)
    vim.keymap.set("n", "[c", function() gs.nav_hunk("prev") end, opts)

    vim.keymap.set("n", "<leader>gh", gs.preview_hunk_inline, opts)
    vim.keymap.set("n", "<leader>gb", gs.blame_line, opts)
  end,
})


-- treesitter
vim.treesitter.language.register("markdown", "vimwiki")

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


-- pill tabline

vim.api.nvim_set_hl(0, "TabLine", { bg = "NONE", fg = C.overlay0 })
vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })

vim.api.nvim_set_hl(0, "TabLinePillActiveLeft", { fg = C.mauve, bg = C.base })
vim.api.nvim_set_hl(0, "TabLinePillActiveIndex", { fg = C.base, bg = C.mauve, bold = true })
vim.api.nvim_set_hl(0, "TabLinePillActiveName", { fg = C.text, bg = C.surface1 })
vim.api.nvim_set_hl(0, "TabLinePillActiveRight", { fg = C.surface1, bg = C.base })

vim.api.nvim_set_hl(0, "TabLinePillInactiveLeft", { fg = C.overlay2, bg = C.base })
vim.api.nvim_set_hl(0, "TabLinePillInactiveIndex", { fg = C.base, bg = C.overlay2 })
vim.api.nvim_set_hl(0, "TabLinePillInactiveName", { fg = C.text, bg = C.surface0 })
vim.api.nvim_set_hl(0, "TabLinePillInactiveRight", { fg = C.surface0, bg = C.base })

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


-- xcodebuild

require("xcodebuild").setup({
  project_config = {
    store_in_project_dir = false,
  },
  logs = {
    open_command = "silent edit {path}",
    auto_open_on_failed_build = false,
  },
  quickfix = {
    show_warnings_on_quickfixlist = false,
  },
})

vim.keymap.set("n", "<leader>x", "<cmd>XcodebuildPicker<cr>", { desc = "Show Xcodebuild Actions" })


-- dap (debugging, via xcodebuild's lldb integration)

local dap = require("dap")
local dapui = require("dapui")
local xcodebuild_dap = require("xcodebuild.integrations.dap")

xcodebuild_dap.setup()

-- Docked: `scopes` (plus `stacks`, since the interesting Swift frame is rarely
-- the top one) in a sidebar, and one of two output panels along the bottom.
--
-- The output panels are fed by unrelated paths and can't be merged: xcodebuild
-- writes the app's own stdout straight into the `console` buffer, while lldb's
-- logpoint messages arrive as DAP output events, which nvim-dap appends to the
-- `repl`. Both are declared as bottom layouts and only one is opened at a time,
-- so each gets full width -- see show_bottom() below.
local LAYOUT_SIDEBAR, LAYOUT_CONSOLE, LAYOUT_REPL = 1, 2, 3

dapui.setup({
  layouts = {
    [LAYOUT_SIDEBAR] = {
      elements = {
        { id = "scopes", size = 0.65 },
        { id = "stacks", size = 0.35 },
      },
      size = 50,
      position = "left",
    },
    [LAYOUT_CONSOLE] = {
      elements = { "console" },
      size = 15,
      position = "bottom",
    },
    [LAYOUT_REPL] = {
      elements = { "repl" },
      size = 15,
      position = "bottom",
    },
  },
  controls = { element = "console" },
})

-- Closing the other panel first is load-bearing: dapui.open({layout = n})
-- reopens every lower-indexed layout afterwards to preserve geometry, so a
-- console left open would come straight back and stack under the repl.
local function show_bottom(i)
  dapui.close({ layout = i == LAYOUT_CONSOLE and LAYOUT_REPL or LAYOUT_CONSOLE })
  dapui.open({ layout = i })
end

require("nvim-dap-virtual-text").setup({
  -- inline values get long in Swift; keep them out of the code itself
  virt_text_pos = "eol",
  clear_on_continue = true,
})

-- Colors come from catppuccin's `dap` integration, which defines the highlight
-- groups but deliberately leaves the glyphs to us.
vim.fn.sign_define("DapBreakpoint", { text = "\u{25cf}", texthl = "DapBreakpoint" })
vim.fn.sign_define("DapBreakpointCondition", { text = "\u{25c6}", texthl = "DapBreakpointCondition" })
vim.fn.sign_define("DapLogPoint", { text = "\u{25c7}", texthl = "DapLogPoint" })
vim.fn.sign_define("DapBreakpointRejected", { text = "\u{25cb}", texthl = "DapBreakpointRejected" })
vim.fn.sign_define("DapStopped", { text = "\u{25b6}", texthl = "DapStopped", linehl = "DapStoppedLine" })
vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#313244" })

-- Opened on session start, but never auto-closed: the console holds the app's
-- logs and crash symbolication, which you mostly want to read *after* it exits.
-- xcodebuild_dap.terminate_session closes it when you explicitly ask.
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open({ layout = LAYOUT_SIDEBAR })
  show_bottom(LAYOUT_CONSOLE)
end

vim.keymap.set("n", "<leader>dd", xcodebuild_dap.build_and_debug, { desc = "Build & Debug" })
vim.keymap.set("n", "<leader>dr", xcodebuild_dap.debug_without_build, { desc = "Debug Without Building" })
vim.keymap.set("n", "<leader>da", xcodebuild_dap.attach_and_debug, { desc = "Attach Debugger" })
vim.keymap.set("n", "<leader>dx", xcodebuild_dap.terminate_session, { desc = "Terminate Debugger" })

-- Breakpoints go through xcodebuild so they persist to breakpoints.json and are
-- restored on BufReadPost for *.swift.
vim.keymap.set("n", "<leader>b", xcodebuild_dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>B", xcodebuild_dap.toggle_message_breakpoint, { desc = "Toggle Message Breakpoint" })
vim.keymap.set("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
  xcodebuild_dap.save_breakpoints()
end, { desc = "Set Conditional Breakpoint" })

-- dap-ui: docked layouts, on-demand floats, and evaluation
vim.keymap.set("n", "<leader>du", function()
  dapui.toggle({ layout = LAYOUT_SIDEBAR })
end, { desc = "Toggle Scopes & Stacks" })
vim.keymap.set("n", "<leader>dc", function()
  show_bottom(LAYOUT_CONSOLE)
end, { desc = "Show App Console" })
vim.keymap.set("n", "<leader>dp", function()
  show_bottom(LAYOUT_REPL)
end, { desc = "Show REPL" })

vim.keymap.set({ "n", "v" }, "<leader>de", dapui.eval, { desc = "Evaluate Expression" })
vim.keymap.set("n", "<leader>dw", function()
  dapui.float_element("watches", { enter = true })
end, { desc = "Float Watches" })
vim.keymap.set("n", "<leader>dl", function()
  dapui.float_element("breakpoints", { enter = true })
end, { desc = "Float Breakpoint List" })
vim.keymap.set("n", "<leader>dC", function()
  xcodebuild_dap.clear_console(true)
end, { desc = "Clear App Console" })

-- F5 follows VS Code: start a session when there is none, continue when paused.
-- Without the guard, dap.continue() would fall through to the attach-only Swift
-- configuration and poll ps for 10s before failing.
vim.keymap.set("n", "<F5>", function()
  if dap.session() then
    dap.continue()
  else
    xcodebuild_dap.build_and_debug()
  end
end, { desc = "Debugger: Start / Continue" })
vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debugger: Step Over" })
vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debugger: Step Into" })
vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debugger: Step Out" })


-- lsp for iOS development

vim.lsp.config('sourcekit', {
  cmd = { vim.fn.trim(vim.fn.system('xcrun --find sourcekit-lsp 2>/dev/null')) },
  filetypes = { "swift", "objc", "objcpp" },
  root_markers = { '.git' }, -- '*.xcworkspace', '*.xcodeproj', 'Package.swift', 
})

vim.lsp.enable('sourcekit')

-- No keymaps here: 0.12 provides them all. K hover, i_CTRL-S signature help,
-- gra/gri/grn/grr/grt/grx/gO, <C-w>d for the diagnostic float, gq{motion} for
-- range formatting via the 'formatexpr' the client sets, and g CTRL-] for
-- go-to-definition -- the client sets 'tagfunc', so a normal-mode tag command
-- runs textDocument/definition rather than reading a tags file, and the g
-- prefix turns the silent jump-to-first into a picker when a symbol has
-- several definitions. ]t and [t walk the match list afterwards.
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Enable LSP completion',
  callback = function(args)
    -- Not `autotrigger = true`: that only fires on the server's own
    -- triggerCharacters, which for sourcekit are just "." and "(", and
    -- 'autocomplete' already opens the popup on every keystroke. enable() is
    -- still required -- it is what makes <C-y> apply snippets and additional
    -- text edits, and what resolves the docs shown by "popup".
    vim.lsp.completion.enable(true, args.data.client_id, args.buf)
  end,
})


-- lualine

-- lualine renders each window's statusline inside nvim_win_call, so the
-- current buffer here is the one that window shows.
local bufnr_component = {
  function()
    return vim.api.nvim_get_current_buf()
  end,
  color = { fg = "Gray" },
  padding = { left = 1, right = 0 },
}

require("lualine").setup({
  options = {
    globalstatus = false,
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' }
  },
  inactive_sections = {
    lualine_c = { bufnr_component, 'filename' },
  },
  sections = {
    lualine_b = {'diagnostics'},
    lualine_c = { bufnr_component, 'filename' },
    lualine_x = {
      {
        function()
          if vim.b.suppress_autosave then
            return "\u{e654} auto-saving disabled, conflicting changes on disk"
          end
          return ""
        end,
        color = { fg = "#f38ba8" },
      },
      {
        function()
          return vim.g.xcodebuild_scheme and (' ' .. vim.g.xcodebuild_scheme) or ''
        end,
        color = { fg = "Gray" },
        separator = '',
      },
      {
        function()
          return vim.g.xcodebuild_test_plan and ('󰙨 ' .. vim.g.xcodebuild_test_plan) or ''
        end,
        color = { fg = "#a6e3a1" },
        separator = '',
      },
      {
        function()
          return vim.g.xcodebuild_device_name and (vim.g.xcodebuild_device_name .. " (" .. vim.g.xcodebuild_os .. ")") or ''
        end,
        color = { fg = "#f9e2af" }
      },
      {
        'lsp_status',
        color = { fg = "Gray" },
      },
      {
        'filetype',
        color = { fg = "Gray" },
      },
    },
  },
})

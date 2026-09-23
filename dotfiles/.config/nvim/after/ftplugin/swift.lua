vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

-- Breakpoints go through xcodebuild so they persist to breakpoints.json and are
-- restored on BufReadPost for *.swift. Buffer-local because a breakpoint only
-- means anything in a source buffer; the stepping keys stay global, in
-- plugin/xcodebuild.lua.
--
-- Deferred through sven.xcode, so a Swift buffer opened before the project was
-- configured still gets these the moment the wizard finishes. The buffer number
-- is captured rather than using `buffer = true`, since by then the current
-- buffer may be a different one.
do
  local buf = vim.api.nvim_get_current_buf()

  require("sven.xcode").on_xcode_project_configured(function()
    if not vim.api.nvim_buf_is_valid(buf) then
      return
    end

    local dap = require("dap")
    local xcodebuild_dap = require("xcodebuild.integrations.dap")

    vim.keymap.set("n", "<leader>b", xcodebuild_dap.toggle_breakpoint,
      { buffer = buf, desc = "Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>B", xcodebuild_dap.toggle_message_breakpoint,
      { buffer = buf, desc = "Toggle Message Breakpoint" })
    vim.keymap.set("n", "<leader>dB", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      xcodebuild_dap.save_breakpoints()
    end, { buffer = buf, desc = "Set Conditional Breakpoint" })
  end)
end

-- Neovim's bundled ftplugin/swift.vim already set this, so append rather than
-- assign or its own reverts are lost. Only the option is listed: the mappings
-- above are buffer-local and nothing in this config ever retypes a Swift
-- buffer.
vim.b.undo_ftplugin = vim.b.undo_ftplugin
  and (vim.b.undo_ftplugin .. " | setlocal indentexpr<")
  or "setlocal indentexpr<"

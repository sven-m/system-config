vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

-- Breakpoints go through xcodebuild so they persist to breakpoints.json and are
-- restored on BufReadPost for *.swift. Buffer-local because a breakpoint only
-- means anything in a source buffer; the stepping keys stay global, in
-- plugin/xcodebuild.lua.
--
-- Guarded by the same flag that file sets once this directory has a configured
-- project. A buffer opened before the wizard ran needs a reload to pick these
-- up, since the ftplugin has already run for it.
if vim.g.sven_xcodebuild_keys then
  local dap = require("dap")
  local xcodebuild_dap = require("xcodebuild.integrations.dap")

  vim.keymap.set("n", "<leader>b", xcodebuild_dap.toggle_breakpoint,
    { buffer = true, desc = "Toggle Breakpoint" })
  vim.keymap.set("n", "<leader>B", xcodebuild_dap.toggle_message_breakpoint,
    { buffer = true, desc = "Toggle Message Breakpoint" })
  vim.keymap.set("n", "<leader>dB", function()
    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    xcodebuild_dap.save_breakpoints()
  end, { buffer = true, desc = "Set Conditional Breakpoint" })
end

-- Neovim's bundled ftplugin/swift.vim already set this, so append rather than
-- assign or its own reverts are lost. Only the option is listed: the mappings
-- above are buffer-local and nothing in this config ever retypes a Swift
-- buffer.
vim.b.undo_ftplugin = vim.b.undo_ftplugin
  and (vim.b.undo_ftplugin .. " | setlocal indentexpr<")
  or "setlocal indentexpr<"

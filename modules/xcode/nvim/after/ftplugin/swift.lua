vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

-- Editing breakpoints is currently only used in Swift files
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

-- Neovim's bundled ftplugin/swift.vim already set this, so append rather than
-- assign or its own reverts are lost. Only the option is listed: the mappings
-- above are buffer-local and nothing in this config ever retypes a Swift
-- buffer.
vim.b.undo_ftplugin = vim.b.undo_ftplugin
  and (vim.b.undo_ftplugin .. " | setlocal indentexpr<")
  or "setlocal indentexpr<"

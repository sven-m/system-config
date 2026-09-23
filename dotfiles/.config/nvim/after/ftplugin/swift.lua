vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

-- Breakpoints go through xcodebuild so they persist to breakpoints.json and are
-- restored on BufReadPost for *.swift. These three are buffer-local because a
-- breakpoint only means anything in a source buffer.
local dap = require("dap")
local dapui = require("dapui")
local xcodebuild_dap = require("xcodebuild.integrations.dap")

vim.keymap.set("n", "<leader>b", xcodebuild_dap.toggle_breakpoint,
  { buffer = true, desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>B", xcodebuild_dap.toggle_message_breakpoint,
  { buffer = true, desc = "Toggle Message Breakpoint" })
vim.keymap.set("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
  xcodebuild_dap.save_breakpoints()
end, { buffer = true, desc = "Set Conditional Breakpoint" })

-- The rest are deliberately global rather than buffer-local, even though they
-- are defined from a filetype plugin. Mid-session the cursor is often in a
-- dap-ui window or the app console, where a buffer-local mapping would not
-- fire. Opening a Swift file is the trigger, not the scope.
--
-- Re-running this for each Swift buffer is harmless: keymaps overwrite, and
-- nvim_create_user_command defaults to force = true.

vim.keymap.set("n", "<leader>x", "<cmd>XcodebuildPicker<cr>", { desc = "Show Xcodebuild Actions" })

vim.keymap.set("n", "<F5>", function()
  if dap.session() then
    dap.continue()
  end
end, { desc = "Debugger: Continue" })
vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debugger: Step Over" })
vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debugger: Step Into" })
vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debugger: Step Out" })

vim.api.nvim_create_user_command("DebugSessionKill", function()
  xcodebuild_dap.terminate_session()
end, { nargs = 0, desc = "Terminate Debugger" })

vim.api.nvim_create_user_command("DebugSessionToggle", function()
  dapui.toggle()
end, { nargs = 0, desc = "Toggle Debugger UI" })

vim.api.nvim_create_user_command("DebugSessionClearConsole", function()
  xcodebuild_dap.clear_console(true)
end, { nargs = 0, desc = "Clear App Console" })

-- Neovim's bundled ftplugin/swift.vim already set this, so append rather than
-- assign or its own reverts are lost.
--
-- Only the option is listed. The breakpoint mappings are buffer-local and
-- nothing in this config ever retypes a Swift buffer, and the global mappings
-- and commands above outlive the buffer on purpose -- that is the point of
-- defining them here rather than scoping them.
vim.b.undo_ftplugin = vim.b.undo_ftplugin
  and (vim.b.undo_ftplugin .. " | setlocal indentexpr<")
  or "setlocal indentexpr<"

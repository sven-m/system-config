-- xcodebuild, and the dap setup that runs on top of it.
--
-- These stay in one file because order matters: xcodebuild.setup() must run
-- before xcodebuild.integrations.dap.setup(). Split across two files in
-- plugin/ they would be sourced alphabetically, i.e. backwards.
--
-- The DapStoppedLine highlight is defined in plugin/colorscheme.lua.

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

dapui.setup()

require("nvim-dap-virtual-text").setup({
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

-- Opened on session start, but never auto-closed: the console holds the app's
-- logs and crash symbolication, which you mostly want to read *after* it exits.
-- xcodebuild_dap.terminate_session closes it when you explicitly ask.
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end

vim.api.nvim_create_user_command("DebugSessionKill", function()
  xcodebuild_dap.terminate_session()
end, { nargs = 0, desc = "Terminate Debugger" })

vim.api.nvim_create_user_command("DebugSessionToggle", function()
  dapui.toggle()
end, { nargs = 0, desc = "Toggle Debugger UI" })

vim.api.nvim_create_user_command("DebugSessionClearConsole", function()
  xcodebuild_dap.clear_console(true)
end, { nargs = 0, desc = "Clear App Console" })

-- The breakpoint mappings are buffer-local, in after/ftplugin/swift.lua: they
-- only mean anything in a source buffer. The stepping keys below stay global
-- on purpose -- during a session the cursor is often in a dap-ui window or the
-- console, where a buffer-local mapping would not fire.

vim.keymap.set("n", "<F5>", function()
  if dap.session() then
    dap.continue()
  end
end, { desc = "Debugger: Continue" })
vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debugger: Step Over" })
vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debugger: Step Into" })
vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debugger: Step Out" })

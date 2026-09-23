-- xcodebuild, and the dap setup that runs on top of it.
--
-- These stay in one file because order matters: xcodebuild.setup() must run
-- before xcodebuild.integrations.dap.setup(). Split across two files in
-- plugin/ they would be sourced alphabetically, i.e. backwards.
--
-- The DapStoppedLine highlight is defined in plugin/colorscheme.lua.
--
-- Setup only, and unconditional. It is cheap -- 36 files and no shell-out --
-- and the dap integration registers a BufReadPost *.swift hook to restore
-- breakpoints, which has to exist before the first Swift buffer is read, so
-- deferring any of this to a filetype would be too late.
--
-- The commands and mappings built on top live in after/ftplugin/swift.lua:
-- opening a Swift file is a good enough proxy for wanting them.

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

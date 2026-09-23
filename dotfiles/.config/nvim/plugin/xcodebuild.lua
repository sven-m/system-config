-- Setup xcodebuild.nvim at launch, configure keybinds and commands when
-- configured xcode project detected

-- ===========================================================================
-- TEMPORARY STARTUP PROFILING -- REVERT BEFORE MERGE
--
-- --startuptime attributes 81-124 ms of self time to this file and :profile
-- cannot see inside a Lua chunk, so each step is timed explicitly here.
-- Run `nvim` in a configured project, then `:messages`.
-- ===========================================================================

local prof = {}

local function t(label, fn)
  local t0 = vim.uv.hrtime()
  local r = fn()
  prof[#prof + 1] = { label, (vim.uv.hrtime() - t0) / 1e6 }
  return r
end

local file_t0 = vim.uv.hrtime()

local xcodebuild = t("require xcodebuild", function()
  return require("xcodebuild")
end)

t("xcodebuild.setup", function()
  xcodebuild.setup({
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
end)

local dap = t("require dap", function() return require("dap") end)
local dapui = t("require dapui", function() return require("dapui") end)
local xcodebuild_dap = t("require xcodebuild dap", function()
  return require("xcodebuild.integrations.dap")
end)

t("xcodebuild_dap.setup", function() xcodebuild_dap.setup() end)

t("dapui.setup", function() dapui.setup() end)

local virtual_text = t("require virtual_text", function()
  return require("nvim-dap-virtual-text")
end)

t("virtual_text.setup", function()
  virtual_text.setup({
    virt_text_pos = "eol",
    clear_on_continue = true,
  })
end)

t("sign_define x5", function()
  vim.fn.sign_define("DapBreakpoint", { text = "\u{25cf}", texthl = "DapBreakpoint" })
  vim.fn.sign_define("DapBreakpointCondition", { text = "\u{25c6}", texthl = "DapBreakpointCondition" })
  vim.fn.sign_define("DapLogPoint", { text = "\u{25c7}", texthl = "DapLogPoint" })
  vim.fn.sign_define("DapBreakpointRejected", { text = "\u{25cb}", texthl = "DapBreakpointRejected" })
  vim.fn.sign_define("DapStopped", { text = "\u{25b6}", texthl = "DapStopped", linehl = "DapStoppedLine" })
end)

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end

local function configure()
  vim.api.nvim_create_user_command("DebugSessionKill", function()
    xcodebuild_dap.terminate_session()
  end, { nargs = 0, desc = "Terminate Debugger" })

  vim.api.nvim_create_user_command("DebugSessionToggle", function()
    dapui.toggle()
  end, { nargs = 0, desc = "Toggle Debugger UI" })

  vim.api.nvim_create_user_command("DebugSessionClearConsole", function()
    xcodebuild_dap.clear_console(true)
  end, { nargs = 0, desc = "Clear App Console" })

  vim.keymap.set("n", "<leader>x", "<cmd>XcodebuildPicker<cr>", { desc = "Show Xcodebuild Actions" })

  vim.keymap.set("n", "<F5>", function()
    if dap.session() then
      dap.continue()
    end
  end, { desc = "Debugger: Continue" })
  vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debugger: Step Over" })
  vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debugger: Step Into" })
  vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debugger: Step Out" })
end

local projectConfig = t("require project.config", function()
  return require("xcodebuild.project.config")
end)

local configured = t("is_configured", function()
  return projectConfig.is_configured()
end)

if configured then
  t("configure (63 cmds + keys)", function() configure() end)
else
  vim.api.nvim_create_autocmd("User", {
    pattern = "XcodebuildProjectSettingsUpdated",
    desc = "Set up xcodebuild commands and mappings once the project is configured",
    callback = function()
      if not projectConfig.is_configured() then
        return
      end
      configure()
      return true
    end,
  })
end

prof[#prof + 1] = { "TOTAL (this file)", (vim.uv.hrtime() - file_t0) / 1e6 }

vim.schedule(function()
  local out = { "", "=== plugin/xcodebuild.lua startup profile ===" }
  for _, row in ipairs(prof) do
    out[#out + 1] = ("  %-28s %8.2f ms"):format(row[1], row[2])
  end
  out[#out + 1] = ("  configured project: %s"):format(tostring(configured))
  print(table.concat(out, "\n"))
end)

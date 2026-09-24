-- Setup xcodebuild.nvim at launch, configure keybinds and commands when
-- configured xcode project detected
--
-- Preset command template for .nvim.lua
--
-- vim.api.nvim_create_user_command("XcodePresetMyApp", "ApplyXcodePreset MyApp MyAppUnitTests iPhone 16", {})

if not vim.g.should_initialise_xcodebuild then
  return
end

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

local projectConfig = require("xcodebuild.project.config")

-- Find a device by name, optionally suffixed with " (<os>)", e.g. "iPhone 16 (18.0)"
local function find_device(devices, query)
  local name, os = query:match("^(.-) %((.+)%)$")
  name = name or query
  for _, device in ipairs(devices or {}) do
    if device.name == name and (not os or device.os == os) then
      return device
    end
  end
end

-- :ApplyXcodePreset <scheme> <testplan|-> <device name> [(<os>)]
vim.api.nvim_create_user_command("ApplyXcodePreset", function(opts)
  if #opts.fargs < 3 then
    vim.notify("Usage: ApplyXcodePreset <scheme> <testplan|-> <device name> [(<os>)]", vim.log.levels.ERROR)
    return
  end
  local scheme, testPlan = opts.fargs[1], opts.fargs[2]
  local deviceQuery = table.concat(opts.fargs, " ", 3)
  local settings = projectConfig.settings

  local function apply(device)
    if not device then
      vim.notify("ApplyXcodePreset: device not found: " .. deviceQuery, vim.log.levels.ERROR)
      return
    end
    settings.scheme = scheme
    settings.testPlan = testPlan ~= "-" and testPlan or nil
    projectConfig.set_destination(device) -- also saves settings
    projectConfig.update_settings({}, function()
      vim.notify(string.format("Xcode preset: %s / %s / %s", scheme, testPlan, device.name))
    end)
  end

  local device = find_device(projectConfig.device_cache and projectConfig.device_cache.devices, deviceQuery)
  if device then
    apply(device)
    return
  end

  -- not in the device cache yet: ask xcodebuild for the scheme's destinations
  local projectFile = settings.projectFile or settings.swiftPackage
  if not projectFile then
    vim.notify("ApplyXcodePreset: no project configured, run :XcodebuildSetup first", vim.log.levels.ERROR)
    return
  end
  require("xcodebuild.core.xcode").get_destinations(projectFile, scheme, settings.workingDirectory, function(destinations)
    apply(find_device(destinations, deviceQuery))
  end)
end, { nargs = "+", desc = "Set Xcode scheme, test plan and device" })

local dap = require("dap")
local dapui = require("dapui")
local xcodebuild_dap = require("xcodebuild.integrations.dap")

xcodebuild_dap.setup()

dapui.setup()

require("nvim-dap-virtual-text").setup({
  virt_text_pos = "eol",
  clear_on_continue = true,
})

vim.fn.sign_define("DapBreakpoint", { text = "\u{25cf}", texthl = "DapBreakpoint" })
vim.fn.sign_define("DapBreakpointCondition", { text = "\u{25c6}", texthl = "DapBreakpointCondition" })
vim.fn.sign_define("DapLogPoint", { text = "\u{25c7}", texthl = "DapLogPoint" })
vim.fn.sign_define("DapBreakpointRejected", { text = "\u{25cb}", texthl = "DapBreakpointRejected" })
vim.fn.sign_define("DapStopped", { text = "\u{25b6}", texthl = "DapStopped", linehl = "DapStoppedLine" })

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

if projectConfig.is_configured() then
  configure()
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

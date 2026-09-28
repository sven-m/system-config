-- Switch xcodebuild.nvim to a fixed scheme/test plan/device in one go.
--
-- Template for a project's .nvim.lua:
--
-- vim.api.nvim_create_user_command("XcodePresetMyApp", function()
--   require("xcode_preset").apply({
--     scheme = "MyApp",
--     testPlan = "MyAppUnitTests", -- nil for no test plan
--     deviceUdid = "28B52DAA-BC2F-410B-A5BE-F485A3AFB0BC",
--     osVersion = "18.0",
--     deviceName = "iPhone 16",
--   })
-- end, {})

local M = {}

---@class XcodePreset
---@field scheme string
---@field testPlan string|nil
---@field deviceUdid string
---@field osVersion string
---@field deviceName string
---@field platform string|nil defaults to the current platform, else "iOS Simulator"

---@param preset XcodePreset
function M.apply(preset)
  local projectConfig = require("xcodebuild.project.config")
  local settings = projectConfig.settings
  settings.scheme = preset.scheme
  settings.testPlan = preset.testPlan
  projectConfig.set_destination({
    id = preset.deviceUdid,
    os = preset.osVersion,
    name = preset.deviceName,
    platform = preset.platform or settings.platform or "iOS Simulator",
  }) -- also saves settings
  projectConfig.update_settings({}, function()
    vim.notify(string.format(
      "Xcode preset: %s / %s / %s (%s)",
      preset.scheme,
      preset.testPlan or "-",
      preset.deviceName,
      preset.osVersion
    ))
  end)
end

return M

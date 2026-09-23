-- Deferral helper for anything that only makes sense once xcodebuild has a
-- configured project for the current directory.
--
-- Namespaced under sven/ deliberately: lua module resolution is first-wins
-- across the runtimepath and ~/.config/nvim comes first, so a top-level
-- lua/xcode.lua could shadow a plugin's own module of that name.

local M = {}

local function is_configured()
  return require("xcodebuild.project.config").is_configured()
end

---Runs `fn` once this directory has a configured xcodebuild project: straight
---away if it already does, otherwise as soon as the setup wizard finishes.
---
---`fn` runs at most once per call. Assumes xcodebuild.setup() has already run,
---which is what reads the settings file and what emits the event below.
---@param fn fun()
function M.on_xcode_project_configured(fn)
  if is_configured() then
    fn()
    return
  end

  -- XcodebuildProjectSettingsUpdated also fires on scheme, device and test plan
  -- changes, and can fire while the project is still incomplete -- selecting a
  -- test plan for a Swift package emits it having only cleared the plan. Hence
  -- the re-check rather than `once = true`. Returning true deletes the
  -- autocommand, so `fn` runs exactly once.
  vim.api.nvim_create_autocmd("User", {
    pattern = "XcodebuildProjectSettingsUpdated",
    desc = "Run deferred xcodebuild setup once the project is configured",
    callback = function()
      if not is_configured() then
        return
      end
      fn()
      return true
    end,
  })
end

return M

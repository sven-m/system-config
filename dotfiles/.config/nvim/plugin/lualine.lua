-- produces a function that produces the foreground colour of that highlight
-- group, dynamically (so it follows colorscheme changes)
local function fg(group)
  return function()
    local colour = vim.api.nvim_get_hl(0, { name = group, link = false }).fg
    return { fg = colour and string.format("#%06x", colour) }
  end
end

local bufnr_component = {
  function()
    return vim.api.nvim_get_current_buf()
  end,
  color = fg("SvenMuted"),
  padding = { left = 1, right = 0 },
}

require("lualine").setup({
  options = {
    theme = "adwaita-mocha", -- lua/lualine/themes/adwaita-mocha.lua
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' }
  },
  inactive_sections = {
    lualine_c = { bufnr_component, 'filename' },
  },
  sections = {
    lualine_b = {'diagnostics'},
    lualine_c = { bufnr_component, 'filename' },
    lualine_x = {
      {
        function()
          if vim.b.suppress_autosave then
            return "\u{e654} auto-saving disabled, conflicting changes on disk"
          end
          return ""
        end,
        color = fg("DiagnosticError"),
      },
      {
        function()
          return vim.g.xcodebuild_scheme and (' ' .. vim.g.xcodebuild_scheme) or ''
        end,
        color = fg("SvenMuted"),
        separator = '',
      },
      {
        function()
          return vim.g.xcodebuild_test_plan and ('󰙨 ' .. vim.g.xcodebuild_test_plan) or ''
        end,
        color = fg("SvenMuted"),
        separator = '',
      },
      {
        function()
          return vim.g.xcodebuild_device_name and ("\u{eadb} " .. vim.g.xcodebuild_device_name .. " (" .. vim.g.xcodebuild_os .. ")") or ''
        end,
        color = fg("SvenMuted")
      },
      {
        'lsp_status',
        color = fg("SvenMuted"),
      },
      {
        'filetype',
        color = fg("SvenMuted"),
      },
    },
  },
})

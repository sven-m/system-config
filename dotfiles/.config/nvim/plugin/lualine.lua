-- produces a function that produces the catppuccin color of that name,
-- dynamically
local function fg(colour)
  return function()
    return { fg = require("catppuccin.palettes").get_palette()[colour] }
  end
end

local bufnr_component = {
  function()
    return vim.api.nvim_get_current_buf()
  end,
  color = fg("overlay1"),
  padding = { left = 1, right = 0 },
}

require("lualine").setup({
  options = {
    theme = "generated", -- lua/lualine/themes/generated.lua
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
        color = fg("red"),
      },
      {
        function()
          return vim.g.xcodebuild_scheme and (' ' .. vim.g.xcodebuild_scheme) or ''
        end,
        color = fg("overlay1"),
        separator = '',
      },
      {
        function()
          return vim.g.xcodebuild_test_plan and ('󰙨 ' .. vim.g.xcodebuild_test_plan) or ''
        end,
        color = fg("green"),
        separator = '',
      },
      {
        function()
          return vim.g.xcodebuild_device_name and (vim.g.xcodebuild_device_name .. " (" .. vim.g.xcodebuild_os .. ")") or ''
        end,
        color = fg("yellow")
      },
      {
        'lsp_status',
        color = fg("overlay1"),
      },
      {
        'filetype',
        color = fg("overlay1"),
      },
    },
  },
})

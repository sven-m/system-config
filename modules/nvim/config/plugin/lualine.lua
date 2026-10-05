local function foreground_of(highlight_group)
  local colour = vim.api.nvim_get_hl(0, { name = highlight_group, link = false }).fg
  return { fg = colour and string.format("#%06x", colour) }
end

local bufnr_component = {
  function()
    return vim.api.nvim_get_current_buf()
  end,
  color = function() return foreground_of("SvenMuted") end,
  padding = { left = 1, right = 0 },
}

require("lualine").setup({
  options = {
    -- lualine re-runs this on ColorScheme and background changes
    theme = function()
      if vim.o.background == "light" then return "adwaita" end
      -- auto prefers a theme named after vim.g.colors_name (catppuccin-mocha's
      -- blue one, should catppuccin be loaded directly); hide the name so it
      -- generates one from the highlight groups
      local colors_name = vim.g.colors_name
      vim.g.colors_name = nil
      local ok, theme = pcall(dofile, vim.api.nvim_get_runtime_file("lua/lualine/themes/auto.lua", false)[1])
      vim.g.colors_name = colors_name
      if not ok then error(theme) end
      return theme
    end,
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
        color = function() return foreground_of("DiagnosticError") end,
      },
      {
        function()
          return vim.g.xcodebuild_scheme and (' ' .. vim.g.xcodebuild_scheme) or ''
        end,
        color = function() return foreground_of("SvenMuted") end,
        separator = '',
      },
      {
        function()
          return vim.g.xcodebuild_test_plan and ('󰙨 ' .. vim.g.xcodebuild_test_plan) or ''
        end,
        color = function() return foreground_of("SvenMuted") end,
        separator = '',
      },
      {
        function()
          return vim.g.xcodebuild_device_name and ("\u{eadb} " .. vim.g.xcodebuild_device_name .. " (" .. vim.g.xcodebuild_os .. ")") or ''
        end,
        color = function() return foreground_of("SvenMuted") end
      },
      {
        'lsp_status',
        color = function() return foreground_of("SvenMuted") end,
      },
      {
        'filetype',
        color = function() return foreground_of("SvenMuted") end,
      },
    },
  },
})

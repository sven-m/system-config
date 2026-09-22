-- lualine

-- lualine renders each window's statusline inside nvim_win_call, so the
-- current buffer here is the one that window shows.
local bufnr_component = {
  function()
    return vim.api.nvim_get_current_buf()
  end,
  color = { fg = "Gray" },
  padding = { left = 1, right = 0 },
}

require("lualine").setup({
  options = {
    globalstatus = false,
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
        color = { fg = "#f38ba8" },
      },
      {
        function()
          return vim.g.xcodebuild_scheme and (' ' .. vim.g.xcodebuild_scheme) or ''
        end,
        color = { fg = "Gray" },
        separator = '',
      },
      {
        function()
          return vim.g.xcodebuild_test_plan and ('󰙨 ' .. vim.g.xcodebuild_test_plan) or ''
        end,
        color = { fg = "#a6e3a1" },
        separator = '',
      },
      {
        function()
          return vim.g.xcodebuild_device_name and (vim.g.xcodebuild_device_name .. " (" .. vim.g.xcodebuild_os .. ")") or ''
        end,
        color = { fg = "#f9e2af" }
      },
      {
        'lsp_status',
        color = { fg = "Gray" },
      },
      {
        'filetype',
        color = { fg = "Gray" },
      },
    },
  },
})

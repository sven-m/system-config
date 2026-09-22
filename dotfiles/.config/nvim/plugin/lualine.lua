-- lualine

-- Component colours come from catppuccin's palette instead of literal hex.
-- get_palette() with no argument resolves the *active* flavour, and lualine
-- re-runs setup() on ColorScheme (it installs that autocmd itself), so these
-- are re-evaluated on a flavour switch rather than staying on mocha's values.
--
-- A function rather than a highlight-group name, deliberately: given a string,
-- lualine *links* the component to that group verbatim, which would throw away
-- the per-mode background it otherwise merges in from the section. A function
-- goes through the same path as a plain table, so only fg is overridden.
local function fg(colour)
  return function()
    return { fg = require("catppuccin.palettes").get_palette()[colour] }
  end
end

-- lualine renders each window's statusline inside nvim_win_call, so the
-- current buffer here is the one that window shows.
local bufnr_component = {
  function()
    return vim.api.nvim_get_current_buf()
  end,
  color = fg("overlay1"),
  padding = { left = 1, right = 0 },
}

require("lualine").setup({
  options = {
    -- The flavour-following theme. catppuccin-mocha and friends pin one
    -- flavour, and there is no theme named plain "catppuccin".
    theme = "catppuccin-nvim",
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

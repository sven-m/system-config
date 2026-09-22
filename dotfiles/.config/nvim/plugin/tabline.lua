-- pill tabline
--
-- The SvenPill* highlight groups this references are ours, not builtin, and are
-- defined in plugin/colorscheme.lua. TabLine (used for the gap between pills)
-- is a builtin group whose catppuccin value we override there too.

vim.o.tabline = "%!v:lua.PillTabline()"

function _G.PillTabline()
  local s = ""
  local tabs = vim.api.nvim_list_tabpages()
  local current = vim.api.nvim_get_current_tabpage()

  for i, tab in ipairs(tabs) do
    local is_active = (tab == current)

    local win = vim.api.nvim_tabpage_get_win(tab)
    local buf = vim.api.nvim_win_get_buf(win)
    local name = vim.api.nvim_buf_get_name(buf)
    name = name ~= "" and vim.fn.pathshorten(vim.fn.fnamemodify(name, ":~:.")) or "[No Name]"

    local hl_left = is_active and "%#SvenPillActiveLeft#" or "%#SvenPillInactiveLeft#"
    local hl_index = is_active and "%#SvenPillActiveIndex#" or "%#SvenPillInactiveIndex#"
    local hl_name = is_active and "%#SvenPillActiveName#" or "%#SvenPillInactiveName#"
    local hl_right = is_active and "%#SvenPillActiveRight#" or "%#SvenPillInactiveRight#"

    s = s .. "%" .. i .. "T"
    s = s .. hl_left .. "\u{e0b6}"
    s = s .. hl_index .. i .. " "
    s = s .. hl_name .. " " .. name
    s = s .. "%T"
    s = s .. hl_right .. "\u{e0b4}"
    s = s .. "%#TabLine# "
  end

  return s
end

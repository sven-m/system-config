-- Prose width. This replaces a BufRead/BufNewFile autocmd on the wiki path:
-- every file under a registered wiki gets this filetype anyway, so the
-- filetype is the more direct hook.
vim.bo.textwidth = 80

vim.keymap.set('n', '<C-M-i>', '<Tab>', { buffer = true, noremap = true })

-- Prose, not code: there is no LSP here, so 'autocomplete' would do nothing but
-- pop a menu of words already on the page after every keystroke. <C-n> still
-- works when a long word is genuinely worth completing.
vim.bo.autocomplete = false

do
  local filename = vim.api.nvim_buf_get_name(0)
  if vim.fn.filereadable(filename) == 0 and filename:match("/diary/%d.*%.md$") then
    vim.schedule(function()
      vim.cmd("silent! %!vimwiki-diary-template '%'")
      vim.cmd("normal! G")
    end)
  end
end

vim.api.nvim_create_autocmd("FileChangedShell", {
  buffer = 0,
  callback = function()
    vim.notify("FileChangedShell: fcs_reason: " .. vim.v.fcs_reason)
    vim.v.fcs_choice = "ask"
    vim.b.suppress_autosave = true
  end,
})

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  buffer = 0,
  callback = function()
    vim.cmd("silent! checktime")

    vim.defer_fn(function()
      if not vim.bo.modified then
        vim.b.suppress_autosave = false
      end

      if vim.b.suppress_autosave then
        return
      end

      vim.cmd("silent! update")
    end, 100)
  end,
})

vim.b.undo_ftplugin = vim.b.undo_ftplugin
  and (vim.b.undo_ftplugin .. " | setlocal textwidth<")
  or "setlocal textwidth<"

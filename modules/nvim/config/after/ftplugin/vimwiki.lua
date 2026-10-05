vim.bo.textwidth = 80

vim.keymap.set('n', 'g<Tab>', '<Tab>', { buffer = true, noremap = true })

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

      -- auto_header modifies freshly followed links; only the first :w is manual
      if vim.fn.filereadable(vim.api.nvim_buf_get_name(0)) == 0 then
        return
      end

      vim.cmd("silent! update")
    end, 100)
  end,
})

vim.b.undo_ftplugin = vim.b.undo_ftplugin
  and (vim.b.undo_ftplugin .. " | setlocal textwidth<")
  or "setlocal textwidth<"

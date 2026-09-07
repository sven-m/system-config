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
    vim.cmd("checktime")

    vim.defer_fn(function()
      if not vim.bo.modified then
        if vim.b.suppress_autosave then
          vim.notify("Loading changes from disk, re-enabling auto-save")
        end

        vim.b.suppress_autosave = false
      end

      if vim.b.suppress_autosave then
        vim.notify("Conflicting changes on disk, preventing auto-save")
        return
      end

      vim.cmd("update")
    end, 100)
  end,
})

do
  local filename = vim.api.nvim_buf_get_name(0)
  if vim.fn.filereadable(filename) == 0 and filename:match("/diary/%d.*%.md$") then
    vim.schedule(function()
      vim.cmd("silent! %!vimwiki-diary-template '%'")
      vim.cmd("normal! G")
    end)
  end
end

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  buffer = 0,
  callback = function(args)
    if vim.bo.modified then
      vim.cmd("update")
      -- if vim.env.TMUX then
        -- vim.fn.system({ "tmux", "display-message", "autosaved (" .. args.event .. ")" })
      -- end
    end
  end,
})

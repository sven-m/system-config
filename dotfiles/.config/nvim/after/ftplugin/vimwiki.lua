local M = {}

if vim.env.NEOVIM_VIMWIKI_MAGIC_MERGE_ENABLED ~= "1" then
  return M
end

-- Write lines to a temp file and return its path
local function write_temp(lines)
  local tmp = vim.fn.tempname()
  vim.fn.writefile(lines, tmp)
  return tmp
end

-- Read file fully into a list of lines
local function read_file(path)
  return vim.fn.readfile(path)
end

vim.api.nvim_create_autocmd("CursorHold", {
  pattern = "*",
  callback = function()
    if vim.bo.filetype == "vimwiki" then
      vim.cmd("checktime")
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
  callback = function(args)
    local buf = args.buf
    M.update_snapshot(buf)
  end,
})

function M.update_snapshot(buf)
  local filename = vim.api.nvim_buf_get_name(buf)
  if filename == "" then return end

  -- Read snapshot from the file on disk
  local snapshot_lines = vim.fn.readfile(filename)

  vim.api.nvim_buf_call(buf, function()
    vim.b.snapshot = snapshot_lines
  end)
end

function M.print_snapshot(buf)
  buf = buf or 0  -- default to current buffer
  vim.api.nvim_buf_call(buf, function()
    for i, line in ipairs(vim.b.snapshot) do
      print(i .. ": " .. line)
    end
  end)
end


vim.api.nvim_create_autocmd("FileChangedShellPost", {
  callback = function(args)
    M.merge_buffer_with_disk(args.buf)
  end
})

-- Core merge function
function M.merge_buffer_with_disk(buf)
  buf = buf or 0  -- default to current buffer
  if vim.bo.modified == false then
    return
  end

  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" then
    vim.notify("Buffer has no file name!", vim.log.levels.ERROR)
    return
  end

  -- Retrieve snapshot from vim.b
  local snapshot = vim.b.snapshot
  if not snapshot then
    vim.notify("No snapshot found for buffer " .. name, vim.log.levels.ERROR)
    return
  end

  -- Prepare temp files
  local buffer_tmp   = write_temp(vim.api.nvim_buf_get_lines(buf, 0, -1, false))
  local snapshot_tmp = write_temp(snapshot)
  local disk_tmp     = write_temp(read_file(name))

  -- Execute merge
  local merged_output = vim.fn.system({
    "git", "merge-file", "-p",
    buffer_tmp,
    snapshot_tmp,
    disk_tmp,
    "--union"
  })

  local merged_lines = vim.split(merged_output, "\n")

  if vim.v.shell_error ~= 0 then
    vim.notify("Merge conflict detected (union merge applied)", vim.log.levels.WARN)
  end

  -- Reset buffer to match disk version so that we can save without warnings later
  vim.api.nvim_command("silent! edit!")

  -- Update buffer with merged result
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, merged_lines)

  M.update_snapshot(buf)
end

-- Optional: create a Neovim command to call it
vim.api.nvim_create_user_command("ManualMerge", function()
  M.merge_buffer_with_disk()
end, {})

-- Optional: create a Neovim command to call it
vim.api.nvim_create_user_command("PrintSnapshot", function()
  M.print_snapshot()
end, {})


return M


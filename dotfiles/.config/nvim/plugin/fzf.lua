-- fzf-lua

local fzf_lua = require('fzf-lua')

fzf_lua.setup({
  fzf_opts = { ["--layout"] = "default" },
})

vim.keymap.set('n', '<leader>f', fzf_lua.builtin)
vim.keymap.set('n', '<leader>ff', fzf_lua.files)
vim.keymap.set('n', '<leader>fg', fzf_lua.live_grep)
vim.keymap.set('n', '<leader>fp', fzf_lua.grep_project)
vim.keymap.set('n', '<leader>fb', fzf_lua.buffers)
vim.keymap.set('n', '<leader>fh', fzf_lua.help_tags)
vim.keymap.set('n', '<leader>fo', fzf_lua.oldfiles)
vim.keymap.set('n', '<leader>fs', fzf_lua.lsp_document_symbols)
vim.keymap.set('n', '<leader>fws', fzf_lua.lsp_workspace_symbols)
vim.keymap.set('n', '<leader>fe', fzf_lua.diagnostics_workspace)
vim.keymap.set('n', '<leader>fr', fzf_lua.lsp_references)
vim.keymap.set('n', '<leader>fd', fzf_lua.lsp_definitions)
vim.keymap.set('n', '<leader>fl', fzf_lua.lsp_finder)
vim.keymap.set('n', '<leader>fq', fzf_lua.quickfix)
vim.keymap.set({ 'n', 'v' }, '<leader>fa', fzf_lua.lsp_code_actions)

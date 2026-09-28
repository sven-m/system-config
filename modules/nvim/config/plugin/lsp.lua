vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Enable LSP completion and the pickers that need a server',
  callback = function(args)
    vim.lsp.completion.enable(true, args.data.client_id, args.buf)

    vim.bo[args.buf].autocomplete = true

    vim.bo[args.buf].complete = "o,.^10,w^5,b^5"

    local fzf_lua = require('fzf-lua')
    local opts = { buffer = args.buf }

    vim.keymap.set('n', '<leader>fs', fzf_lua.lsp_document_symbols, opts)
    vim.keymap.set('n', '<leader>fws', fzf_lua.lsp_workspace_symbols, opts)
    vim.keymap.set('n', '<leader>fr', fzf_lua.lsp_references, opts)
    vim.keymap.set('n', '<leader>fd', fzf_lua.lsp_definitions, opts)
    vim.keymap.set('n', '<leader>fl', fzf_lua.lsp_finder, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>fa', fzf_lua.lsp_code_actions, opts)
  end,
})

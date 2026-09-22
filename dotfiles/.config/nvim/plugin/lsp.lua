-- lsp for iOS development

vim.lsp.config('sourcekit', {
  cmd = { vim.fn.trim(vim.fn.system('xcrun --find sourcekit-lsp 2>/dev/null')) },
  filetypes = { "swift", "objc", "objcpp" },
  root_markers = { '.git' }, -- '*.xcworkspace', '*.xcodeproj', 'Package.swift', 
})

vim.lsp.enable('sourcekit')

-- No keymaps here: 0.12 provides them all. K hover, i_CTRL-S signature help,
-- gra/gri/grn/grr/grt/grx/gO, <C-w>d for the diagnostic float, gq{motion} for
-- range formatting via the 'formatexpr' the client sets, and g CTRL-] for
-- go-to-definition -- the client sets 'tagfunc', so a normal-mode tag command
-- runs textDocument/definition rather than reading a tags file, and the g
-- prefix turns the silent jump-to-first into a picker when a symbol has
-- several definitions. ]t and [t walk the match list afterwards.
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Enable LSP completion and the pickers that need a server',
  callback = function(args)
    -- Not `autotrigger = true`: that only fires on the server's own
    -- triggerCharacters, which for sourcekit are just "." and "(", and
    -- 'autocomplete' already opens the popup on every keystroke. enable() is
    -- still required -- it is what makes <C-y> apply snippets and additional
    -- text edits, and what resolves the docs shown by "popup".
    vim.lsp.completion.enable(true, args.data.client_id, args.buf)

    -- The popup-as-you-type only earns its keep once a server can answer, so
    -- it is enabled here rather than globally.
    vim.bo[args.buf].autocomplete = true

    -- "o" runs 'omnifunc', which the LSP client points at vim.lsp.omnifunc when
    -- a server attaches -- that is how sourcekit-lsp gets in. It is async: the
    -- request goes out, the menu fills when the reply lands, and sources listed
    -- first get the largest time slice. The caret limits keep the cheap
    -- text-scraping sources from burying the LSP items; "u" (unloaded buffers)
    -- and "t" (tags) are dropped because sourcekit already covers what they
    -- would find. Buffers with no server keep the default sources.
    vim.bo[args.buf].complete = "o,.^10,w^5,b^5"

    -- These pickers are dead without a server, so they follow the client
    -- rather than the filetype. The rest of <leader>f* is global, in
    -- plugin/fzf.lua.
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

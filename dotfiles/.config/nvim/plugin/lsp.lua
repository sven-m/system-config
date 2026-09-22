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
  desc = 'Enable LSP completion',
  callback = function(args)
    -- Not `autotrigger = true`: that only fires on the server's own
    -- triggerCharacters, which for sourcekit are just "." and "(", and
    -- 'autocomplete' already opens the popup on every keystroke. enable() is
    -- still required -- it is what makes <C-y> apply snippets and additional
    -- text edits, and what resolves the docs shown by "popup".
    vim.lsp.completion.enable(true, args.data.client_id, args.buf)
  end,
})

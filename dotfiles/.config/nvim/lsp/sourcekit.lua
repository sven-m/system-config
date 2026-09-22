-- sourcekit-lsp, for Swift / Objective-C.
--
-- A config table rather than a vim.lsp.config() call in plugin/: files under
-- lsp/ are read when the config is resolved, which is when a client starts.
-- The xcrun shell-out below therefore happens the first time a Swift buffer
-- attaches, instead of on every single nvim startup.
--
-- See :h lsp-config-merge for the precedence rules. Nothing else here provides
-- an lsp/sourcekit.lua, so this table is the whole config; a vim.lsp.config()
-- call elsewhere would still outrank it if one is ever added.

return {
  cmd = { vim.fn.trim(vim.fn.system('xcrun --find sourcekit-lsp 2>/dev/null')) },
  filetypes = { "swift", "objc", "objcpp" },
  root_markers = { '.git' }, -- '*.xcworkspace', '*.xcodeproj', 'Package.swift', 
}

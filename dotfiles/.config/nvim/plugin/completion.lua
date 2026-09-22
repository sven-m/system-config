-- insert mode completion
--
-- The LSP half of this (vim.lsp.completion.enable on LspAttach) is in
-- plugin/lsp.lua.
--
-- No completion plugin: 'autocomplete' (0.12) opens the popup as you type and
-- collects candidates from every source in 'complete', in order.
--
-- 'complete' itself is set per buffer on LspAttach, not here -- the source list
-- is written for a server answering, so it belongs where one is attached.
vim.o.autocomplete = true

-- The knob to turn first if the popup feels twitchy: raise it slightly above
-- your typing speed so it stops opening mid-word.
vim.o.autocompletedelay = 100

-- 'autocomplete' forces "noselect" and only honours fuzzy/longest/popup/
-- preinsert/preview. The rest of this applies to manual <C-x> completion, which
-- still works and suspends autocompletion while it runs.
--
-- "fuzzy" earns its place in Swift: UIVC matches UIViewController, but it is
-- not Swift-specific and stays global; long identifiers are everywhere. Its one
-- cost is LSP-only: nvim re-ranks by fuzzy score and discards the server's
-- sortText -- add "nosort" to keep sourcekit's own ordering while still
-- filtering fuzzily.
vim.opt.completeopt = { "menuone", "noselect", "popup", "fuzzy" }

-- Swift symbol names and their signature previews are both long.
vim.o.pumheight = 12
vim.o.pummaxwidth = 60

-- No completion keymaps: <C-n>/<C-p> walk the menu and <C-y> accepts, which is
-- what ins-completion has always done. Nothing is ever preselected, so typing
-- never inserts text on its own and <CR> stays a newline. Only on <C-y> does
-- the LSP side apply snippets, additional text edits (imports) and commands --
-- sourcekit returns calls as snippets, one tabstop per argument, and <Tab>
-- jumps between them via Neovim's own default snippet mapping.

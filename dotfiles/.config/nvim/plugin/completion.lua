-- insert mode completion
--
-- The LSP half of this (vim.lsp.completion.enable on LspAttach) is in
-- plugin/lsp.lua.
--
-- No completion plugin: 'autocomplete' (0.12) opens the popup as you type and
-- collects candidates from every source in 'complete', in order.
--
-- Both of those are set per buffer on LspAttach rather than here. Without a
-- server the popup has nothing to offer but words already on the page, so it
-- stays off by default and <C-n>/<C-x> remain for when a completion is
-- genuinely wanted. 'autocompletedelay' is global-only and simply has no
-- effect in buffers where 'autocomplete' is off.

-- The knob to turn first if the popup feels twitchy: raise it slightly above
-- your typing speed so it stops opening mid-word.
vim.o.autocompletedelay = 100

-- Where 'autocomplete' is on it forces "noselect" and only honours
-- fuzzy/longest/popup/preinsert/preview. The rest applies to manual <C-x>
-- completion, which still works and suspends autocompletion while it runs --
-- and which is now the only kind in buffers with no server, so the explicit
-- "noselect" below is what keeps typing from inserting text there.
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

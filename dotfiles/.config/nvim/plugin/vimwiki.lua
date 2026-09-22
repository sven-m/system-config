-- vimwiki
--
-- This must be sourced before the vimwiki package. plugin/vimwiki.vim reads
-- g:vimwiki_list at source time to build s:known_extensions, then bakes the
-- result straight into its BufRead/BufEnter/BufWinEnter autocmd patterns. Set
-- these any later -- from after/plugin, say -- and vimwiki has already
-- registered itself for the default .wiki only, so .md wiki files are never
-- recognised at all. Files in plugin/ are sourced before packages, so here is
-- early enough.

vim.g.vimwiki_list = {
  {
    path = "~/Documents/vimwiki/",
    syntax = "markdown",
    ext = ".md",
    auto_diary_index = 1,
    auto_generate_links = 1,
    generated_links_caption = 1,
    listsyms = ' x',
    diary_frequency = "weekly"
  }
}
vim.g.vimwiki_auto_header = 1
vim.g.vimwiki_links_header = "All Files"
vim.g.vimwiki_global_ext = 0
-- 'custom' is vimwiki's "set no fold options at all" branch (an explicit
-- do-nothing in s:set_windowlocal_options). With 'expr' it ran
--   setlocal foldmethod=expr foldexpr=VimwikiFoldLevel(v:lnum)
-- on every BufWinEnter. Those options are window-local and nothing ever reset
-- them, so the next buffer opened in that window kept folding by vimwiki's
-- markdown-header logic. Treesitter folding (plugin/options.lua) now applies
-- everywhere, wiki buffers included -- see the parser registration below.
vim.g.vimwiki_folding = 'custom'

-- Parse vimwiki buffers as markdown: treesitter highlighting, and the
-- treesitter foldexpr set in plugin/options.lua.
vim.treesitter.language.register("markdown", "vimwiki")

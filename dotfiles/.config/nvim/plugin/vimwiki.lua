-- this file is expected to be loaded before vimwiki.vim which is necessary for it to work

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
-- custom disables vimwiki's folding implementation entirely. this is
-- desired, because vimwiki folding settings are applied window-local,
-- which is too broad.
vim.g.vimwiki_folding = 'custom'

-- Parse vimwiki buffers as markdown: treesitter highlighting, and the
-- treesitter foldexpr set in plugin/options.lua.
vim.treesitter.language.register("markdown", "vimwiki")

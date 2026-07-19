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

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = vim.fn.expand("~") .. "/Documents/vimwiki/**",
  callback = function()
    vim.opt_local.textwidth = 80
  end,
})

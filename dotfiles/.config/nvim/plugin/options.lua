-- Editor options. Nothing here needs a plugin to be loaded.

vim.opt.updatetime = 1000
vim.opt.list = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showmode = false
vim.opt.splitright = true

-- indentation, formatting
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.textwidth = 120

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- rendering text
vim.opt.showmatch = true 
vim.opt.linebreak = true
vim.opt.breakindent = true

-- folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = false

-- command line / :find completion
vim.opt.path:append("**")
vim.opt.path:append("*/.config/**")
vim.o.wildmode = "longest:full,full"
vim.opt.wildoptions:append("fuzzy")
vim.opt.wildignore:append("build/*")

-- gitsigns

require("gitsigns").setup({
  base = "HEAD",
  on_attach = function(bufnr)
    local gs = require("gitsigns")
    local opts = { buffer = bufnr }

    vim.keymap.set("n", "]c", function() gs.nav_hunk("next") end, opts)
    vim.keymap.set("n", "[c", function() gs.nav_hunk("prev") end, opts)

    vim.keymap.set("n", "<leader>gh", gs.preview_hunk_inline, opts)
    vim.keymap.set("n", "<leader>gb", gs.blame_line, opts)
  end,
})

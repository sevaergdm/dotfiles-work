vim.pack.add({
  "https://github.com/MattiasMTS/pjollrig.nvim",
})

require("pjollrig").setup({})

vim.keymap.set("n", "<leader>pa", ":Pjollrig add<CR>", {})
vim.keymap.set("n", "<leader>pl", ":Pjollrig list<CR>", {})


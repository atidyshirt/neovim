vim.pack.add({
  { src = "https://github.com/anuvyklack/windows.nvim" },
  { src = "https://github.com/anuvyklack/middleclass", opt = true },
})

vim.o.winwidth = 30
vim.o.winminwidth = 30
vim.o.equalalways = true

require("windows").setup({
  autowidth = { enable = true },
})

vim.keymap.set("n", "<leader>m", "<cmd>WindowsMaximize<CR>", { desc = "Zoom window" })


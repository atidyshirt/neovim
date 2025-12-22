vim.pack.add({
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons", opt = true },
})

require("oil").setup({
  columns = { "icon" },
  keymaps = {
    ["<esc>"] = "actions.close",
    ["<C-h>"] = false,
    ["<C-l>"] = false,
    ["<C-k>"] = false,
    ["<C-j>"] = false,
  },
  win_options = { signcolumn = "auto" },
  lsp_file_methods = { autosave_changes = true },
  view_options = { show_hidden = true },
})

vim.keymap.set("n", "<leader>e", ":Oil<CR>", { desc = "Explorer (Oil)", remap = true })

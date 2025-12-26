vim.pack.add({
  { src = "https://github.com/sindrets/diffview.nvim" },
  { src = "https://github.com/tpope/vim-fugitive" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("gitsigns").setup({
      current_line_blame = false,
      current_line_blame_opts = {
        delay = 300,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
    })

    vim.keymap.set("n", "<leader>hs", ":Gitsigns stage_hunk<CR>")
    vim.keymap.set("n", "<leader>hu", ":Gitsigns undo_stage_hunk<CR>")
    vim.keymap.set("n", "<leader>hS", ":Gitsigns stage_buffer<CR>")
    vim.keymap.set("n", "<leader>hd", ":Gitsigns diffthis<CR>")
    vim.keymap.set("n", "<leader>hD", function()
      require("gitsigns").diffthis("~")
    end)
  end
})

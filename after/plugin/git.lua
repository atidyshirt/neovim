local lazyload = require("utils.lazyload")

lazyload({
  packs = {
    { src = "https://github.com/sindrets/diffview.nvim" },
    { src = "https://github.com/tpope/vim-fugitive" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
  },
  trigger = { "BufReadPost", "BufNewFile" }, -- Git tools on first real file
  setup = function()
    require("gitsigns").setup({
      current_line_blame = false,
      current_line_blame_opts = { delay = 300 },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
    })
  end,
  keymaps = {
    ["<leader>hs"] = ":Gitsigns stage_hunk<CR>",
    ["<leader>hu"] = ":Gitsigns undo_stage_hunk<CR>",
    ["<leader>hS"] = ":Gitsigns stage_buffer<CR>",
    ["<leader>hd"] = ":Gitsigns diffthis<CR>",
    ["<leader>hD"] = function() require("gitsigns").diffthis("~") end,
  },
})

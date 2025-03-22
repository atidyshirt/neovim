return {
  { "unblevable/quick-scope" },
  { "tpope/vim-surround" },
  { "tpope/vim-sleuth" },
  { "vitalk/vim-shebang" },
  {
    'numToStr/Comment.nvim',
    opts = {
    },
    lazy = false,
  },

  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },

  {
    "Wansmer/treesj",
    keys = { { "<leader>lj", "<cmd>TSJToggle<cr>", desc = "Split / Join" } },
    opts = { use_default_keymaps = false },
  },
}

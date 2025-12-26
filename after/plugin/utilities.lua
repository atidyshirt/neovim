vim.pack.add({
  { src = "https://github.com/unblevable/quick-scope" },
  { src = "https://github.com/tpope/vim-surround" },
  { src = "https://github.com/tpope/vim-sleuth" },
  { src = "https://github.com/vitalk/vim-shebang" },
  { src = "https://github.com/mtdl9/vim-log-highlighting" },
  { src = "https://github.com/numToStr/Comment.nvim" },
  { src = "https://github.com/laytan/cloak.nvim" },
})

require("Comment").setup()

require('cloak').setup({
  enabled = true,
  cloak_character = '*',
  highlight_group = 'Comment',
  cloak_length = nil,
  try_all_patterns = true,
  cloak_telescope = true,
  cloak_on_leave = false,
  patterns = {
    {
      file_pattern = { '.env*', '*.tfvars' },
      cloak_pattern = { '=.+', ':.+' },
      replace = nil,
    },
  },
})

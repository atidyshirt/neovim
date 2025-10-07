return {
  {
    'brenoprata10/nvim-highlight-colors',
    config = true,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      input = { enabled = true },
      notifier = {
        enabled = true,
        style = 'minimal',
        timeout = 10000,
        top_down = false,
        margin = { bottom = 1 },
        padding = true,
      },
      statuscolumn = { enabled = true },
      indent = { enabled = true },
      picker = {
        enabled = true,
        win = {input = {keys = {}}},
      },
    },
  },
}

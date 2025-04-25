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
        style = 'compact',
        timeout = 10000,
        margin = { bottom = 1 },
        padding = true,
        top_down = false,
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

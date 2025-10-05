return {
  {
    "anuvyklack/windows.nvim",
    event = "WinNew",
    dependencies = {
      { "anuvyklack/middleclass" },
    },
    opts = {
      autowidth = { enable = true },
    },
    keys = { { "<leader>m", "<cmd>WindowsMaximize<CR>", desc = "Zoom window" } },
    init = function()
      vim.o.winwidth = 30
      vim.o.winminwidth = 30
      vim.o.equalalways = true
    end,
  },
}

return {
  {
    "ramilito/kubectl.nvim",
    version = "2.10.*",
    dependencies = "saghen/blink.download",
    -- NOTE: Requires nightly release of cargo
    build = "cargo build --release",
    config = function()
      ---@diagnostic disable-next-line: missing-parameter
      require("kubectl").setup()
      vim.keymap.set(
        "n",
        "<leader>k",
        '<cmd>lua require("kubectl").toggle({ tab = true })<cr>',
        { noremap = true, silent = true }
      )
    end,
  },
}

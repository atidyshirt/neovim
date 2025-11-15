return {
  {
    "OXY2DEV/markview.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("markview").setup({
        preview = {
          modes = { "n", "no", "i", "c" },
          hybrid_modes = { "i", "n" },
          callbacks = {
            on_enable = function(_, win)
              vim.wo[win].conceallevel = 2
              vim.wo[win].concealcursor = "nc"
            end,
          },
        },
      })
    end,
  },
}

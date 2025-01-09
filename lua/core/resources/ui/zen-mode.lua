return {
  {
    'stevearc/quicker.nvim',
    event = "FileType qf",
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {
      keys = {
        {
          ">",
          function()
            require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
          end,
          desc = "Expand quickfix context",
        },
        {
          "<",
          function()
            require("quicker").collapse()
          end,
          desc = "Collapse quickfix context",
        },
      },
    }
  },
  {
    "folke/zen-mode.nvim",
    opts = {
      window = {
        width = function()
          return math.min(120, vim.o.columns * 0.75)
        end,
      },
      options = {
        number = false,
        relativenumber = false,
        foldcolumn = "0",
        list = false,
        showbreak = "NONE",
        signcolumn = "no",
      },
      plugins = {
        options = {
          cmdheight = 1,
          laststatus = 0,
        },
      },
    }
  },
}

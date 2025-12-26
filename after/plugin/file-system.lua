local lazyload = require("utils.lazyload")

lazyload({
  packs = {
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/stevearc/oil.nvim" },
  },

  trigger = "CmdUndefined",
  pattern = "Oil",

  setup = function()
    require("nvim-web-devicons").setup({
      color_icons = true,
      default = true,
      strict = true,
    })

    require("oil").setup({
      default_file_explorer = true,
      columns = { "icon" },
      view_options = { show_hidden = true },
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["-"]   = "actions.parent",
        ["_"]   = "actions.open_cwd",
        ["q"]   = "actions.close",
      },
    })
  end,
})

vim.keymap.set("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Open parent directory" })

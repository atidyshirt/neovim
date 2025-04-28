local env = require("config.environment")

return {
  {
    "stevearc/oil.nvim",
    dependencies = {
      {
        "nvim-tree/nvim-web-devicons",
        enabled = env.nerd_font_enabled
      },
    },
    opts = {
      columns = { "icon" },
      keymaps = {
        ["<esc>"] = "actions.close",
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        ["<C-k>"] = false,
        ["<C-j>"] = false,
        ["<M-h>"] = "actions.select_split",
      },
      win_options = {
        signcolumn = "auto",
      },
      lsp_file_methods = {
        autosave_changes = true,
      },
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name, _)
          local folder_skip = { "dev-tools.locks", "dune.lock", "_build" }
          return vim.tbl_contains(folder_skip, name)
        end,
      },
    },
    keys = {
      { "<leader>e", ":Oil<cr>", desc = "Explorer (Oil)", remap = true },
    },
    config = true,
  },
}

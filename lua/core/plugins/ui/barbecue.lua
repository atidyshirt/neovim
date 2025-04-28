local Icon = require("config.icons.icons")
local env = require("config.environment")

return {
  {
    "utilyre/barbecue.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "SmiteshP/nvim-navic",
      {
        "nvim-tree/nvim-web-devicons",
        enabled = env.nerd_font_enabled
      },
    },
    opts = {
      attach_navic = false,
      theme = "auto",
      include_buftypes = { "" },
      exclude_filetypes = { "gitcommit", "Trouble", "toggleterm" },
      show_modified = false,
      symbols = Icon.bbq_symbols,
      kinds = Icon.kinds,
    },
  },
}

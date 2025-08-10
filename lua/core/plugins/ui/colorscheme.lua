local util = require("core.util")

return {
  {
    "atidyshirt/gruvbox-baby",
    priority = 1000,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "latte",
      background = {
        light = "latte",
        dark = "mocha",
      },
    },
    priority = 1000,
  },
  {
    "f-person/auto-dark-mode.nvim",
    enabled = util.str_to_bool(vim.env.auto_dark_mode_enabled),
    opts = {
      set_dark_mode = function()
        vim.cmd('colorscheme gruvbox-baby')
        vim.api.nvim_set_option_value("background", "dark", {})
      end,
      set_light_mode = function()
        vim.cmd('colorscheme catppuccin')
        vim.api.nvim_set_option_value("background", "light", {})
      end,
      update_interval = 3000,
      fallback = "dark"
    },
  },
}

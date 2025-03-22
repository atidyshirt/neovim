return {
  {
    "sainnhe/gruvbox-material",
    lazy = true,
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
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      set_dark_mode = function()
        vim.cmd('colorscheme gruvbox-material')
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

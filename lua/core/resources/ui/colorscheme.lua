return {
  -- {
  --   "sainnhe/gruvbox-material",
  --   lazy = true,
  -- },
  -- trying it out due to broken support on some things
  {
    'f4z3r/gruvbox-material.nvim',
    name = 'gruvbox-material',
    lazy = false,
    priority = 1000,
    opts = {},
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

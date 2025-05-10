local icons = require('config.icons.icons').getIcons()
local env = require("config.environment")

return {
  {
    "nvim-lualine/lualine.nvim",
    enabled = env.nerd_font_enabled,
    event = "VeryLazy",
    opts = {
      icons_enabled = true,
      theme = 'auto',
      component_separators = { left = icons.bbq_symbols.modified, right = icons.bbq_symbols.modified},
      section_separators = { left = ' ', right = ' ' },
      sections = {
        lualine_a = { { 'mode', separator = { left = '', right = '' } } },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = {'filename'},
        lualine_x = {'filetype'},
        lualine_y = {},
        lualine_z = {},
      },
    },
    config = true
  },
}

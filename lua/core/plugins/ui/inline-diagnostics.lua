local icons = require('config.icons.icons').getIcons()
local util = require("core.util")

return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    dependencies = {
      { "mfussenegger/nvim-lint" }
    },
    event = "LspAttach",
    lazy = false,
    config = function()
      require('tiny-inline-diagnostic').setup({
        preset = 'powerline',
        options = {
          overwrite_events = { "DiagnosticChanged" },
          multilines = true,
        },
        hi = {
          error = "DiagnosticSignError",
          warn = "DiagnosticSignWarn",
          info = "DiagnosticSignInfo",
          hint = "DiagnosticSignHint",
          arrow = "NonText",
          background = "CursorLine",
          mixing_color = util.get_highlight_value("String").background,
        },
        format = function(diagnostic)
          if diagnostic.source then
            return string.format("%s [%s]", diagnostic.message, diagnostic.source)
          end
          return diagnostic.message
        end,
      })
    end
  }
}


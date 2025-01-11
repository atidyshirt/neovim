return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy", -- Or `LspAttach`
    priority = 1000, -- needs to be loaded in first
    config = function()
      vim.diagnostic.config({ virtual_text = false })
      require('tiny-inline-diagnostic').setup({
        preset = 'modern',
        options = {
          multilines = true,
        },
        hi = {
          error = "DiagnosticSignError",
          warn = "DiagnosticSignWarn",
          info = "DiagnosticSignInfo",
          hint = "DiagnosticSignHint",
          arrow = "NonText",
          background = "CursorLine",
          mixing_color = "#323232",
        },
      })
    end
  }
}

